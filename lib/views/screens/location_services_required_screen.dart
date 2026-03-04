import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/location_controller.dart';
import '../../controllers/permission_flow_controller.dart';
import '../../utils/constants.dart';
import '../../utils/value/my_color.dart';
import '../../utils/value/my_fonts.dart';
import '../../utils/value/style.dart';
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
              const SizedBox(height: 32),
              Icon(
                Icons.location_on_outlined,
                size: 80,
                color: MyColors.mainTextColor,
              ),
              const SizedBox(height: 24),
              Text(
                'Location Services Required',
                style: kSize18DarkW800Text.copyWith(
                  color: MyColors.mainTextColor,
                  fontSize: 20,
                  fontFamily: MyFonts.inter,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
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
                        const SizedBox(width: 8),
                        Text(
                          'Privacy First',
                          style: kSize14DarkW400Text.copyWith(
                            color: MyColors.mainTextColor,
                            fontWeight: FontWeight.w600,
                            fontFamily: MyFonts.inter,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${AppConstants.appName} does NOT track your location.',
                      style: kSize13DarkW300Text.copyWith(
                        color: MyColors.mainTextColor,
                        fontStyle: FontStyle.italic,
                        fontFamily: MyFonts.inter,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Location services are required for Bluetooth scanning and for the Geohash chat feature.',
                      style: kSize13DarkW300Text.copyWith(
                        color: MyColors.mainTextColor,
                        fontFamily: MyFonts.inter,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${AppConstants.appName} needs location services for:',
                      style: kSize14DarkW400Text.copyWith(
                        color: MyColors.mainTextColor,
                        fontWeight: FontWeight.w600,
                        fontFamily: MyFonts.inter,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _Bullet(text: 'Bluetooth device scanning'),
                    _Bullet(text: 'Discovering nearby users on mesh network'),
                    _Bullet(text: 'Geohash chat feature'),
                    _Bullet(text: 'No tracking or location collection'),
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
              const SizedBox(height: 16),
              CustomButton(
                text: 'Check Again',
                textColor: MyColors.mainTextColor,
                backgroundColor: Colors.transparent,
                borderColor: MyColors.mainTextColor,
                fontWeight: FontWeight.w600,
                onPressed: () => flow.checkLocationAndProceed(),
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
      padding: const EdgeInsets.only(bottom: 6),
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

/*
i am some advancing sync like when i am on the location screen
and then i off the bluethooth and then we will move to that screen

* */