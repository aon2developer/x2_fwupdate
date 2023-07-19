import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:process_run/shell.dart';
import 'package:x2_fwupdate/widgets/progress_bar.dart';
import 'package:x2_fwupdate/widgets/update_complete.dart';
import 'package:x2_fwupdate/widgets/update_working.dart';

// TODO: make update script run directly from button press rather than update screen load
// could us invisable widget called udpae device to do this?
class UpdateScreen extends ConsumerStatefulWidget {
  UpdateScreen({required this.selectedDevice, super.key});

  final SerialPort selectedDevice;

  @override
  ConsumerState<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends ConsumerState<UpdateScreen> {
  final shell = Shell(throwOnError: false);
  bool _updateSuccess = false;

  void _updateDevice(SerialPort device) async {
    List<ProcessResult> updateResult;

    print('UpdateWorking ${device.description}...');

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
    SerialPort device = widget.selectedDevice;

    return Container(
      decoration: BoxDecoration(color: Theme.of(context).primaryColorDark),
      padding: EdgeInsets.all(24),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          !_updateSuccess ? UpdateWorking() : UpdateComplete(),
          if (!_updateSuccess)
            ElevatedButton.icon(
              onPressed: () {
                _updateDevice(device);
              },
              icon: Icon(
                Icons.update,
                size: 26,
              ),
              label: Text(
                'Update',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Colors.white,
                      fontSize: 26,
                    ),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(
                  Theme.of(context)
                      .primaryColorDark, // TODO: match with background color
                ),
              ),
            ),
          SizedBox(
            height: 12,
          ),
        ],
      ),
    );
  }
}
