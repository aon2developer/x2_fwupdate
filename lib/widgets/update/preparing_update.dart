import 'package:flutter/material.dart';

class PreparingUpdate extends StatelessWidget {
  const PreparingUpdate({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Preparing update...',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        SizedBox(
          height: 12,
        ),
        Text(
          'Please wait while we prepare your X2 to update...',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        CircularProgressIndicator(),
      ],
    );
  }
}
