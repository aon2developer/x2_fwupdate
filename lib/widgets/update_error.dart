import 'package:flutter/material.dart';
import 'package:x2_fwupdate/widgets/error_message.dart';

class UpdateError extends StatelessWidget {
  UpdateError({required this.error, super.key});

  final String error;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(
            'Update error due to $error',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(
            height: 30,
          ),
          if (error == 'stty')
            ErrorMessage(
              desc: 'Failed to prepare for update',
              help:
                  'If this happens again, try holding down the top and middle buttons at the same time for 20 seconds.',
            ),
          if (error == 'util')
            ErrorMessage(
              desc: 'Failed to start update...',
              help:
                  'To fix this, hold the middle button for 10 seconds to shutdown and try again.',
            ),
        ],
      ),
    );
  }
}
