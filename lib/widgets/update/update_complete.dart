import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x2_fwupdate/providers/devices_provider.dart';
import 'package:x2_fwupdate/providers/update_provider.dart';

class UpdateComplete extends ConsumerWidget {
  const UpdateComplete({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Update complete!',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(
              height: 12,
            ),
            Text(
              'You may now unplug your X2 device and close this application.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              'Your X2 will automatically reboot and will be ready soon...',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(
              height: 12,
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () {
            ref.read(updateProvider.notifier).resetErrors();
            ref.read(devicesProvider.notifier).findX2Devices();
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.home,
            size: 26,
          ),
          label: Text(
            'Home',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Colors.white,
                  fontSize: 26,
                ),
          ),
          style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(
              Theme.of(context).primaryColorDark,
            ),
          ),
        ),
      ],
    );
  }
}
