import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x2_fwupdate/errors/errors.dart';
import 'package:x2_fwupdate/models/error_message.dart';

import 'package:x2_fwupdate/providers/devices_provider.dart';
import 'package:x2_fwupdate/providers/driver_downloaded_provider.dart';
import 'package:x2_fwupdate/widgets/error_message_widget.dart';
import 'package:x2_fwupdate/widgets/update/update_confirmation.dart';

class DeviceList extends ConsumerStatefulWidget {
  const DeviceList({super.key});

  @override
  ConsumerState<DeviceList> createState() => _DeviceListState();
}

class _DeviceListState extends ConsumerState<DeviceList> {
  void _showCheckDownloadAlert(context) {
    showDialog(
        context: context,
        builder: (context) => StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                title: Text('Have you downloaded the driver?'),
                content: Text('Ensure that the driver is installed!'),
                actions: [
                  TextButton(
                    onPressed: () {
                      ref
                          .read(driverDownloadedProvider.notifier)
                          .setDriverDownloaded(true);
                      Navigator.pop(context);
                    },
                    child: Text('I\'ve downloaded the driver'),
                  ),
                ],
              );
            }));
  }

  void _showDownloadAlert(context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: ErrorMessageWidget(error: errorContent[ErrorType.noDriver]!),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showCheckDownloadAlert(context);
            },
            child: Text('Download'),
          ),
        ],
      ),
    );
  }

  _selectDevice(SerialPort device) {
    showDialog(
      context: context,
      builder: (ctx) => UpdateConfirmation(selectedDevice: device),
    );
  }

  @override
  void initState() {
    super.initState();
    // Wait for build to render then find devices
    Future(() {
      ref.read(devicesProvider.notifier).findX2Devices();
    });
  }

  @override
  Widget build(BuildContext context) {
    final availableDevices = ref.watch(devicesProvider);
    print(availableDevices);
    bool driverDownloaded = ref.watch(driverDownloadedProvider);

    List<Widget> content = [];

    if (availableDevices.isNotEmpty) {
      for (final device in availableDevices) {
        content.add(Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.primary,
              width: 2,
            ),
          ),
          child: ListTile(
            title: Text(
              '${device.productName} by ${device.manufacturer}',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Colors.white,
                  ),
            ),
            onTap: () {
              if (Platform.isWindows && !driverDownloaded)
                _showDownloadAlert(context);
              else
                _selectDevice(device);
            },
          ),
        ));
      }
    } else {
      content = [
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(25),
          child: Column(
            children: [
              ErrorMessageWidget(
                error: ErrorMessage(
                  title: 'No devices found!',
                  desc: 'Try refreshing again...',
                  help: [
                    'If this issue persists, try restarting your X2 by holding the top and middle bottons down at the same time for 10 seconds and turning it on again.',
                  ],
                ),
              ),
            ],
          ),
        ),
      ];
    }

    // TODO: make scrollable
    return ListView.builder(
      itemCount: content.length,
      itemBuilder: (context, index) => content[index],
    );
  }
}
