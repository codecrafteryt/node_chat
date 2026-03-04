import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/permission_flow_controller.dart';
import 'bluetooth_required_screen.dart';
import 'location_services_required_screen.dart';
import 'scan_screen.dart';

/// Shows BluetoothRequired → LocationServicesRequired → ScanScreen based on [PermissionFlowController].
class PermissionGate extends StatelessWidget {
  const PermissionGate({super.key});
  PermissionFlowController get flowController => Get.find<PermissionFlowController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      switch (flowController.currentScreen.value) {
        case PermissionScreen.bluetoothRequired:
          return const BluetoothRequiredScreen();
        case PermissionScreen.locationRequired:
          return const LocationServicesRequiredScreen();
        case PermissionScreen.main:
          return const ScanScreen();
      }
    });
  }
}
