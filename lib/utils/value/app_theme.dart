/*
  ---------------------------------------
  Project: Node chat Mobile Application
  Date: March 04, 2026
  Author: Ameer Salman
  ---------------------------------------
  Description: App light/dark theme using MyColors and kSize13DarkW300Text style.
*/

import 'package:flutter/material.dart';
import 'my_color.dart';
import 'style.dart';

/// Body text style based on kSize13DarkW300Text; text color is always mainTextColor.
TextStyle _bodyStyle(Color color) => kSize13DarkW300Text.copyWith(color: color);

const Color _textColor = MyColors.mainTextColor;

ThemeData get lightTheme => ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: MyColors.lightBg,
      colorScheme: ColorScheme.fromSeed(
        seedColor: MyColors.mainTextColor,
        brightness: Brightness.light,
        surface: MyColors.lightBg,
        onSurface: _textColor,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: MyColors.lightBg,
        foregroundColor: _textColor,
        elevation: 0,
      ),
      textTheme: TextTheme(
        bodyLarge: _bodyStyle(_textColor).copyWith(fontSize: 16),
        bodyMedium: _bodyStyle(_textColor),
        bodySmall: _bodyStyle(_textColor).copyWith(fontSize: 12),
        titleLarge: _bodyStyle(_textColor).copyWith(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: _bodyStyle(_textColor).copyWith(fontSize: 15),
        titleSmall: _bodyStyle(_textColor).copyWith(fontSize: 13),
        labelLarge: _bodyStyle(_textColor).copyWith(fontSize: 14),
      ),
      listTileTheme: const ListTileThemeData(
        textColor: _textColor,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: MyColors.lightGrayContainer,
        border: const OutlineInputBorder(),
        hintStyle: _bodyStyle(_textColor.withValues(alpha: 0.6)),
        labelStyle: _bodyStyle(_textColor),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: MyColors.mainTextColor,
        foregroundColor: Colors.white,
      ),
      iconTheme: const IconThemeData(color: _textColor),
    );

ThemeData get darkTheme => ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: MyColors.darkBg,
      colorScheme: ColorScheme.fromSeed(
        seedColor: MyColors.mainTextColor,
        brightness: Brightness.dark,
        surface: MyColors.darkBg,
        onSurface: _textColor,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: MyColors.darkBg,
        foregroundColor: _textColor,
        elevation: 0,
      ),
      textTheme: TextTheme(
        bodyLarge: _bodyStyle(_textColor).copyWith(fontSize: 16),
        bodyMedium: _bodyStyle(_textColor),
        bodySmall: _bodyStyle(_textColor).copyWith(fontSize: 12),
        titleLarge: _bodyStyle(_textColor).copyWith(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: _bodyStyle(_textColor).copyWith(fontSize: 15),
        titleSmall: _bodyStyle(_textColor).copyWith(fontSize: 13),
        labelLarge: _bodyStyle(_textColor).copyWith(fontSize: 14),
      ),
      listTileTheme: const ListTileThemeData(
        textColor: _textColor,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: MyColors.darkContainer,
        border: const OutlineInputBorder(),
        hintStyle: _bodyStyle(_textColor.withValues(alpha: 0.6)),
        labelStyle: _bodyStyle(_textColor),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: MyColors.mainTextColor,
        foregroundColor: Colors.white,
      ),
      iconTheme: const IconThemeData(color: _textColor),
    );
