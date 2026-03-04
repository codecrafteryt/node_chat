/*
  ---------------------------------------
  Project: Node Chat Mobile Application
  Date: March 03, 2026
  Author: Ameer Salman
  ---------------------------------------
  Description: custom button
*/

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/value/my_fonts.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final Color? borderColor;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final Color? textColor;
  final Color? backgroundColor;
  final double? width;
  final double? height;
  final double? fontSize;
  final String? imagePath;
  final IconData? icon;
  final IconData? suffixIcon;
  final Color? iconColor;
  final double? iconSize;
  final FontWeight? fontWeight;
  final bool isLoading; // Added this parameter

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.height,
    this.width,
    this.textColor,
    this.backgroundColor,
    this.borderRadius,
    this.fontSize,
    this.fontWeight,
    this.borderColor,
    this.padding,
    this.imagePath,
    this.icon,
    this.suffixIcon,
    this.iconColor,
    this.iconSize,
    this.isLoading = false, // Set default to false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 60.h,
      width: width ?? 352.w,
      child: TextButton(
        onPressed: isLoading ? null : onPressed, // Disable button when loading
        style: TextButton.styleFrom(
          backgroundColor: backgroundColor ?? Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 18.r),
          ),
          side: BorderSide(color: borderColor ?? Colors.white),
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
            height: 20.0.h,
            width: 20.0.w,
            child: CircularProgressIndicator(
              color: Colors.white,
              backgroundColor: Colors.grey.shade400,
              strokeWidth: 2.0.w,
            ),
          )
              : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (imagePath != null)
                Padding(
                  padding: EdgeInsets.only(right: 8.0.r),
                  child: Image.asset(
                    imagePath!,
                    height: 24.h,
                    width: 24.w,
                  ),
                ),
              if (icon != null)
                Padding(
                  padding: EdgeInsets.only(right: 8.0.r),
                  child: Icon(
                    icon,
                    color: iconColor ?? textColor,
                    size: iconSize ?? 24.h,
                  ),
                ),
              Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontSize: fontSize ?? 14.sp,
                  fontWeight: fontWeight ?? FontWeight.w500,
                  fontFamily: MyFonts.inter,
                ),
              ),
              if (suffixIcon != null)
                Padding(
                  padding: EdgeInsets.only(left: 8.0.r),
                  child: Icon(
                    suffixIcon,
                    color: iconColor ?? textColor,
                    size: iconSize ?? 24.h,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}