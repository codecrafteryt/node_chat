import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import 'location_controller.dart';

enum PermissionScreen { bluetoothRequired, locationRequired, main }

/// Interval for polling location/Bluetooth state while app is in foreground.
/// Mirrors "runtime listener" behavior for location (no OS stream available).
const Duration _kLocationPollInterval = Duration(seconds: 5);

/// Listens to app lifecycle and notifies [PermissionFlowController] when app
/// resumes or pauses. Used to re-check permissions on resume and to start/stop
/// the location runtime poll (same idea as Bluetooth adapter listener).
class _PermissionFlowLifecycleObserver with WidgetsBindingObserver {
  _PermissionFlowLifecycleObserver(this._controller);

  final PermissionFlowController _controller;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _controller.onAppResumed();
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        _controller.onAppPaused();
        break;
      default:
        break;
    }
  }
}

/// Controls the permission gate flow: Bluetooth → Location → Main.
/// Listens to Bluetooth adapter state and app lifecycle to keep the shown screen
/// in sync with runtime changes (e.g. user turns BT/location off while app is open).
class PermissionFlowController extends GetxController {
  PermissionFlowController({
    required LocationController locationController,
  }) : _location = locationController;

  final LocationController _location;
  StreamSubscription<BluetoothAdapterState>? _btSubscription;
  Timer? _locationPollTimer;
  late final _lifecycleObserver = _PermissionFlowLifecycleObserver(this);

  final Rx<PermissionScreen> currentScreen = PermissionScreen.bluetoothRequired.obs;

  @override
  void onInit() {
    super.onInit();
    _location.loadStoredPosition();
    _listenBluetooth();
    WidgetsBinding.instance.addObserver(_lifecycleObserver);
    _resolveInitialScreen().then((_) => _startLocationPoll());
  }

  @override
  void onClose() {
    _btSubscription?.cancel();
    _stopLocationPoll();
    WidgetsBinding.instance.removeObserver(_lifecycleObserver);
    super.onClose();
  }

  /// Called when app comes to foreground. Re-checks permissions and starts
  /// the location runtime poll (so toggling location on/off is detected).
  void onAppResumed() {
    recheckPermissionsOnResume();
    _startLocationPoll();
  }

  /// Called when app goes to background. Stops the location poll to save battery.
  void onAppPaused() {
    _stopLocationPoll();
  }

  /// Called when app comes to foreground. Re-checks Bluetooth and location
  /// and navigates to the appropriate gate screen if something was turned off.
  Future<void> recheckPermissionsOnResume() async {
    await _recheckPermissionsAndUpdateScreen();
  }

  void _startLocationPoll() {
    _locationPollTimer?.cancel();
    _locationPollTimer = Timer.periodic(_kLocationPollInterval, (_) {
      _recheckPermissionsAndUpdateScreenLight();
    });
  }

  void _stopLocationPoll() {
    _locationPollTimer?.cancel();
    _locationPollTimer = null;
  }

  void _listenBluetooth() {
    _btSubscription = FlutterBluePlus.adapterState.listen((BluetoothAdapterState state) {
      if (state == BluetoothAdapterState.on) {
        _onBluetoothTurnedOn();
      } else if (state == BluetoothAdapterState.off || state == BluetoothAdapterState.unknown) {
        _onBluetoothTurnedOff();
      }
    });
  }

  /// Single source of truth: evaluate BT + location and set [currentScreen].
  /// Full check: also fetches position (getCurrentPosition). Use for initial
  /// resolve, resume, and "Check Again" button.
  Future<void> _recheckPermissionsAndUpdateScreen() async {
    final btOn = await _isBluetoothOn();
    if (!btOn) {
      if (currentScreen.value != PermissionScreen.bluetoothRequired) {
        debugPrint('[PermissionFlow] Bluetooth off → Bluetooth screen');
        currentScreen.value = PermissionScreen.bluetoothRequired;
      }
      return;
    }

    await _location.checkAndRefresh();
    if (!_location.isGranted || !_location.hasStoredPosition) {
      if (currentScreen.value != PermissionScreen.locationRequired) {
        debugPrint('[PermissionFlow] Location not ready → Location screen');
        currentScreen.value = PermissionScreen.locationRequired;
      }
      return;
    }

    if (currentScreen.value != PermissionScreen.main) {
      debugPrint('[PermissionFlow] BT + Location OK → Main (Group Chat)');
      currentScreen.value = PermissionScreen.main;
    }
  }

  /// Light check for the 5s poll: permission + service only, no getCurrentPosition.
  /// Avoids repeated timeout errors when GPS is slow or unavailable indoors.
  Future<void> _recheckPermissionsAndUpdateScreenLight() async {
    final btOn = await _isBluetoothOn();
    if (!btOn) {
      if (currentScreen.value != PermissionScreen.bluetoothRequired) {
        debugPrint('[PermissionFlow] Bluetooth off → Bluetooth screen');
        currentScreen.value = PermissionScreen.bluetoothRequired;
      }
      return;
    }

    await _location.checkLight();
    if (!_location.isGranted || !_location.hasStoredPosition) {
      if (currentScreen.value != PermissionScreen.locationRequired) {
        debugPrint('[PermissionFlow] Location not ready → Location screen');
        currentScreen.value = PermissionScreen.locationRequired;
      }
      return;
    }

    if (currentScreen.value != PermissionScreen.main) {
      debugPrint('[PermissionFlow] BT + Location OK → Main (Group Chat)');
      currentScreen.value = PermissionScreen.main;
    }
  }

  Future<void> _resolveInitialScreen() async {
    await _recheckPermissionsAndUpdateScreen();
  }

  Future<bool> _isBluetoothOn() async {
    try {
      return await FlutterBluePlus.isOn;
    } catch (_) {
      return false;
    }
  }

  void _onBluetoothTurnedOn() {
    if (currentScreen.value != PermissionScreen.bluetoothRequired) return;
    currentScreen.value = PermissionScreen.locationRequired;
  }

  void _onBluetoothTurnedOff() {
    currentScreen.value = PermissionScreen.bluetoothRequired;
  }

  /// Call when user taps "Enable Bluetooth". Triggers system dialog on Android; opens settings on iOS.
  Future<void> requestBluetoothOn() async {
    try {
      await FlutterBluePlus.turnOn(timeout: 60);
    } catch (_) {
      await _openAppSettingsForBluetooth();
    }
  }

  Future<void> _openAppSettingsForBluetooth() async {
    await openAppSettings();
  }

  /// Call when user returns from location settings; re-check and go to main if ready.
  Future<void> checkLocationAndProceed() async {
    await _location.requestPermission();
    await _recheckPermissionsAndUpdateScreen();
  }

  void goToMain() {
    currentScreen.value = PermissionScreen.main;
  }
}
