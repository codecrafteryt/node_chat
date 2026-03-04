/*
  ---------------------------------------
  Project: Node chat Mobile Application
  Date: March 03, 2026
  Author: Ameer Salman
  ---------------------------------------
  Description: extensions for space
*/

import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension Space on num {
  SizedBox get sbh => SizedBox(height: ScreenUtil().setHeight(toDouble(),));

  SizedBox get sbw => SizedBox(width: ScreenUtil().setWidth(toDouble()),);
}