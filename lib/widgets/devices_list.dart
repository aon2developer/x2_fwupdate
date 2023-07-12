import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:process_run/shell.dart';

import 'package:x2_fwupdate/providers/devices_provider.dart';

class DeviceList extends ConsumerStatefulWidget {
  const DeviceList({super.key});

  @override
  ConsumerState<DeviceList> createState() => _DeviceListState();
}

class _DeviceListState extends ConsumerState<DeviceList> {
  // @override
  // void initState() {
  //   super.initState();
  //   ref.read(devicesProvider.notifier).getFilteredPorts(); <-- not allowed
  // }

  bool _updateDevice(SerialPort device) {
    var shell = Shell();

    print('Updating ${device.address}...');

    // Find the Arduino port
    final String port = '/dev/ttyACM0'; // Temp hard coded

    // Update X2
    // shell.run('''

    //   stty -F "/dev/ttyACM0" 1200
    //   wait 1
    //   ./assets/dfu-util-linux -d 0x16D0:0x0CC4,0x0483:0xdf11 -a 0 -s 0x08000000:leave -D ./assets/X2-1.3.6.dfu

    // ''');

    // to reset the port mode, press the middle button for 20 seconds to force shutoff

    return false;
  }

  _selectDevice(SerialPort device) {
    bool _updateSuccessful = false;

    print('Device selected!');
    // device = device from somewhere?
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Are you sure that you want to update this device?',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        content: Column(
          children: [
            Text(
              'Device information',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(
              height: 6,
            ),
            Text(
              'Name: ${device.description}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              'Manufacturer: ${device.manufacturer}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              'Serial Number: ${device.serialNumber}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              print('Cancel update');
              Navigator.pop(ctx);
            },
            child: Text('No, cancel.'),
          ),
          TextButton(
            onPressed: () {
              print('Start update'); // execute start update
              _updateSuccessful = _updateDevice(device);
            },
            child: Text('Yes, update!'),
          ),
        ],
      ),
    );

    // true: start update (seperate function)
    // false: disregaurd selectede device
  }

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
                    _selectDevice(device);
                  },
                );
              }),
          ],
        ),
      ),
    );
  }
}
