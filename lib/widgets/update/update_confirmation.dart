import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:process_run/shell.dart';
import 'package:x2_fwupdate/providers/update_provider.dart';

import 'package:x2_fwupdate/screens/update_screen.dart';

class UpdateConfirmation extends ConsumerStatefulWidget {
  UpdateConfirmation({required this.selectedDevice, super.key});

  final shell = Shell(throwOnError: false);
  final SerialPort selectedDevice;

  @override
  ConsumerState<UpdateConfirmation> createState() => _UpdateConfirmationState();
}

class _UpdateConfirmationState extends ConsumerState<UpdateConfirmation> {
  @override
  Widget build(BuildContext context) {
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
          // Go to update screen and begin update
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (ctx) => UpdateScreen(
                  selectedDevice: device,
                ),
              ),
            );
            ref.read(updateProvider.notifier).updateDevice(device);
          },
          child: Text('Yes, update!'),
        ),
      ],
    );
  }
}
