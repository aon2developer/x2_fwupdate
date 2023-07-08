import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:x2_fwupdate/providers/devices_provider.dart';

class Buttons extends ConsumerWidget {
  Buttons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
          onPressed: () {
            print('Update');
          },
          child: Text(
            'Update',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Colors.white,
                  fontSize: 32,
                ),
          ),
        ),
        SizedBox(
          height: 12,
        ),
        OutlinedButton(
          onPressed: () {
            ref.read(devicesProvider.notifier).getFilteredPorts();
          },
          child: Text(
            'Refresh',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Colors.white,
                  fontSize: 26,
                ),
          ),
        ),
        SizedBox(
          height: 12,
        ),
        OutlinedButton(
          onPressed: () => exit(0), // TODO: add graceful exit
          child: Text(
            'Exit',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Colors.white,
                  fontSize: 26,
                ),
          ),
        )
      ],
    );
  }
}
