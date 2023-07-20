import 'package:flutter/material.dart';

class ErrorMessage extends StatelessWidget {
  ErrorMessage({required this.title, required this.desc, this.help, super.key});

  final String desc;
  final String? help;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        SizedBox(
          height: 30,
        ),
        Text(
          desc,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        SizedBox(
          height: 20,
        ),
        if (help != null)
          Icon(
            Icons.info,
            size: 50,
            color: Theme.of(context).colorScheme.error,
          ),
        SizedBox(
          width: 12,
        ),
        Text(
          help!,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}
