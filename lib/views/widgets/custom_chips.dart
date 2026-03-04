/*
  ---------------------------------------
  Project: Node chat Mobile Application
  Date: March 03, 2026
  Author: Ameer Salman
  ---------------------------------------
  Description: custom chip selection
*/

import 'package:flutter/material.dart';

class CustomChip extends StatelessWidget {
  final Widget label;
  final bool selected;
  final ValueChanged<bool> onSelected;
  final Color selectedColor;
  final Color backgroundColor;
  final OutlinedBorder? shape; // Changed to OutlinedBorder
  final TextStyle labelStyle;
  const CustomChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onSelected,
    this.selectedColor =Colors.black,
    this.backgroundColor = Colors.green,
    this.shape, // Changed to OutlinedBorder?
    this.labelStyle = const TextStyle(color: Colors.amberAccent),

  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: label,
      selected: selected,
      onSelected: onSelected,
      selectedColor: selectedColor,
      backgroundColor: backgroundColor,
      shape: shape,
      labelStyle: labelStyle,
      showCheckmark: false,
    );
  }
}