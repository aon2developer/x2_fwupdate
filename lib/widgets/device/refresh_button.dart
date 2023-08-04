import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:x2_fwupdate/providers/devices_provider.dart';
import 'package:x2_fwupdate/providers/update_provider.dart';
import 'package:x2_fwupdate/screens/update_screen.dart';

class RefreshButton extends ConsumerStatefulWidget {
  RefreshButton({super.key});

  @override
  ConsumerState<RefreshButton> createState() => _RefreshButtonState();
}

class _RefreshButtonState extends ConsumerState<RefreshButton> {
  double _opacity = 0.0;

  /// Check if an X2 device is in boot loader mode
  Future<bool> _checkMode() async {
    String x2State = await ref.read(devicesProvider.notifier).findX2Devices();

    if (x2State == 'bootloader') {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(
            'Are you sure that you want to update this device?',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Your device is already prepared to be updated.',
              )
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                print('Cancel update');
                Navigator.pop(context);
              },
              child: Text('No, cancel.'),
            ),
            TextButton(
              // Go to update screen and begin update
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) => UpdateScreen(),
                  ),
                );
                // Starts update from boot loader mode
                print('Starting update from boot loader mode!');
                ref.read(updateProvider.notifier).updateX2Device(null);
              },
              child: Text('Yes, update!'),
            ),
          ],
        ),
      );
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // "refreshed" message
        AnimatedOpacity(
          opacity: _opacity,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeOut,
          onEnd: () {
            setState(() {
              _opacity = 0.0;
            });
          },
          child: Text('Refreshed!'),
        ),
        SizedBox(
          height: 6,
        ),
        Column(
          children: [
            ElevatedButton.icon(
              onPressed: () async {
                // display refreshed message
                setState(() {
                  _opacity = 1.0;
                });

                await _checkMode();
              },
              icon: Icon(
                Icons.refresh,
                size: 26,
              ),
              label: Text(
                'Refresh',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Colors.white,
                      fontSize: 26,
                    ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
