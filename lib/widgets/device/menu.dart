import 'package:flutter/material.dart';

import 'package:x2_fwupdate/widgets/device/refresh_button.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'X2 firmware update utility',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              'Version 2.0',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
                'Navigate to the X2\'s main menu, then plug in to the USB port.',
                style: Theme.of(context).textTheme.bodyMedium),
            SizedBox(
              height: 6,
            ),
            Text('Select device from list to update.',
                style: Theme.of(context).textTheme.bodyMedium)
          ],
        ),
        // Refresh button
        Container(
          alignment: Alignment.bottomCenter,
          child: RefreshButton(),
        ),
      ],
    );
  }
}
