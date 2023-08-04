import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:x2_fwupdate/errors/errors.dart';
import 'package:x2_fwupdate/providers/selected_device_provider.dart';
import 'package:x2_fwupdate/providers/update_provider.dart';
import 'package:x2_fwupdate/widgets/footer.dart';
import 'package:x2_fwupdate/widgets/update/preparing_update.dart';
import 'package:x2_fwupdate/widgets/update/update_complete.dart';
import 'package:x2_fwupdate/widgets/update/update_error_message.dart';
import 'package:x2_fwupdate/widgets/update/update_working.dart';

class UpdateScreen extends ConsumerWidget {
  UpdateScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SerialPort device = ref.watch(selectedDeviceProvider);
    final updateState = ref.watch(updateProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Dummy container to move update message to center
            Container(),
            // Display different widget depending on updateState.screen
            if (updateState.error.code != 0)
              UpdateErrorMessage(
                  error: errorContent[updateState.error.type] ??
                      errorContent[ErrorType.unknown]!,
                  device: device)
            else if (updateState.screen == 'preparing-update')
              PreparingUpdate()
            else if (updateState.screen == 'update-working')
              UpdateWorking(percentage: updateState.progress)
            else if (updateState.screen == 'update-complete')
              UpdateComplete()
            else
              UpdateErrorMessage(
                error: errorContent[ErrorType.unknown]!,
                device: device,
              ),
            Footer(),
          ],
        ),
      ),
    );
  }
}
