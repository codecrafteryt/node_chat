import 'package:permission_handler/permission_handler.dart';

/// Call on app start so BLE scan and connect work (especially Android 12+).
Future<void> requestPermissions() async {
  await [
    Permission.bluetooth,
    Permission.bluetoothScan,
    Permission.bluetoothConnect,
    Permission.location,
  ].request();
}
