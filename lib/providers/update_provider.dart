import 'dart:io';

import 'package:background_downloader/background_downloader.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:process_run/shell.dart';

import 'package:x2_fwupdate/errors/errors.dart';
import 'package:x2_fwupdate/models/update_error.dart';
import 'package:x2_fwupdate/models/update_status.dart';

class UpdateNotifier extends StateNotifier<UpdateStatus> {
  UpdateNotifier()
      : super(
          UpdateStatus(
            progress: 0.0,
            error: UpdateError(
              code: 0,
              type: ErrorType.unknown,
              driverInstalled: false,
            ),
            screen: 'preparing-update',
          ),
        );

  /// Resets update errors
  ///
  /// NOTE: no checking is in place to check that a driver is installed
  void resetErrors() {
    state = UpdateStatus(
      progress: 0.0,
      error: UpdateError(
        code: 0,
        type: ErrorType.unknown,
        driverInstalled: true,
      ),
      screen: 'preparing-update',
    );
  }

  /// Takes a string and returns the percentage as a decimal
  ///
  /// If a percentage cannot be found, returns null
  double? parsePercentage(String line) {
    // Find percentage value
    RegExp _percentageValueSearch = RegExp(r'(\d{1,})(?=%)');
    RegExpMatch? _percentageValueSearchResult =
        _percentageValueSearch.firstMatch(line);

    // Return percentage value if found
    if (_percentageValueSearchResult == null)
      return null;
    else {
      // Convert matched string into double (0.00 to 1.00)
      double _percentage = double.parse(_percentageValueSearchResult[0]!) / 100;
      return _percentage;
    }
  }

  // TODO: remove on release
  Future<Process> testUpdate() async {
    _getLatestFirmware();

    print('Pretending to activate bootloader mode...');

    print('Sleeping...');
    sleep(
      Duration(seconds: 5),
    );
    print('I have awoken!');

    // FOR TESTING PROGRESS BAR
    Process process =
        await Process.start('assets/util/percentage_parse_test.sh', []);
    double previousPercentage = state.progress;
    // Check each outputted line for percentage
    await for (final line in process.outLines) {
      print(line);

      state = UpdateStatus(
        error: UpdateError(code: 0, type: ErrorType.unknown),
        progress: parsePercentage(line) ?? previousPercentage,
        screen: state.screen,
      );

      previousPercentage = state.progress;
    }
    return process;
  }

  /// Executes dfu-util given a util tag and firmware directory
  Future<Process> executeDfuUtil(String tag, String dir) async {
    double previousPercentage = state.progress;

    // Possible vulnerability: if the string stored in the website was
    //  manipulated to create a full string to a malicous piece of firmware on
    //  the target computer then it is possible that an attacker could update
    //  the X2's firmware with a malicous firmware.
    // Example: "./assets/firmware/X2-$version.dfu" >
    //  "./assets/firmware/X2-my-malicous-firmware.dfu"
    Process process = await Process.start('./assets/util/dfu-util$tag', [
      '-d',
      '0x16D0:0x0CC4,0x0483:0xdf11',
      '-a',
      '0',
      '-s',
      '0x08000000:leave',
      '-D',
      '$dir'
    ]);

    // Check each outputted line for percentage
    await for (final line in process.outLines) {
      print(line);

      state = UpdateStatus(
        error: state.error,
        progress: parsePercentage(line) ?? previousPercentage,
        screen: state.screen,
      );

      previousPercentage = state.progress;
    }

    return process;
  }

  /// Download firmware from aon2.co.uk
  ///
  /// Will return directory of downloaded firmware otherwise 'null'
  Future<String> _getLatestFirmware() async {
    final task = DownloadTask(
      url: 'https://aon2.co.uk/files/firmware/X2.dfu',
      baseDirectory: BaseDirectory.temporary,
      filename: 'X2.dfu',
      updates: Updates.statusAndProgress,
    );

    final result = await FileDownloader().download(task);

    final String dir = await result.task.filePath();

    if (result.status == TaskStatus.complete) {
      print('Success!');
      print('Saved to "$dir"');
    } else {
      print('Download not successful');

      return 'null';
    }

    return dir;
  }

  /// Will install firmware to an X2 device depending on Platform
  ///
  /// Requires the internet
  ///
  /// Will load a firmware package into temporary device storage
  void installFirmware() async {
    String dir = await _getLatestFirmware();

    if (dir == 'null') {
      state = UpdateStatus(
        error: UpdateError(code: 1, type: ErrorType.noInternet),
        progress: -1.0,
      );
      return;
    }

    print('Firmware location: "$dir"');

    state = UpdateStatus(
        error: state.error, progress: state.progress, screen: 'update-working');

    Process? process;

    // Execute dfu-util depending on platform
    if (Platform.isLinux) {
      await Future.delayed(Duration(seconds: 2), () {});
      process = await executeDfuUtil('-linux', dir);
    } else if (Platform.isMacOS) {
      await Future.delayed(Duration(seconds: 5), () {});

      process = await executeDfuUtil('-mac', dir);
    } else if (Platform.isWindows) {
      await Future.delayed(Duration(seconds: 5), () {});

      // Prompt user to ensure that they have installed the boot loader driver
      if (!state.error.driverInstalled!) {
        state = UpdateStatus(
          error: UpdateError(code: 1, type: ErrorType.noDriver),
          progress: -1.0,
        );
        return;
      }

      process = await executeDfuUtil('.exe', dir);
    } else {
      print('Incompatable platform');
      process = await Process.start('echo', ['Incompatable', 'platform']);
      state = UpdateStatus(
        error: UpdateError(code: 1, type: ErrorType.incompatablePlatform),
        progress: 0,
      );
      return;
    }

    // Ensure dfu-util exits successfully
    if (await process.exitCode != 0) {
      print('Failed to complete update util');
      state = UpdateStatus(
        error:
            UpdateError(code: await process.exitCode, type: ErrorType.update),
        progress: 0,
      );
      return;
    } else {
      print('Update util done!');
    }

    // Only gets here when passed all error tests and have "awaited" all processes
    state = UpdateStatus(
        error: state.error,
        progress: state.progress,
        screen: 'update-complete');

    // Remove the downloaded firmware
    final File file = File(dir);
    file.delete();
  }

  /// Will prepare an X2 to be updated
  ///
  /// Executes a port knock
  void prepareDevice(SerialPort device) async {
    state = UpdateStatus(
        error: state.error,
        progress: state.progress,
        screen: 'preparing-update');

    // Enable boot loader mode
    device.openWrite();
    var config = device.config;
    config.baudRate = 1200;
    device.config = config;
    device.config.rts = 1;
    device.config.dtr = 0;
    device.config.bits = 8;
    device.config.stopBits = 1;
    device.config = config;

    installFirmware();
  }
}

final updateProvider =
    StateNotifierProvider<UpdateNotifier, UpdateStatus>((ref) {
  return UpdateNotifier();
});
