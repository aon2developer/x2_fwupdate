import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:x2_fwupdate/providers/devices_provider.dart';
import 'package:x2_fwupdate/widgets/update_confirmation.dart';

class DeviceList extends ConsumerStatefulWidget {
  const DeviceList({super.key});

  @override
  ConsumerState<DeviceList> createState() => _DeviceListState();
}

class _DeviceListState extends ConsumerState<DeviceList> {
  _selectDevice(SerialPort device) {
    print('Device selected!');

    showDialog(
      context: context,
      builder: (ctx) => UpdateConfirmation(selectedDevice: device),
    );
  }

  @override
  Widget build(BuildContext context) {
    final availableDevices = ref.watch(devicesProvider);
    print(availableDevices);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LoadingAnimationWidget.inkDrop(
            color: Theme.of(context).colorScheme.primary,
            size: 80,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'Searching...',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          SizedBox(
            height: 40,
          ),
          Text(
            'CONNECT YOUR X2',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
        ],
      ),
    );
  }
}
