import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:x2_fwupdate/widgets/buttons.dart';
import 'package:x2_fwupdate/widgets/devices_list.dart';

class UpdateScreen extends ConsumerWidget {
  const UpdateScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(color: Color.fromARGB(255, 0, 0, 0)),
          padding: EdgeInsets.all(24),
          width: double.infinity, // TODO: make use of entire horizonal space
          child: Column(
            children: [
              Row(
                children: [
                  Column(
                    children: [
                      Text(
                        "X2 firmware update utility",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        "Version 2.0",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                          "Navigate to the X2's main menu, then plug in to the USB port.",
                          style: Theme.of(context).textTheme.bodyMedium),
                      Text("Select device from list, then click 'Update'",
                          style: Theme.of(context).textTheme.bodyMedium)
                    ],
                  ),
                  Buttons()
                ],
              ),
              DeviceList(),
            ],
          ),
        ),
      ),
    );
  }
}
