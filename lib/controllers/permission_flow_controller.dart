import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import 'location_controller.dart';

enum PermissionScreen { bluetoothRequired, locationRequired, main }

/// Listens to app lifecycle and notifies [PermissionFlowController] when app resumes.
/// Used to re-check Bluetooth and location state when user returns from settings.
class _PermissionFlowLifecycleObserver with WidgetsBindingObserver {
  _PermissionFlowLifecycleObserver(this._controller);

  final PermissionFlowController _controller;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _controller.recheckPermissionsOnResume();
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
  late final _lifecycleObserver = _PermissionFlowLifecycleObserver(this);

  final Rx<PermissionScreen> currentScreen = PermissionScreen.bluetoothRequired.obs;

  @override
  void onInit() {
    super.onInit();
    _location.loadStoredPosition();
    _listenBluetooth();
    WidgetsBinding.instance.addObserver(_lifecycleObserver);
    _resolveInitialScreen();
  }

  @override
  void onClose() {
    _btSubscription?.cancel();
    WidgetsBinding.instance.removeObserver(_lifecycleObserver);
    super.onClose();
  }

  /// Called when app comes to foreground. Re-checks Bluetooth and location
  /// and navigates to the appropriate gate screen if something was turned off.
  Future<void> recheckPermissionsOnResume() async {
    await _recheckPermissionsAndUpdateScreen();
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
  Future<void> _recheckPermissionsAndUpdateScreen() async {
    final btOn = await _isBluetoothOn();
    if (!btOn) {
      currentScreen.value = PermissionScreen.bluetoothRequired;
      return;
    }

    await _location.checkAndRefresh();
    if (!_location.isGranted || !_location.hasStoredPosition) {
      currentScreen.value = PermissionScreen.locationRequired;
      return;
    }

    currentScreen.value = PermissionScreen.main;
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
