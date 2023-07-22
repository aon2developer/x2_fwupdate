import 'dart:io';

import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:process_run/shell.dart';
import 'package:x2_fwupdate/models/update_error.dart';
import 'package:x2_fwupdate/models/update_status.dart';

class UpdateNotifier extends StateNotifier<UpdateStatus> {
  UpdateNotifier()
      : super(
          UpdateStatus(
            progress: -1.0,
            error: UpdateError(
              code: 0,
              reason: '',
              driverInstalled: false,
            ),
          ),
        );

  void resetErrors() {
    state = UpdateStatus(
      progress: -1.0,
      error: UpdateError(
        code: -1, // special code to bypass entering bootloader mode
        reason: '',
        driverInstalled: true,
      ),
    );
  }

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
      double _percentage = double.parse(_percentageValueSearchResult[0]!) /
          100; // TODO: make int or round to nearest .0
      return _percentage;
    }
  }

  void updateDevice(SerialPort device) async {
    Process process = await Process.start('echo', ['init_process']);
    double previousPercentage = state.progress;

    if (Platform.isLinux) {
      // TODO: implement this as a function, take variables that change as parameters
      if (state.error.code != -1) {
        // Activate bootloader mode
        process = await Process.start(
          'stty',
          ['-F', '${device.name}', '1200'],
        );
        if (await process.exitCode != 0) {
          print('Bootloader mode could not be activated');
          state = UpdateStatus(
            error: UpdateError(code: await process.exitCode, reason: 'stty'),
            progress: -1.0,
          );
          return;
        } else {
          print('Activated bootloader mode!');
        }

        // Wait for bootloader mode to be activated
        // TODO: display 'preparing update' on screen with loading symbol
        sleep(
          Duration(seconds: 5),
        );
        // process = await Process.start('sleep', ['5']);
      }

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
      await for (final line in process.outLines) {
        print(line);

        // TODO: find a way to optimise this? Unless you need to create a brand new object every time?
        state = UpdateStatus(
            error: UpdateError(code: 0, reason: ''),
            progress: parsePercentage(line) ?? previousPercentage);

        previousPercentage = state.progress;
      }

      // Check exit code for dfu-util after it finishes output
      if (await process.exitCode != 0) {
        print('Failed to complete update util');
        state.error = UpdateError(code: await process.exitCode, reason: 'util');
        return;
      } else {
        print('Update util done!');
      }

      // For each command, if fails, specify what failed for update_error.dart
    } else if (Platform.isMacOS)
      process = await Process.start(
          './assets/util/update-macos.sh', ['${device.name}']);
    else if (Platform.isWindows) {
      // prompt user to ensure that htey have installed the boot loader driver
      if (!state.error.driverInstalled!) {
        state = UpdateStatus(
          error: UpdateError(code: 1, reason: 'no-driver'),
          progress: -1.0,
        );
        return;
      }

      process = await Process.start(
          './assets/util/update-windows.sh', ['${device.name}']);
    }

    // TODO: raise error
    else {
      print('Incompatable platform');
      process = await Process.start('echo', ['Incompatable', 'platform']);
    }
  }
}

final updateProvider =
    StateNotifierProvider<UpdateNotifier, UpdateStatus>((ref) {
  return UpdateNotifier();
});
