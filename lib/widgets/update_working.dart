import 'package:flutter/material.dart';
import 'package:x2_fwupdate/widgets/progress_bar.dart';

class UpdateWorking extends StatelessWidget {
  const UpdateWorking({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Updating device...',
            style: Theme.of(context).textTheme.titleMedium),
        Text(
          'This will take around 2 minutes...',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        SizedBox(
          height: 50,
        ),
        ProgressBar(),
      ],
    );
  }
}
