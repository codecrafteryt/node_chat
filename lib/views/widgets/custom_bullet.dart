/*
  ---------------------------------------
  Project: Node chat Mobile Application
  Date: March 03, 2026
  Author: Ameer Salman
  ---------------------------------------
  Description: custom bullet widget
*/

import 'package:flutter/material.dart';
import '../../utils/value/style.dart';

class CustomBullet extends StatelessWidget {
  final String text;
  const CustomBullet ({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Text(
    '• ',
    style: kSize14DarkW400Text
    ),
    Expanded(
    child: Text(
    text,
    style: kSize13DarkW300Text,
    ),
    ),
    ],
    ),
    );
  }
}
