import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/bluetooth_controller.dart';

class ScanScreen extends StatelessWidget {
  const ScanScreen({super.key});
  BluetoothController get controller => Get.find<BluetoothController>();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Nearby Devices',
        style: TextStyle(
          color: Color.fromRGBO(48, 42, 57, 1),
        ),

        ),
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
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: Color.fromRGBO(190, 149, 250, 1),
              )
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
