/*
  ---------------------------------------
  Project: Node chat Mobile Application
  Date: March 03, 2026
  Author: Ameer Salman
  ---------------------------------------
  Description: main Home screen with group chatting
*/

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/bluetooth_controller.dart';

class GroupChatScreen extends StatelessWidget {
  const GroupChatScreen({super.key});
  BluetoothController get controller => Get.find<BluetoothController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
         Text("data",
         style: TextStyle(
           fontSize: 20,
           fontWeight: FontWeight.bold,
         ),
         ),
        ],
      ),
    );
  }
}
