import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:x2_fwupdate/providers/devices_provider.dart';
import 'package:x2_fwupdate/providers/update_provider.dart';
import 'package:x2_fwupdate/screens/update_screen.dart';
import 'package:x2_fwupdate/widgets/update/update_confirmation.dart';

class Buttons extends ConsumerStatefulWidget {
  Buttons({super.key});

  @override
  ConsumerState<Buttons> createState() => _ButtonsState();
}

class _ButtonsState extends ConsumerState<Buttons> {
  double _opacity = 0.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedOpacity(
          // When pressed, animate from 100 to 0
          opacity: _opacity,
          duration: Duration(
            milliseconds: 500,
          ),
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
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton.icon(
              onPressed: () async {
                setState(() {
                  _opacity = 1.0;
                });

                String x2State =
                    await ref.read(devicesProvider.notifier).findX2Devices();

                if (x2State == 'ready') {
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
                            print('Starting update from boot loader mode!');
                            ref.read(updateProvider.notifier).executeUpdate();
                          },
                          child: Text('Yes, update!'),
                        ),
                      ],
                    ),
                  );
                }
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
            SizedBox(
              height: 12,
            ),
            ElevatedButton.icon(
              onPressed: () => exit(0), // TODO: add graceful exit
              icon: Icon(
                Icons.exit_to_app,
                size: 26,
              ),
              label: Text(
                'Exit',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Colors.white,
                      fontSize: 26,
                    ),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(
                  Theme.of(context)
                      .primaryColorDark, // TODO: match with background color
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
