/*
  ---------------------------------------
  Project: Node chat Mobile Application
  Date: March 03, 2026
  Author: Ameer Salman
  ---------------------------------------
  Description: chat screen
*/

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/bluetooth_controller.dart';
import '../../data/models/chat_message.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final BluetoothController controller = Get.find<BluetoothController>();
    final textController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(controller.connectedDeviceName.isEmpty ? 'Chat' : controller.connectedDeviceName)),
        actions: [
          IconButton(
            icon: const Icon(Icons.link_off),
            onPressed: controller.disconnect,
            tooltip: 'Disconnect',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              final list = controller.messages;
              if (list.isEmpty) {
                return const Center(child: Text('No messages yet. Say hello!'));
              }
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                itemCount: list.length,
                itemBuilder: (_, i) {
                  final msg = list[i];
                  return _MessageBubble(message: msg);
                },
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: textController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _send(controller, textController),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => _send(controller, textController),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _send(BluetoothController controller, TextEditingController textController) {
    final text = textController.text;
    if (text.trim().isEmpty) return;
    controller.sendMessage(text);
    textController.clear();
  }
}

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final bg = message.isFromMe
        ? Theme.of(context).colorScheme.primaryContainer
        : Theme.of(context).colorScheme.surfaceContainerHighest;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Align(
        alignment: message.isFromMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(message.text),
        ),
      ),
    );
  }
}
