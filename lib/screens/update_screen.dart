import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:process_run/shell.dart';
import 'package:x2_fwupdate/widgets/update_complete.dart';
import 'package:x2_fwupdate/widgets/update_error.dart';
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
  // TODO: make update error class
  bool _updateSuccess = false;
  bool _updateError = false;
  int _updateErrorCode =
      -1; // use this rather than _updateError and _updateSuccess
  String _updateErrorReason = '';
  double percentage = 0.0;

  double? parsePercentage(String line) {
    // Find percentage value
    RegExp _percentageValueSearch = RegExp(r'(\d{1,})(?=%)');
    RegExpMatch? _percentageValueSearchResult =
        _percentageValueSearch.firstMatch(line);

    // Return percentage value if found
    if (_percentageValueSearchResult == null)
      return null;
    else {
      // Convert matched string into double (0.0 to 1.0)
      double _percentage = double.parse(_percentageValueSearchResult[0]!) / 100;
      return _percentage;
    }
  }

  void _updateDevice(SerialPort device) async {
    Process process = await Process.start('echo', ['init_process']);

    if (Platform.isLinux) {
      // Try to execute port knock
      process = await Process.start(
        'stty',
        ['-F', '${device.name}', '1200'],
      );
      if (await process.exitCode != 0) {
        print('Bootloader mode could not be activated');
        setState(() {
          _updateErrorReason = 'stty';
          _updateError = true;
        });
        return;
      } else {
        print('Activated bootloader mode!');
      }

      // Wait for bootloader mode to be activated
      print('Sleeping...');
      sleep(
        Duration(seconds: 5),
      );
      print('Good morning!');

      // Try to update with dfu-util
      process = await Process.start('./assets/util/dfu-util-linux', [
        '-d',
        '0x16D0:0x0CC4,0x0483:0xdf11',
        '-a',
        '0',
        '-s',
        '0x08000000:leave',
        '-D',
        './assets/firmware/X2-1.3.6.dfu'
      ]);

      // Check each outputted line for percentage
      double previousPercentage = 0.0;
      await for (final line in process.outLines) {
        print(line);

        setState(() {
          percentage = parsePercentage(line) ?? previousPercentage;
        });
        print(percentage.toString());

        previousPercentage = percentage;
      }

      if (await process.exitCode != 0) {
        print('Failed to complete update util');
        setState(() {
          _updateErrorReason = 'util';
          _updateError = true;
        });
        return;
      } else {
        print('Update util done!');
      }

      // For each command, if fails, specify what failed for update_error.dart
    } else if (Platform.isMacOS)
      process = await Process.start(
          './assets/util/update-macos.sh', ['${device.name}']);
    else if (Platform.isWindows)
      process = await Process.start(
          './assets/util/update-windows.sh', ['${device.name}']);
    // TODO: raise error
    else {
      print('Incompatable platform');
      process = await Process.start('echo', ['Incompatable', 'platform']);
    }

    _updateErrorCode = await process.exitCode;

    if (_updateErrorCode == 0) {
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
          !_updateError
              ? !_updateSuccess
                  ? UpdateWorking(
                      percentage: percentage,
                    )
                  : UpdateComplete()
              : UpdateError(error: _updateErrorReason),
          if (!_updateSuccess)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.cancel,
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
                      Theme.of(context)
                          .primaryColorDark, // TODO: match with background color
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
