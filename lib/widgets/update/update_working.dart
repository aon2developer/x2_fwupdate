import 'package:flutter/material.dart';
import 'package:x2_fwupdate/widgets/update/progress_bar.dart';

class UpdateWorking extends StatelessWidget {
  UpdateWorking({required this.percentage, super.key});

  final double percentage;

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
        ProgressBar(percentage: percentage),
      ],
    );
  }
}
