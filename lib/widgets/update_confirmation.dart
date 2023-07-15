import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:process_run/shell.dart';
import 'package:x2_fwupdate/providers/result_provider.dart';

import 'package:x2_fwupdate/screens/update_screen.dart';

class UpdateConfirmation extends ConsumerWidget {
  UpdateConfirmation({required this.selectedDevice, super.key});

  final SerialPort selectedDevice;
  final shell = Shell();

  Future<bool> _updateDevice(SerialPort selectedDevice) async {
    Future<List<ProcessResult>> updateResult;

    print('Updating ${selectedDevice.description}...');

    // // Set provider to value
    // updateResult = shell.run('./assets/util/update.sh');

    // Artificial success until X2 is fixed
    print('Starting update...');
    updateResult = shell.run('''

      echo "Pretending to update"
      sleep 5
      echo "Done!"

    ''');
    print('Update complete!');

    return false;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<bool> _updateSuccessful;
    Future<List<ProcessResult>> result = ref.watch(resultProvider);

    return AlertDialog(
      title: Text(
        'Are you sure that you want to update this device?',
        style: Theme.of(context).textTheme.titleSmall,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Device information',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            'Name: ${selectedDevice.productName}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            'Manufacturer: ${selectedDevice.manufacturer}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            'Serial Number: ${selectedDevice.serialNumber}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            print('Cancel update');
            Navigator.pop(context);
          },
          child: Text('No, cancel.'),
        ),
        TextButton(
          onPressed: () {
            _updateSuccessful = _updateDevice(selectedDevice);
            print(_updateSuccessful);
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (ctx) => UpdateScreen(),
              ),
            );
          },
          child: Text('Yes, update!'),
        ),
      ],
    );
  }
}
