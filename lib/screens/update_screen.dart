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
                'Progress bar',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(
                height: 24,
              ),
              OutlinedButton(
                onPressed: () {
                  // Cancel update
                  Navigator.pop(context);
                },
                child: Text(
                  'Cancel button',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
