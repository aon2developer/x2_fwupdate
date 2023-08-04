import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:x2_fwupdate/widgets/buttons.dart';
import 'package:x2_fwupdate/widgets/device_list.dart';
import 'package:x2_fwupdate/widgets/footer.dart';

class DeviceScreen extends ConsumerStatefulWidget {
  const DeviceScreen({super.key});

  @override
  ConsumerState<DeviceScreen> createState() => _DeviceScreenState();
}

class _DeviceScreenState extends ConsumerState<DeviceScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).primaryColorDark),
      padding: EdgeInsets.all(24),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "X2 firmware update utility",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      "Version 2.0",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                        "Navigate to the X2's main menu, then plug in to the USB port.",
                        style: Theme.of(context).textTheme.bodyMedium),
                    SizedBox(
                      height: 6,
                    ),
                    Text("Select device from list, then click 'Update'",
                        style: Theme.of(context).textTheme.bodyMedium)
                  ],
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  child: Buttons(),
                ),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            DeviceList(),
          ]),
          Footer(),
        ],
      ),
    );
  }
}
