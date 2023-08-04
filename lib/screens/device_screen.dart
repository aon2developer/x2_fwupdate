import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:x2_fwupdate/widgets/device/device_list.dart';
import 'package:x2_fwupdate/widgets/footer.dart';
import 'package:x2_fwupdate/widgets/device/menu.dart';

class DeviceScreen extends ConsumerStatefulWidget {
  const DeviceScreen({super.key});

  @override
  ConsumerState<DeviceScreen> createState() => _DeviceScreenState();
}

class _DeviceScreenState extends ConsumerState<DeviceScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Menu(),
          SizedBox(
            height: 12,
          ),
          Expanded(child: DeviceList()),
          Footer(),
        ],
      ),
    );
  }
}
