import 'dart:io';
import 'dart:typed_data';

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

  void resetErrors() {
    state = UpdateStatus(
      progress: 0.0,
      error: UpdateError(
        code: -1, // special code to bypass entering bootloader mode
        type: ErrorType.unknown,
        driverInstalled: true,
      ),
      screen: 'preparing-update',
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
      // Convert matched string into double (0.00 to 1.00)
      double _percentage = double.parse(_percentageValueSearchResult[0]!) / 100;
      return _percentage;
    }
  }

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

  Future<Process> executeDfuUtil(String platform) async {
    double previousPercentage = state.progress;

    Process process = await Process.start('./assets/util/dfu-util-$platform', [
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

      state = UpdateStatus(
        error: state.error,
        progress: parsePercentage(line) ?? previousPercentage,
        screen: state.screen,
      );

      previousPercentage = state.progress;
    }

    return process;
  }

  // Temporary for testing writing to port
  Uint8List _stringToUint8List(String data) {
    List<int> codeUnits = data.codeUnits;
    Uint8List uint8list = Uint8List.fromList(codeUnits);
    return uint8list;
  }

  void updateDevice(SerialPort device) async {
    // wait for preparing screen to render

    Process process = await Process.start('echo', ['init_process']);

    state = UpdateStatus(
        error: state.error,
        progress: state.progress,
        screen: 'preparing-update');

    /// PORT KNOCK ///
    // -1 is a special bypass for enabling and checking boot loader mode
    if (state.error.code != -1) {
      // // Enable boot loader mode
      // process = await Process.start(
      //   'assets/util/bootloader-linux.sh',
      //   ['${device.name}'],
      // );

      // if (await process.exitCode != 0) {
      //   state = UpdateStatus(
      //     error: UpdateError(code: 1, type: ErrorType.stty),
      //     progress: -1.0,
      //   );
      //   return;
      // }

      device.openWrite();
      var config = device.config;
      config.baudRate = 1200;
      device.config = config;
      device.config.rts = 1;
      device.config.dtr = 0;
      device.config.bits = 8;
      device.config.stopBits = 1;
      device.config = config;

      print(
          '${device.name} ${device.isOpen ? 'is open at ${device.config.baudRate}' : 'is closed'}');

      // try {
      //   final writtenBytes =
      //       device.write(_stringToUint8List('an amount of bytes?'));
      //   print('Bytes written: $writtenBytes');

      //   print(
      //       '${device.name} ${device.isOpen ? 'is open at ${device.config.baudRate}' : 'is closed'}');
      // } on SerialPortError catch (err, _) {
      //   print(SerialPort.lastError);
      //   print(
      //       '${device.name} ${device.isOpen ? 'is open at ${device.config.baudRate}' : 'is closed'}');
      // }

      device.close();

      print(
          '${device.name} ${device.isOpen ? 'is open at ${device.config.baudRate}' : 'is closed'}');

      ///
    }

    state = UpdateStatus(
        error: state.error, progress: state.progress, screen: 'update-working');

    if (Platform.isLinux)
      process = await executeDfuUtil('linux');
    else if (Platform.isMacOS)
      process = await executeDfuUtil('macos');
    else if (Platform.isWindows) {
      // Prompt user to ensure that they have installed the boot loader driver
      if (!state.error.driverInstalled!) {
        state = UpdateStatus(
          error: UpdateError(code: 1, type: ErrorType.noDriver),
          progress: -1.0,
        );
        return;
      }

      process = await Process.start(
          './assets/util/update-windows.sh', ['${device.name}']);
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
        error: UpdateError(code: await process.exitCode, type: ErrorType.util),
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
}

final updateProvider =
    StateNotifierProvider<UpdateNotifier, UpdateStatus>((ref) {
  return UpdateNotifier();
});
