import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:x2_fwupdate/providers/devices_provider.dart';
import 'package:x2_fwupdate/widgets/update_confirmation.dart';

class DeviceList extends ConsumerStatefulWidget {
  const DeviceList({super.key});

  @override
  ConsumerState<DeviceList> createState() => _DeviceListState();
}

class _DeviceListState extends ConsumerState<DeviceList> {
  _selectDevice(SerialPort device) {
    print('Device selected!');

    showDialog(
      context: context,
      builder: (ctx) => UpdateConfirmation(selectedDevice: device),
    );

    // true: start update (seperate function)
    // false: disregaurd selectede device
  }

  @override
  Widget build(BuildContext context) {
    final availableDevices = ref.watch(devicesProvider);
    print(availableDevices);

    Widget content = Text('No devices found!');

    if (availableDevices.isNotEmpty) {
      content = ListView.builder(
          itemCount: availableDevices.length,
          itemBuilder: (ctx, index) {
            return ListTile(
              title: Text(
                '${availableDevices[index].productName} by ${availableDevices[index].manufacturer}',
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Colors.white,
                    ),
              ),
              onTap: () {
                _selectDevice(availableDevices[index]);
              },
            );
          });
    }

    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[850],
        ),
        child: Column(
          children: [
            for (final device in availableDevices)
              Builder(builder: (context) {
                print('Device(s) found');
                return ListTile(
                  title: Text(
                    '${device.productName} by ${device.manufacturer}',
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: Colors.white,
                        ),
                  ),
                  onTap: () {
                    _selectDevice(device);
                  },
                );
              }),
            // content,
          ],
        ),
      ),
    );
  }
}
