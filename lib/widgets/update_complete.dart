import 'package:flutter/material.dart';

class UpdateComplete extends StatelessWidget {
  const UpdateComplete({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Update complete!',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              'You may now close this application.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.home,
            size: 26,
          ),
          label: Text(
            'Home',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Colors.white,
                  fontSize: 26,
                ),
          ),
          style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(
              Theme.of(context)
                  .primaryColorDark, // TODO: match with background color
            ),
          ),
        ),
      ],
    );
  }
}
