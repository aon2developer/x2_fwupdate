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
      children: [
        Text(
          'Update',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Colors.white,
              ),
        ),
        OutlinedButton(
          onPressed: () {
            ref.read(devicesProvider.notifier).getAvailablePorts();
          },
          child: Text(
            'Refresh',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Colors.white,
                ),
          ),
        ),
        OutlinedButton(
          onPressed: () => exit(0), // TODO: add graceful exit
          child: Text(
            'Exit',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Colors.white,
                ),
          ),
        )
      ],
    );
  }
}
