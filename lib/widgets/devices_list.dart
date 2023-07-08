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
    final availablePorts = ref.watch(devicesProvider);
    print(availablePorts);

    return SingleChildScrollView(
      child: Column(
        children: [
          for (final address in availablePorts)
            Builder(builder: (context) {
              // final port = SerialPort(address);
              return ListTile(
                title: Text(
                  address,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Colors.white,
                      ),
                ),
                onTap: () {
                  print('Selected $address');
                },
              );
            }),
        ],
      ),
    );
  }
}
