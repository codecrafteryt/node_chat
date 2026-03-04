/*
  ---------------------------------------
  Project: Node chat Mobile Application
  Date: March 03, 2026
  Author: Ameer Salman
  ---------------------------------------
  Description: custom app bar
*/

import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final Color? backgroundColor;
  final Color? textColor;
  final TabBar? tabBar;
  final double? elevation;
  final Widget? leading;
  final List<Widget>? actions;
  final double? height; // Add a height parameter
  final bool centerTitle; // Add centerTitle property
  final IconThemeData? iconTheme; // Add iconTheme property

  const CustomAppBar({
    Key? key,
    this.title,
    this.backgroundColor,
    this.textColor,
    this.tabBar,
    this.elevation,
    this.leading,
    this.actions,
    this.height,
    this.centerTitle = true, // Default value for centerTitle is true
    this.iconTheme, // IconThemeData for customizing icon colors, sizes, etc.
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      surfaceTintColor: const Color.fromRGBO(255, 255, 255, 1),
      elevation: elevation ?? 4.0,
      automaticallyImplyLeading: false,
      backgroundColor: backgroundColor ?? Colors.white,
      centerTitle: centerTitle,
      title: title,
      leading: leading,
      actions: actions,
      bottom: tabBar,
      iconTheme: iconTheme, // Set the iconTheme property
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
      (height ?? kToolbarHeight) + (tabBar != null ? tabBar!.preferredSize.height : 0.0));
}