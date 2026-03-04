import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/chat_message.dart';
import '../services/bluetooth_service.dart' as app_services;

class BluetoothController extends GetxController {
  SharedPreferences sharedPreferences;
  BluetoothController({
    required this.sharedPreferences,
  });
  final app_services.BluetoothService _ble = app_services.BluetoothService();

  final RxList<ScanResult> scanResults = <ScanResult>[].obs;
  final RxBool isScanning = false.obs;
  final Rxn<BluetoothDevice> connectedDevice = Rxn<BluetoothDevice>();
  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final RxString statusMessage = ''.obs;

  StreamSubscription<List<ScanResult>>? _scanSubscription;

  BluetoothCharacteristic? _chatCharacteristic;

  @override
  void onInit() {
    super.onInit();
    _listenToDisconnections();
  }

  @override
  void onClose() {
    stopScan();
    disconnect();
    super.onClose();
  }

  void _listenToDisconnections() {
    FlutterBluePlus.adapterState.listen((state) {
      if (state != BluetoothAdapterState.on) {
        _clearConnection();
      }
    });
  }

  void _clearConnection() {
    _ble.stopListeningToMessages();
    _chatCharacteristic = null;
    connectedDevice.value = null;
    statusMessage.value = 'Disconnected';
  }

  void _addIncomingMessage(String text) {
    messages.add(ChatMessage(text: text, isFromMe: false));
  }

  void startScan() {
    if (isScanning.value) return;
    isScanning.value = true;
    scanResults.clear();
    statusMessage.value = 'Scanning...';
    _scanSubscription?.cancel();
    _scanSubscription = _ble.scanDevices(timeout: const Duration(seconds: 10)).listen(
      (results) {
        scanResults.assignAll(results);
      },
      onDone: () {
        isScanning.value = false;
        statusMessage.value = scanResults.isEmpty ? 'No devices found' : 'Scan complete';
      },
      onError: (e) {
        isScanning.value = false;
        statusMessage.value = 'Scan error: $e';
      },
    );
  }

  void stopScan() {
    _ble.stopScan();
    _scanSubscription?.cancel();
    _scanSubscription = null;
    isScanning.value = false;
    statusMessage.value = 'Scan stopped';
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    if (connectedDevice.value != null) {
      statusMessage.value = 'Already connected';
      return;
    }
    try {
      statusMessage.value = 'Connecting to ${device.platformName.isNotEmpty ? device.platformName : device.remoteId}...';
      await _ble.connectToDevice(device);
      connectedDevice.value = device;

      statusMessage.value = 'Discovering services...';
      final services = await _ble.discoverServices(device);
      final char = _ble.findChatCharacteristic(services);
      if (char == null) {
        statusMessage.value = 'Chat service not found on device';
        await device.disconnect();
        connectedDevice.value = null;
        return;
      }
      _chatCharacteristic = char;
      _ble.startListeningToMessages(char, _addIncomingMessage);
      statusMessage.value = 'Connected';
      stopScan();
      Get.toNamed('/chat');
    } catch (e) {
      statusMessage.value = 'Connect failed: $e';
      connectedDevice.value = null;
      _chatCharacteristic = null;
    }
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    final char = _chatCharacteristic;
    if (char == null) {
      statusMessage.value = 'Not connected';
      return;
    }
    try {
      await _ble.sendMessage(char, text);
      messages.add(ChatMessage(text: text, isFromMe: true));
    } catch (e) {
      statusMessage.value = 'Send failed: $e';
    }
  }

  Future<void> disconnect() async {
    final device = connectedDevice.value;
    if (device != null) {
      _ble.stopListeningToMessages();
      try {
        await device.disconnect();
      } catch (_) {}
      _clearConnection();
      Get.offNamed('/scan');
    }
  }

  String get connectedDeviceName {
    final d = connectedDevice.value;
    if (d == null) return '';
    return d.platformName.isNotEmpty ? d.platformName : d.remoteId.toString();
  }
}
