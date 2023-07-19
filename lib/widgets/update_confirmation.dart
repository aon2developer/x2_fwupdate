import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:process_run/shell.dart';
import 'package:x2_fwupdate/providers/result_provider.dart';

import 'package:x2_fwupdate/screens/update_screen.dart';

class UpdateConfirmation extends ConsumerStatefulWidget {
  UpdateConfirmation({required this.selectedDevice, super.key});

  final shell = Shell(throwOnError: false);
  final SerialPort selectedDevice;

  @override
  ConsumerState<UpdateConfirmation> createState() => _UpdateConfirmationState();
}

class _UpdateConfirmationState extends ConsumerState<UpdateConfirmation> {
  bool _updateSuccess = false;

  void _updateDevice(SerialPort device) async {
    List<ProcessResult> updateResult;

    print('Updating ${device.description}...');

    // // Set provider to value
    // updateResult = shell.run('./assets/util/update.sh');

    // Artificial success until X2 is fixed
    print('Starting update...');
    updateResult = await shell.run('''

      echo "Pretending to update"
      sleep 1
      echo "Done!"

    ''');
    print('Update complete!');

    final finalCommand = updateResult[updateResult.length - 1];
    print('Your output: ${finalCommand.stdout}');
    print('Your output status: ${finalCommand.exitCode}');

    if (finalCommand.exitCode == 0) {
      setState(() {
        _updateSuccess = true;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<List<ProcessResult>> result = ref.watch(resultProvider);
    SerialPort device = widget.selectedDevice;

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
            'Name: ${device.productName}',
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
            Navigator.pop(context);
          },
          child: Text('No, cancel.'),
        ),
        TextButton(
          onPressed: () {
            // Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (ctx) => UpdateScreen(),
              ),
            );
            _updateDevice(device);
            print(_updateSuccess ? 'failure' : 'success');
          },
          child: Text('Yes, update!'),
        ),
      ],
    );
  }
}
