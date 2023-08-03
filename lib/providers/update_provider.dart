import 'dart:io';

import 'package:background_downloader/background_downloader.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:process_run/shell.dart';
import 'package:http/http.dart' as http;

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

  Future<Process> executeDfuUtil(String tag, String version) async {
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
      './assets/firmware/X2-$version.dfu'
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

  // Check local firmware version and update if latest is different
  Future<String> _getLatestFirmware() async {
    late String latestVersion;
    late String localVersion;

    // Get local version
    final String path = 'assets/firmware/X2_fw_ver.txt';
    final File file = File(path);

    localVersion = await file.readAsString();

    print('Local version: "$localVersion"');

    // Get latest version
    final url = Uri.https('aon2.co.uk', 'files/firmware/X2_fw_ver.txt');

    final response = await http.get(url);

    // TODO: add some sort of notification for user
    if (response.statusCode >= 400) {
      print(
          'Failed to get latest version with status code "${response.statusCode}');
      print('Reverting to previous version...');
      return localVersion;
    } else {
      // Only get here if we received something
      latestVersion = response.body;

      print('Latest version: "$latestVersion"');
    }

    // TODO: implement some sort of parser for software versions rather than check difference
    // Download the latest version and update the local version value
    if (latestVersion != localVersion) {
      // TODO: figure out why its not downloading (parameters too specific/wrong?)
      // Download firmware from AON2
      final task = DownloadTask(
        url: 'https://aon2.co.uk/files/firmware',
        filename: 'X2_fw_ver.txt',
        directory: 'assets/firmware',
        updates: Updates.statusAndProgress,
      );
      final result = await FileDownloader().download(
        task,
        onProgress: (progress) => print('Progress: ${progress * 100}%'),
        onStatus: (status) => print(
          'Status: $status',
        ),
      );

      if (result.status == TaskStatus.complete)
        print('Success!'); // Remove old version
      else if (result.status == TaskStatus.canceled)
        print('Download was canceled');
      else if (result.status == TaskStatus.paused)
        print('Download was paused');
      else
        print('Download not successful');

      file.writeAsString(latestVersion);
      localVersion = latestVersion;
    }

    return localVersion;
  }

  void executeUpdate() async {
    // Get latest firmware version (preparing screen will still be shown here)
    String version = await _getLatestFirmware();
    version = version.trim();
    print('Updating firmware to version "$version"...');

    state = UpdateStatus(
        error: state.error, progress: state.progress, screen: 'update-working');

    Process? process;

    // Wait for boot loader mode to activate then begin update depending on
    //  platform

    if (Platform.isLinux) {
      await Future.delayed(Duration(seconds: 2), () {});
      process = await executeDfuUtil('-linux', version);
      // process = await testUpdate();
    } else if (Platform.isMacOS) {
      await Future.delayed(Duration(seconds: 5), () {});

      process = await executeDfuUtil('-mac', version);
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

      process = await executeDfuUtil('.exe', version);
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
  }

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
