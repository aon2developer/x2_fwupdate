import 'package:flutter/material.dart';

class UpdateScreen extends StatelessWidget {
  const UpdateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).primaryColorDark),
      padding: EdgeInsets.all(24),
      width: double.infinity,
      child: Column(
        children: [
          BackButton(
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          Text('Updating device...'),
          Text('Progress bar'),
          Text('Cancel button'),
        ],
      ),
    );
  }
}
