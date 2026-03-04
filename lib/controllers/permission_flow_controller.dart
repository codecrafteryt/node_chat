import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../utils/constants.dart';
import 'location_controller.dart';

enum PermissionScreen { bluetoothRequired, locationRequired, main }

/// Decides which screen to show (Bluetooth → Location → Main) and handles Bluetooth enable.
class PermissionFlowController extends GetxController {
  PermissionFlowController({
    required LocationController locationController,
  }) : _location = locationController;

  final LocationController _location;
  StreamSubscription<BluetoothAdapterState>? _btSubscription;

  final Rx<PermissionScreen> currentScreen = PermissionScreen.bluetoothRequired.obs;

  @override
  void onInit() {
    super.onInit();
    _location.loadStoredPosition();
    _listenBluetooth();
    _resolveInitialScreen();
  }

  @override
  void onClose() {
    _btSubscription?.cancel();
    super.onClose();
  }

  void _listenBluetooth() {
    _btSubscription = FlutterBluePlus.adapterState.listen((state) {
      if (state == BluetoothAdapterState.on) {
        _onBluetoothTurnedOn();
      }
    });
  }

  void _resolveInitialScreen() async {
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

  Future<bool> _isBluetoothOn() async {
    try {
      return await FlutterBluePlus.isOn;
    } catch (_) {
      return false;
    }
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

  void _onBluetoothTurnedOn() {
    if (currentScreen.value != PermissionScreen.bluetoothRequired) return;
    currentScreen.value = PermissionScreen.locationRequired;
  }

  /// Call when user returns from location settings; re-check and go to main if ready.
  Future<void> checkLocationAndProceed() async {
    await _location.requestPermission();
    if (_location.isGranted && _location.hasStoredPosition) {
      currentScreen.value = PermissionScreen.main;
    }
  }

  void goToMain() {
    currentScreen.value = PermissionScreen.main;
  }
}
