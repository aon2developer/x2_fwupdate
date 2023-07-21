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
    showDialog(
      context: context,
      builder: (ctx) => UpdateConfirmation(selectedDevice: device),
    );

    // true: start update (seperate function)
    // false: disregaurd selectede device
  }

  @override
  void initState() {
    super.initState();
    // Wait for build to render then find devices
    Future(() {
      ref.read(devicesProvider.notifier).findX2Devices();
    });
  }

  @override
  Widget build(BuildContext context) {
    final availableDevices = ref.watch(devicesProvider);
    print(availableDevices);

    List<Widget> content = [];

    if (availableDevices.isNotEmpty) {
      for (final device in availableDevices) {
        content.add(ListTile(
          title: Text(
            '${device.productName} by ${device.manufacturer}',
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: Colors.white,
                ),
          ),
          onTap: () {
            _selectDevice(device);
          },
        ));
      }
    } else {
      content = [
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(25),
          child: Column(
            children: [
              Text(
                'No devices found!',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                'Try refreshing again...',
                style: Theme.of(context).textTheme.bodyLarge,
              )
            ],
          ),
        ),
      ];
    }

    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[850],
        ),
        child: Column(
          children: [
            for (final device in content)
              Builder(builder: (context) {
                print('Device(s) found');
                return device;
              }),
          ],
        ),
      ),
    );
  }
}
