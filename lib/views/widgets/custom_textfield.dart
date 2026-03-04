/*
  ---------------------------------------
  Project: Node Chat Mobile Application
  Date: March 03, 2026
  Author: Ameer Salman
  ---------------------------------------
  Description: custom text field
*/

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final double? fontSize;
  final TextEditingController controller;
  final bool isObscureText;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final Color borderColor;
  final Color hintColor;
  final Color textColor;
  final Color cursorColor;
  final IconData? prefixIcon;
  final Color? prefixIconColor;
  final Color fillColor;
  final Color focusedBorderColor;
  final Color focusedFillColor;
  final Color focusedTextColor;
  final double? width;
  final double? height;
  final Widget? suffixIcon;
  final bool showCustomSendIcon;
  final TextInputType keyboardType;
  final FormFieldValidator<String>? validator;
  final VoidCallback? onPrefixIconPressed;
  final EdgeInsetsGeometry? contentPadding;
  final FocusNode? focusNode; // Added FocusNode property
  final ValueChanged<String>? onFieldSubmitted;
  final bool readOnly;
  final VoidCallback? onTap;
  // parameters for limitations
  final int? maxLength;
  final String? allowedPattern;
  final bool preventSpaces;
  final ValueChanged<String>? onChanged;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.isObscureText = false,
    this.borderRadius = 10.0,
    this.padding = const EdgeInsets.all(5),
    this.borderColor = Colors.grey,
    this.hintColor = Colors.grey,
    this.textColor = Colors.black,
    this.cursorColor = Colors.black,
    this.prefixIcon,
    this.prefixIconColor,
    this.fillColor = Colors.white,
    this.focusedBorderColor = Colors.transparent,
    this.focusedFillColor = Colors.white,
    this.focusedTextColor = Colors.black,
    this.fontSize,
    this.width,
    this.height,
    this.suffixIcon,
    this.showCustomSendIcon = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onPrefixIconPressed,
    this.contentPadding,
    this.focusNode, // Initialize focusNode
    this.onFieldSubmitted, // Initialize onFieldSubmitted
    this.readOnly = false,
    this.onTap,
    this.maxLength,
    this.allowedPattern,
    this.preventSpaces = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Padding(
        padding: padding,
        child: TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          focusNode: focusNode, // Assign focusNode here
          onFieldSubmitted: onFieldSubmitted, // Assign onFieldSubmitted here
          readOnly: readOnly,
          onTap: onTap,
          onChanged: onChanged,
          maxLength: maxLength,
          // Add input formatters based on parameters
          inputFormatters: [
            if (maxLength != null)
              LengthLimitingTextInputFormatter(maxLength!),
            if (allowedPattern != null)
              FilteringTextInputFormatter.allow(RegExp(allowedPattern!)),
            if (preventSpaces)
              FilteringTextInputFormatter.deny(RegExp(r'\s')),
            // maxLength: 50,                    // Limit to 50 characters
            // allowedPattern: r'[a-zA-Z0-9]',  // Only allow alphanumeric
            // preventSpaces: true,             // Prevent spaces
          ],
          decoration: InputDecoration(
            counterText: "", // Hides the character counter
            filled: true,
            fillColor: fillColor,
            hintText: hintText,
            contentPadding: contentPadding,
            hintStyle: TextStyle(color: hintColor, fontSize: fontSize),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(color: borderColor, width: 2.w),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(color: focusedBorderColor, width: 1),
            ),
            suffixIcon: showCustomSendIcon
                ? Container(
              margin: EdgeInsets.only(right: 8.0.w),
              child: GestureDetector(
                onTap: () {
                  // Custom action on tap
                },
                child: CircleAvatar(
                  backgroundColor: const Color.fromRGBO(117, 129, 141, 1),
                  child: FaIcon(
                    FontAwesomeIcons.paperPlane,
                    color: const Color.fromRGBO(255, 249, 233, 1),
                    size: 20.h,
                  ),
                ),
              ),
            )
                : suffixIcon,
            prefixIcon: prefixIcon != null
                ? GestureDetector(
              onTap: onPrefixIconPressed, // Add this line
              child:
              Icon(prefixIcon, color: prefixIconColor ?? hintColor),
            )
                : null,
          ),
          style: TextStyle(color: textColor),
          cursorColor: cursorColor,
          validator: validator,
          obscureText: isObscureText,
        ),
      ),
    );
  }
}