import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/bluetooth_controller.dart';

class ScanScreen extends StatelessWidget {
  const ScanScreen({super.key});
  BluetoothController get controller => Get.find<BluetoothController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Devices',),
        actions: [
          Obx(() => controller.isScanning.value
              ? IconButton(
                  icon: const Icon(Icons.stop),
                  onPressed: controller.stopScan,
                )
              : IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: controller.startScan,
                )),
        ],
      ),
      body: Obx(() {
        final status = controller.statusMessage.value;
        final devices = controller.scanResults;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Scanning...',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (status.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  status,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            Expanded(
              child: devices.isEmpty
                  ? Center(
                      child: Text(
                        controller.isScanning.value
                            ? 'Scanning...'
                            : 'Tap refresh to scan for devices',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    )
                  : ListView.builder(
                      itemCount: devices.length,
                      itemBuilder: (_, i) {
                        final result = devices[i];
                        final d = result.device;
                        final name = d.platformName.isEmpty ? 'Unknown' : d.platformName;
                        return ListTile(
                          leading: const Icon(Icons.bluetooth),
                          title: Text(name),
                          subtitle: Text(d.remoteId.toString()),
                          onTap: () => controller.connectToDevice(d),
                        );
                      },
                    ),
            ),
          ],
        );
      }),
      floatingActionButton: Obx(() => controller.isScanning.value
          ? const SizedBox.shrink()
          : FloatingActionButton(
              onPressed: controller.startScan,
              child: const Icon(Icons.search),
            )),
    );
  }
}
