import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/permission_flow_controller.dart';
import '../../utils/constants.dart';
import '../../utils/value/my_color.dart';
import '../../utils/value/my_fonts.dart';
import '../../utils/value/style.dart';
import '../widgets/custom_button.dart';

class BluetoothRequiredScreen extends StatelessWidget {
  const BluetoothRequiredScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final flow = Get.find<PermissionFlowController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? MyColors.darkBg : MyColors.lightBg;
    final boxBg = isDark ? MyColors.darkContainer : MyColors.lightGrayContainer;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 48),
              Icon(
                Icons.bluetooth,
                size: 80,
                color: MyColors.mainTextColor,
              ),
              const SizedBox(height: 24),
              Text(
                'Bluetooth Required',
                style: kSize18DarkW800Text.copyWith(
                  color: MyColors.mainTextColor,
                  fontSize: 22,
                  fontFamily: MyFonts.inter,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: boxBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${AppConstants.appName} needs Bluetooth to:',
                      style: kSize14DarkW400Text
                    ),
                    const SizedBox(height: 12),
                    _Bullet(text: 'Discover nearby users'),
                    _Bullet(text: 'Create mesh network connections'),
                    _Bullet(text: 'Send and receive messages'),
                    _Bullet(text: 'Work without internet or servers'),
                  ],
                ),
              ),
              const Spacer(),
              CustomButton(
                text: 'Enable Bluetooth',
                textColor: Colors.black,
                borderColor: Colors.transparent,
                backgroundColor: MyColors.mainTextColor,
                fontWeight: FontWeight.w600,
                onPressed: () => flow.requestBluetoothOn(),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  const _Bullet({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: kSize14DarkW400Text.copyWith(
              color: MyColors.mainTextColor,
              fontFamily: MyFonts.inter,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: kSize13DarkW300Text.copyWith(
                color: MyColors.mainTextColor,
                fontFamily: MyFonts.inter,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
