import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controllers/bluetooth_controller.dart';
import '../../controllers/location_controller.dart';
import '../../controllers/permission_flow_controller.dart';

class DependencyInjection {
  static Future<void> init() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    Get.lazyPut(() => sharedPreferences, fenix: true);
    Get.lazyPut(() => BluetoothController(sharedPreferences: Get.find()), fenix: true);
    Get.lazyPut(() => LocationController(prefs: Get.find()), fenix: true);
    Get.lazyPut(
      () => PermissionFlowController(locationController: Get.find()),
      fenix: true,
    );
  }
}
