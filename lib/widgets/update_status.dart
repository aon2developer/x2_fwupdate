import 'package:flutter/material.dart';

class UpdateStatus extends StatelessWidget {
  const UpdateStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        Text('Updating device...'),
      ],
    );
  }
}
