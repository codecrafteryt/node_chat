import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart' as ble;

import '../utils/ble_constants.dart';

class BluetoothService {
  Stream<List<ble.ScanResult>> scanDevices({Duration timeout = const Duration(seconds: 10)}) {
    ble.FlutterBluePlus.startScan(timeout: timeout);
    return ble.FlutterBluePlus.scanResults;
  }

  void stopScan() {
    ble.FlutterBluePlus.stopScan();
  }

  Future<void> connectToDevice(ble.BluetoothDevice device) async {
    await device.connect(autoConnect: false, license: ble.License.free);
  }

  Future<List<ble.BluetoothService>> discoverServices(ble.BluetoothDevice device) async {
    return await device.discoverServices();
  }

  /// Finds the chat characteristic (write + notify) from discovered services.
  ble.BluetoothCharacteristic? findChatCharacteristic(List<ble.BluetoothService> services) {
    for (final svc in services) {
      if (svc.uuid.toString().toLowerCase() != chatServiceUuid.toLowerCase()) continue;
      for (final char in svc.characteristics) {
        if (char.uuid.toString().toLowerCase() == chatCharacteristicUuid.toLowerCase()) {
          return char;
        }
      }
    }
    return null;
  }

  Future<void> sendMessage(ble.BluetoothCharacteristic characteristic, String message) async {
    await characteristic.write(message.codeUnits);
  }

  StreamSubscription<List<int>>? _messageSubscription;

  void startListeningToMessages(
    ble.BluetoothCharacteristic characteristic,
    void Function(String message) onMessage,
  ) {
    _messageSubscription?.cancel();
    characteristic.setNotifyValue(true);
    _messageSubscription = characteristic.lastValueStream.listen((List<int> value) {
      if (value.isNotEmpty) {
        onMessage(String.fromCharCodes(value));
      }
    });
  }

  void stopListeningToMessages() {
    _messageSubscription?.cancel();
    _messageSubscription = null;
  }
}
