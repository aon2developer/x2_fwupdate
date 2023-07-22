import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProgressBar extends ConsumerStatefulWidget {
  ProgressBar({required this.percentage, super.key});

  final double percentage;

  @override
  ConsumerState<ProgressBar> createState() => _ProgressBarState();
}

class _ProgressBarState extends ConsumerState<ProgressBar> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 600,
          child: LinearProgressIndicator(
            value: widget.percentage, // convert percentage to double
            minHeight: 18,
          ),
        ),
        SizedBox(
          width: 20,
        ),
        Text(
          // Convert decimal to percentage (e.g. 0.3 to 30.0%)
          '${(widget.percentage * 100).toInt()}%',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
