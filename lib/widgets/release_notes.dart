import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x2_fwupdate/providers/release_notes_provider.dart';

class ReleaseNotes extends ConsumerWidget {
  ReleaseNotes({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String releaseNotes = ref.watch(releaseNotesProvider);

    return AlertDialog(
      title: Text('Release Notes'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(releaseNotes),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('OK'),
        ),
      ],
    );
  }
}
