import 'dart:io';

import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:process_run/shell.dart';
import 'package:x2_fwupdate/models/update_error.dart';
import 'package:x2_fwupdate/models/update_status.dart';

// TODO: build updates when state is a double but not an UpdateStatus
// Problem: when I return a double from the provider, the build method executes
//  when the value is changed but when setting UpdateStatus.progress, the build
//  method doesn't udate despite part of the state changing.
//  I've also tried reassigning state to a new UpdateStatus object but that
//  hasn't worked either.

class UpdateNotifier extends StateNotifier<UpdateStatus> {
  UpdateNotifier()
      : super(
            UpdateStatus(progress: 0, error: UpdateError(code: 0, reason: '')));

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
    UpdateStatus newState = state;
    double previousPercentage = newState.progress;

    if (Platform.isLinux) {
      // // Try to execute port knock
      // process = await Process.start(
      //   'stty',
      //   ['-F', '${device.name}', '1200'],
      // );
      // if (await process.exitCode != 0) {
      //   print('Bootloader mode could not be activated');
      //   state.error = UpdateError(code: await process.exitCode, reason: 'stty');
      //   return;
      // } else {
      //   print('Activated bootloader mode!');
      // }

      // // Wait for bootloader mode to be activated
      // print('Sleeping...');
      // sleep(
      //   Duration(seconds: 5),
      // );
      // print('Good morning!');

      // // TODO: display 'preparing update' on screen with loading symbol
      // // Try to update with dfu-util
      // process = await Process.start('./assets/util/dfu-util-linux', [
      //   '-d',
      //   '0x16D0:0x0CC4,0x0483:0xdf11',
      //   '-a',
      //   '0',
      //   '-s',
      //   '0x08000000:leave',
      //   '-D',
      //   './assets/firmware/X2-1.3.6.dfu'
      // ]);

      process =
          await Process.start('./assets/util/percentage_parse_test.sh', []);

      // Check each outputted line for percentage
      await for (final line in process.outLines) {
        print(line);

        newState.progress = parsePercentage(line) ??
            previousPercentage; // maybe only updates when state updates rather than part of state?
        print(newState.progress.toString());

        previousPercentage = newState.progress;
      }

      // // Check exit code for dfu-util after it finishes output
      // if (await process.exitCode != 0) {
      //   print('Failed to complete update util');
      //   state.error = UpdateError(code: await process.exitCode, reason: 'util');
      //   return;
      // } else {
      //   print('Update util done!');
      // }

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

    state = newState;

    // // Mark the update as complete (will only get here if NOT returned from error)
    // state.complete = true;
  }
}

final updateProvider =
    StateNotifierProvider<UpdateNotifier, UpdateStatus>((ref) {
  return UpdateNotifier();
});

// TODO: move the progress parser and setter into a provider
