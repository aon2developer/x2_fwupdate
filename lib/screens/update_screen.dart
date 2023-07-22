import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:x2_fwupdate/providers/update_provider.dart';
import 'package:x2_fwupdate/widgets/update_complete.dart';
import 'package:x2_fwupdate/widgets/update_error_message.dart';
import 'package:x2_fwupdate/widgets/update_working.dart';

class UpdateScreen extends ConsumerWidget {
  UpdateScreen({required this.selectedDevice, super.key});

  final SerialPort selectedDevice;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SerialPort device = selectedDevice;
    final updateState = ref.watch(updateProvider);

    return Container(
      decoration: BoxDecoration(color: Theme.of(context).primaryColorDark),
      padding: EdgeInsets.all(24),
      width: double.infinity,
      alignment: Alignment.center,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Display different widget depending on updateState
            updateState.error.code == 0 // no errors
                ? updateState.progress <
                        1.0 // not yet complete (updating in progress)
                    ? UpdateWorking(
                        percentage: updateState.progress,
                      )
                    : UpdateComplete()
                : UpdateErrorMessage(
                    error: updateState.error.reason,
                    device: device,
                  ),
          ],
        ),
      ),
    );
  }
}
