import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x2_fwupdate/providers/progress_provider.dart';

class ProgressBar extends ConsumerStatefulWidget {
  ProgressBar({super.key});

  @override
  ConsumerState<ProgressBar> createState() => _ProgressBarState();
}

class _ProgressBarState extends ConsumerState<ProgressBar> {
  @override
  Widget build(BuildContext context) {
    final progress = ref.watch(progressProvider);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 300),
      child:
          CircularProgressIndicator(), // temporary while sorting out dynamic progress bar
      // child: LinearProgressIndicator(
      //   value: progress / 100, // convert percentage to double
      //   semanticsLabel: 'Linear progress indicator',
      // ),
    );
  }
}
