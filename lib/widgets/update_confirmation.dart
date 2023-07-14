import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:process_run/shell.dart';

import 'package:x2_fwupdate/screens/update_screen.dart';

class UpdateConfirmation extends StatelessWidget {
  UpdateConfirmation({required this.selectedDevice, super.key});

  final SerialPort selectedDevice;

  var shell = Shell();

  Future<bool> _updateDevice(SerialPort selectedDevice) async {
    Future<List<ProcessResult>> updateResult;

    print('Updating ${selectedDevice.description}...');

    // updateResult = shell.run('./assets/util/update.sh');

    // Artificial success until X2 is fixed
    updateResult = shell.run('''

      echo "Pretending to update"
      echo "Done!"
    
    ''');

    print(updateResult);

    return false;
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> _updateSuccessful;

    return AlertDialog(
      title: Text(
        'Are you sure that you want to update this device?',
        style: Theme.of(context).textTheme.titleLarge,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Device information',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(
            height: 6,
          ),
          Text(
            'Name: ${selectedDevice.description}',
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
          SizedBox(
            height: 4,
          ),
          // Text(
          //   'Product ID: ${selectedDevice.productId}',
          //   style: Theme.of(context).textTheme.bodyMedium,
          // ),
          // SizedBox(
          //   height: 4,
          // ),
          // Text(
          //   'Vendor ID: ${selectedDevice.vendorId}',
          //   style: Theme.of(context).textTheme.bodyMedium,
          // ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            print('Cancel update');
            selectedDevice.dispose();
            Navigator.pop(context);
          },
          child: Text('No, cancel.'),
        ),
        TextButton(
          onPressed: () {
            print('Start update'); // execute start update
            _updateSuccessful = _updateDevice(selectedDevice);
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
