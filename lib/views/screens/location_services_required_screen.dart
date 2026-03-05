/*
  ---------------------------------------
  Project: Node chat Mobile Application
  Date: March 03, 2026
  Author: Ameer Salman
  ---------------------------------------
  Description: Location Services Required Screen
*/

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/location_controller.dart';
import '../../controllers/permission_flow_controller.dart';
import '../../utils/constants.dart';
import '../../utils/extensions/extension.dart';
import '../../utils/value/my_color.dart';
import '../../utils/value/my_fonts.dart';
import '../../utils/value/style.dart';
import '../widgets/custom_bullet.dart';
import '../widgets/custom_button.dart';

class LocationServicesRequiredScreen extends StatelessWidget {
  const LocationServicesRequiredScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final flow = Get.find<PermissionFlowController>();
    final location = Get.find<LocationController>();
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
              30.sbh,
              Icon(
                Icons.location_on_outlined,
                size: 80,
                color: MyColors.mainTextColor,
              ),
              24.sbh,
              Text(
                'Location Services Required',
                style: kSize18DarkW800Text.copyWith(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              24.sbh,
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
                    Row(
                      children: [
                        Icon(
                          Icons.shield_outlined,
                          size: 20,
                          color: MyColors.mainTextColor,
                        ),
                        8.sbw,
                        Text(
                          'Privacy First',
                          style: kSize14DarkW400Text.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    8.sbh,
                    Text(
                      '${AppConstants.appName} does NOT track your location.',
                      style: kSize13DarkW300Text,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Location services are required for Bluetooth scanning and for the Geohash chat feature.',
                      style: kSize13DarkW300Text,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${AppConstants.appName} needs location services for:',
                      style: kSize14DarkW400Text.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    8.sbh,
                    CustomBullet(text: 'Bluetooth device scanning'),
                    CustomBullet(
                      text: 'Discovering nearby users on mesh network',
                    ),
                    CustomBullet(text: 'Geohash chat feature'),
                    CustomBullet(text: 'No tracking or location collection'),
                  ],
                ),
              ),
              const Spacer(),
              CustomButton(
                text: 'Open Location Settings',
                textColor: bg,
                backgroundColor: MyColors.mainTextColor,
                fontWeight: FontWeight.w600,
                borderColor: Colors.transparent,
                onPressed: () => location.openLocationSettings(),
              ),
              15.sbh,
              CustomButton(
                text: 'Check Again',
                textColor: MyColors.mainTextColor,
                backgroundColor: Colors.transparent,
                borderColor: MyColors.mainTextColor,
                fontWeight: FontWeight.w600,
                onPressed: () => flow.checkLocationAndProceed(),
              ),
              30.sbh,
            ],
          ),
        ),
      ),
    );
  }
}
