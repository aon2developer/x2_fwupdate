import 'package:flutter/material.dart';
import 'package:x2_fwupdate/widgets/progress_bar.dart';

class UpdateScreen extends StatelessWidget {
  const UpdateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).primaryColorDark),
      padding: EdgeInsets.all(24),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            'Updating device...',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontSize: 44,
                ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'This will take around 2 minutes...',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(
                height: 12,
              ),
              ProgressBar(),
              SizedBox(
                height: 24,
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.cancel,
                  size: 26,
                ),
                label: Text(
                  'Cancel update',
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
              )
            ],
          ),
        ],
      ),
    );
  }
}
