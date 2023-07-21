import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:process_run/shell.dart';
import 'package:x2_fwupdate/models/update_status.dart';
import 'package:x2_fwupdate/providers/update_provider.dart';
import 'package:x2_fwupdate/widgets/update_complete.dart';
import 'package:x2_fwupdate/widgets/update_error_message.dart';
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
  // // TODO: use providers with UpdateStatus type
  // bool _updateSuccess = false;
  // bool _UpdateErrorMessage = false;
  // int _UpdateErrorMessageCode =
  //     -1; // use this rather than _UpdateErrorMessage and _updateSuccess
  // String _UpdateErrorMessageReason = '';
  // double percentage = 0.0;

  // void _updateDevice(SerialPort device) async {
  //   Process process = await Process.start('echo', ['init_process']);
  //   var updateStatus = ref.watch(updateProvider.notifier);

  //   if (Platform.isLinux) {
  //     // // Try to execute port knock
  //     // process = await Process.start(
  //     //   'stty',
  //     //   ['-F', '${device.name}', '1200'],
  //     // );
  //     // if (await process.exitCode != 0) {
  //     //   print('Bootloader mode could not be activated');
  //     //   setState(() {
  //     //     _UpdateErrorMessageReason = 'stty';
  //     //     _UpdateErrorMessage = true;
  //     //   });
  //     //   return;
  //     // } else {
  //     //   print('Activated bootloader mode!');
  //     // }

  //     // // Wait for bootloader mode to be activated
  //     // print('Sleeping...');
  //     // sleep(
  //     //   Duration(seconds: 5),
  //     // );
  //     // print('Good morning!');

  //     // // Try to update with dfu-util
  //     // process = await Process.start('./assets/util/dfu-util-linux', [
  //     //   '-d',
  //     //   '0x16D0:0x0CC4,0x0483:0xdf11',
  //     //   '-a',
  //     //   '0',
  //     //   '-s',
  //     //   '0x08000000:leave',
  //     //   '-D',
  //     //   './assets/firmware/X2-1.3.6.dfu'
  //     // ]);

  //     process =
  //         await Process.start('./assets/util/percentage_parse_test.sh', []);

  //     // Check each outputted line for percentage
  //     double previousPercentage = 0.0;
  //     await for (final line in process.outLines) {
  //       print(line);

  //       setState(() {
  //         percentage = updateStatus.parsePercentage(line) ?? previousPercentage;
  //       });
  //       print(percentage.toString());

  //       previousPercentage = percentage;
  //     }

  //     if (await process.exitCode != 0) {
  //       print('Failed to complete update util');
  //       setState(() {
  //         _UpdateErrorMessageReason = 'util';
  //         _UpdateErrorMessage = true;
  //       });
  //       return;
  //     } else {
  //       print('Update util done!');
  //     }

  //     // For each command, if fails, specify what failed for update_error.dart
  //   } else if (Platform.isMacOS)
  //     process = await Process.start(
  //         './assets/util/update-macos.sh', ['${device.name}']);
  //   else if (Platform.isWindows)
  //     process = await Process.start(
  //         './assets/util/update-windows.sh', ['${device.name}']);
  //   // TODO: raise error
  //   else {
  //     print('Incompatable platform');
  //     process = await Process.start('echo', ['Incompatable', 'platform']);
  //   }

  //   _UpdateErrorMessageCode = await process.exitCode;

  //   if (_UpdateErrorMessageCode == 0) {
  //     setState(() {
  //       _updateSuccess = true;
  //     });
  //   }
  // }

  // @override
  // void dispose() {
  //   super.dispose();
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   final updateState = ref.read(updateProvider);
  // }

  @override
  Widget build(BuildContext context) {
    SerialPort device = widget.selectedDevice;
    var updateState =
        ref.watch(updateProvider); // not executing when state changes

    print('Latest update status info:');
    print('Update progress: ${updateState.progress}');
    // print('Update error code: ${updateState.error.code}');
    // print('Update error reason: ${updateState.error.reason}');

    return Container(
      decoration: BoxDecoration(color: Theme.of(context).primaryColorDark),
      padding: EdgeInsets.all(24),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // TODO: check logic
          Text('Latest update status info:'),
          Text('Update progress: ${updateState.progress}'),

          // Text('Update error code: ${updateState.error.code}'),
          // Text('Update error reason: ${updateState.error.reason}'),
          UpdateWorking(
            percentage: updateState.progress,
          ),
          // updateState.error.code == 0 // no errors
          //     ? !updateState.complete // not yet complete (updating in progress)
          //         ? UpdateWorking(
          //             percentage: updateState.progress,
          //           )
          //         : UpdateComplete()
          //     : UpdateErrorMessage(error: updateState.error.reason),
          if (updateState.progress < 100) // (updateState.error.code != 0)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    ref.read(updateProvider.notifier).updateDevice(device);
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
