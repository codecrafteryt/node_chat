import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'data/helper/get_di.dart';
import 'views/screens/scan_screen.dart';
import 'utils/permissions.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await requestPermissions();
  DependencyInjection.init();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(const NodeChatApp());
  });

}

class NodeChatApp extends StatelessWidget {
  const NodeChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(375, 880),
        minTextAdapt: false,
        splitScreenMode: false,
      builder: (_, context) {
        return GetMaterialApp(
          title: 'Node Chat',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            useMaterial3: true,
          ),
          debugShowCheckedModeBanner: false,
          defaultTransition: Transition.leftToRight,
          home: const ScanScreen(),
        );
      }
    );
  }
}
