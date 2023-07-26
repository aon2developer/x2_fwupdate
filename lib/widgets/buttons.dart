import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:x2_fwupdate/providers/devices_provider.dart';

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
              onPressed: () {
                // TODO: display 'refreshed!'
                setState(() {
                  _opacity = 1.0;
                });
                ref.read(devicesProvider.notifier).findX2Devices();
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
