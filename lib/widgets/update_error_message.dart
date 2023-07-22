import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x2_fwupdate/providers/update_provider.dart';
import 'package:x2_fwupdate/widgets/error_message.dart';

class UpdateErrorMessage extends ConsumerWidget {
  UpdateErrorMessage({required this.error, required this.device, super.key});

  final String error;
  final SerialPort device;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      child: Column(
        children: [
          // TODO: use elifs
          if (error == 'stty')
            ErrorMessage(
              title: 'Failed to prepare for update',
              desc: 'Update error due to $error',
              help: [
                'If this happens again, try holding down the top and middle buttons at the same time for 20 seconds.'
              ],
            ),
          if (error == 'util')
            ErrorMessage(
              title: 'Failed to start update...',
              desc: 'Update error due to $error',
              help: [
                'To fix this, hold the middle and top buttons for 20 seconds to shutdown the X2 and try again.',
              ],
            ),
          if (error == 'no-driver')
            ErrorMessage(
              title: 'Failed to start update',
              desc: 'You require a boot loader driver to install this update',
              help: [
                'To fix this, click the following link to download the package.',
                '1) Unzip the folder',
                '2.1) Windows 10 and newer: double click X2Driver-Setup-2.exe',
                '2.2) Windows 8.1 and older: double click X2Serial-2.exe',
                'Return here when you\'re done!',
              ],
              link: 'https://www.aon2.co.uk/files/drivers/X2DriverPackage.zip',
            ),
          if (error == 'unknown')
            ErrorMessage(
              title: 'Failed to update',
              desc: 'Update error.',
              help: ['Please try again.'],
            ),
          SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  ref.read(updateProvider.notifier).resetErrors();
                  ref.read(updateProvider.notifier).updateDevice(device);
                },
                icon: Icon(
                  Icons.refresh,
                  size: 26,
                ),
                label: Text(
                  'Try again',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Colors.white,
                        fontSize: 26,
                      ),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                    Theme.of(context).primaryColorDark,
                  ),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.backspace,
                  size: 26,
                ),
                label: Text(
                  'Go back',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Colors.white,
                        fontSize: 26,
                      ),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                    Theme.of(context).primaryColorDark,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
