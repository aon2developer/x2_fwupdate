import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:process_run/shell.dart';

import 'package:x2_fwupdate/providers/devices_provider.dart';
import 'package:x2_fwupdate/widgets/update_status.dart';

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

  Future<bool> _updateDevice(SerialPort device) async {
    var shell = Shell();

    print('Updating ${device.description}...');

    shell.run('./assets/update.sh');

    return false;
  }

  _selectDevice(SerialPort device) {
    Future<bool> _updateSuccessful;

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
            Text(
              'Product ID: ${device.productId}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              'Vendor ID: ${device.vendorId}',
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
              Navigator.pop(ctx);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => UpdateStatus(),
                ),
              );
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
