import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x2_fwupdate/models/error_message.dart';
import 'package:x2_fwupdate/providers/devices_provider.dart';
import 'package:x2_fwupdate/providers/update_provider.dart';
import 'package:x2_fwupdate/widgets/error_message_widget.dart';

class UpdateErrorMessage extends ConsumerWidget {
  UpdateErrorMessage({required this.error, required this.device, super.key});

  final ErrorMessage error;
  final SerialPort device;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      child: Column(
        children: [
          ErrorMessageWidget(error: error),
          SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () async {
                  // reset update state
                  ref.read(updateProvider.notifier).resetErrors();

                  // check for boot loader mode
                  final deviceStatus =
                      await ref.read(devicesProvider.notifier).findX2Devices();

                  if (deviceStatus == 'bootloader')
                    ref.read(updateProvider.notifier).updateX2Device(null);
                  else
                    ref.read(updateProvider.notifier).updateX2Device(device);
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
