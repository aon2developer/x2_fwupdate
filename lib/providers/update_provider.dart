import 'dart:io';

import 'package:background_downloader/background_downloader.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:process_run/shell.dart';
import 'package:path_provider/path_provider.dart';

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

  // Takes a string and returns the percentage, if found, as a decimal
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

  Future<Process> executeDfuUtil(String tag, String dir) async {
    // Check/get latest firmware version

    double previousPercentage = state.progress;

    // Replace 1.3.6 with the local version
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

  Future<String> _getLatestFirmware() async {
    // Download firmware from aon2.co.uk
    final task = DownloadTask(
      url: 'https://aon2.co.uk/files/firmware/X2.dfu',
      baseDirectory: BaseDirectory.temporary,
      filename: 'X2.dfu',
      updates: Updates.statusAndProgress,
    );

    // TODO: get directory from task object
    final Directory tempDir = await getTemporaryDirectory();
    final String dir = '${tempDir.path}/${task.filename}';
    print('The file direcotry is "$dir"');

    final result = await FileDownloader().download(
      task,
      // TODO: for debugging; remove once done
      onProgress: (progress) => print('Progress: ${progress * 100}%'),
      onStatus: (status) => print(
        'Status: $status',
      ),
    );

    if (result.status == TaskStatus.complete) {
      print('Success!');
      print('Saved to "$dir"');
    } else
      // TODO: add some sort of notification for user and cancel update
      print('Download not successful');

    return dir;
  }

  // TODO: rename to something more descriptive
  void executeUpdate() async {
    // Get latest firmware version (preparing screen will still be shown here)
    String dir = await _getLatestFirmware();
    print('Firmware location: "$dir"');

    state = UpdateStatus(
        error: state.error, progress: state.progress, screen: 'update-working');

    Process? process;

    // Wait for boot loader mode to activate then begin update depending on
    //  platform

    if (Platform.isLinux) {
      await Future.delayed(Duration(seconds: 2), () {});
      process = await executeDfuUtil('-linux', dir);
      // process = await testUpdate();
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
            UpdateError(code: await process!.exitCode, type: ErrorType.update),
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

    // TODO: delete firmware on device
    final File file = File(dir);
    file.delete();
  }

  // TODO: rename to something like enable boot loader
  void updateDevice(SerialPort device) async {
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

    executeUpdate();
  }
}

final updateProvider =
    StateNotifierProvider<UpdateNotifier, UpdateStatus>((ref) {
  return UpdateNotifier();
});
