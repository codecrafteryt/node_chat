
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controllers/bluetooth_controller.dart';

class DependencyInjection {
  static void init() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    Get.lazyPut(() => BluetoothController(sharedPreferences: Get.find()), fenix: true);
  }
}
