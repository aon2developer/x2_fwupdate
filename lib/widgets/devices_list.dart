import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:x2_fwupdate/providers/devices_provider.dart';

class DeviceList extends ConsumerStatefulWidget {
  const DeviceList({super.key});

  @override
  ConsumerState<DeviceList> createState() => _DeviceListState();
}

class _DeviceListState extends ConsumerState<DeviceList> {
  @override
  Widget build(BuildContext context) {
    final availableDevices = ref.watch(devicesProvider);
    print(availableDevices);

    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[850],
        ),
        child: Column(
          children: [
            for (final device in availableDevices)
              Builder(builder: (context) {
                // final port = SerialPort(address);
                return ListTile(
                  title: Text(
                    '${device.description} by ${device.manufacturer}',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Colors.white,
                        ),
                  ),
                  onTap: () {
                    print('Selected: ${device.description}');
                    print('Product id: ${device.productId ?? 'N/A'}');
                    print('Vendor id: ${device.vendorId ?? 'N/A'}');
                  },
                );
              }),
          ],
        ),
      ),
    );
  }
}
