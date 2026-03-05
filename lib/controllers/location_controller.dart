import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart' as ph;
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/constants.dart';

enum LocationStatus {
  denied,
  disabled,
  granted,
}

class LocationController extends GetxController {
  LocationController({required SharedPreferences prefs}) : _prefs = prefs;

  final SharedPreferences _prefs;
  final Rx<LocationStatus> status = LocationStatus.denied.obs;
  final RxDouble lat = 0.0.obs;
  final RxDouble lng = 0.0.obs;

  static const _timeLimit = Duration(seconds: 15);

  @override
  void onInit() {
    super.onInit();
    checkAndRefresh();
  }

  /// Refreshes status and fetches position if allowed; saves lat/lng to prefs.
  /// Logs status and position (lat/lng + address) for debugging.
  Future<void> checkAndRefresh() async {
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      status.value = LocationStatus.denied;
      debugPrint('[Location] Permission denied');
      return;
    }
    if (permission == LocationPermission.deniedForever) {
      status.value = LocationStatus.denied;
      debugPrint('[Location] Permission denied forever');
      return;
    }

    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      status.value = LocationStatus.disabled;
      debugPrint('[Location] Service disabled');
      return;
    }

    status.value = LocationStatus.granted;
    await _fetchAndSavePosition();
  }

  /// Updates [status] from permission + location service only. Does NOT fetch
  /// position (no getCurrentPosition). Use for the runtime poll so we don't
  /// trigger repeated timeouts when GPS is slow or unavailable.
  Future<void> checkLight() async {
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      status.value = LocationStatus.denied;
      return;
    }
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      status.value = LocationStatus.disabled;
      return;
    }
    status.value = LocationStatus.granted;
  }

  Future<void> requestPermission() async {
    final p = await Geolocator.checkPermission();
    if (p == LocationPermission.denied) {
      await Geolocator.requestPermission();
    }
    await checkAndRefresh();
  }

  /// Opens system location settings (app or system location page).
  Future<bool> openLocationSettings() async {
    return Geolocator.openLocationSettings();
  }

  /// Opens app settings (for permission denied forever).
  Future<bool> openAppSettings() async {
    return ph.openAppSettings();
  }

  Future<void> _fetchAndSavePosition() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: _timeLimit,
        ),
      );
      lat.value = position.latitude;
      lng.value = position.longitude;
      await _prefs.setDouble(AppConstants.prefKeyLat, position.latitude);
      await _prefs.setDouble(AppConstants.prefKeyLng, position.longitude);

      debugPrint('[Location] lat: ${position.latitude}, lng: ${position.longitude}');
      await _debugPrintAddress(position.latitude, position.longitude);
    } catch (e, st) {
      debugPrint('[Location] getCurrentPosition failed: $e');
      if (kDebugMode) debugPrint(st.toString());
    }
  }

  Future<void> _debugPrintAddress(double latitude, double longitude) async {
    try {
      final placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isEmpty) {
        debugPrint('[Location] address: (none)');
        return;
      }
      final p = placemarks.first;
      final parts = [
        if (p.street?.isNotEmpty == true) p.street,
        if (p.subLocality?.isNotEmpty == true) p.subLocality,
        if (p.locality?.isNotEmpty == true) p.locality,
        if (p.administrativeArea?.isNotEmpty == true) p.administrativeArea,
        if (p.country?.isNotEmpty == true) p.country,
      ];
      final address = parts.join(', ');
      debugPrint('[Location] address: $address');
    } catch (e) {
      debugPrint('[Location] reverse geocode failed: $e');
    }
  }

  /// Loads stored lat/lng from prefs (e.g. after app restart).
  void loadStoredPosition() {
    lat.value = _prefs.getDouble(AppConstants.prefKeyLat) ?? 0.0;
    lng.value = _prefs.getDouble(AppConstants.prefKeyLng) ?? 0.0;
  }

  bool get hasStoredPosition =>
      lat.value != 0.0 || lng.value != 0.0;

  bool get isGranted => status.value == LocationStatus.granted;
  bool get isDisabled => status.value == LocationStatus.disabled;
  bool get isDenied => status.value == LocationStatus.denied;
}
