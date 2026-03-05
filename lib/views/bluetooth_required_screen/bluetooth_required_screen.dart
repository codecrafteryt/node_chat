/*
  ---------------------------------------
  Project: Node chat Mobile Application
  Date: March 03, 2026
  Author: Ameer Salman
  ---------------------------------------
  Description: bluetooth required screen
*/

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/permission_flow_controller.dart';
import '../../utils/constants.dart';
import '../../utils/extensions/extension.dart';
import '../../utils/value/my_color.dart';
import '../../utils/value/my_fonts.dart';
import '../../utils/value/style.dart';
import '../widgets/custom_bullet.dart';
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
              48.sbh,
              Icon(
                Icons.bluetooth,
                size: 80,
                color: MyColors.mainTextColor,
              ),
              24.sbh,
              Text(
                'Bluetooth Required',
                style: kSize18DarkW800Text.copyWith(
                  color: MyColors.mainTextColor,
                  fontSize: 22,
                  fontFamily: MyFonts.inter,
                ),
                textAlign: TextAlign.center,
              ),
              32.sbh,
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
                    CustomBullet(text: 'Discover nearby users'),
                    CustomBullet(text: 'Create mesh network connections'),
                    CustomBullet(text: 'Send and receive messages'),
                    CustomBullet(text: 'Work without internet or servers'),
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
              30.sbh,
            ],
          ),
        ),
      ),
    );
  }
}
