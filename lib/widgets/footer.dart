import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x2_fwupdate/providers/release_notes_provider.dart';
import 'package:x2_fwupdate/widgets/release_notes.dart';

class Footer extends ConsumerWidget {
  Footer({super.key});

  // TODO: push to bottom
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            'assets/images/aon2-logo-white.png',
            width: 200,
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(releaseNotesProvider.notifier).getReleaseNotes();

              showDialog(
                context: context,
                builder: (ctx) => ReleaseNotes(),
              );
            },
            child: Text('Release Notes'),
          ),
          Text(
            'Copyright AON2',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
