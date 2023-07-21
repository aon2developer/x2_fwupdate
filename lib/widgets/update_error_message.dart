import 'package:flutter/material.dart';
import 'package:x2_fwupdate/widgets/error_message.dart';

// TODO: if errors, mass find and replaced all but /models
class UpdateErrorMessage extends StatelessWidget {
  UpdateErrorMessage({required this.error, super.key});

  final String error;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          if (error == 'stty')
            ErrorMessage(
              title: 'Failed to prepare for update',
              desc: 'Update error due to $error',
              help:
                  'If this happens again, try holding down the top and middle buttons at the same time for 20 seconds.',
            ),
          if (error == 'util')
            ErrorMessage(
              title: 'Failed to start update...',
              desc: 'Update error due to $error',
              help:
                  'To fix this, hold the middle button for 10 seconds to shutdown and try again.',
            ),
        ],
      ),
    );
  }
}
