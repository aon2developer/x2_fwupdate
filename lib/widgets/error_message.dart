import 'package:flutter/material.dart';

class ErrorMessage extends StatelessWidget {
  ErrorMessage({required this.title, required this.desc, this.help, super.key});

  final String desc;
  final List<String>? help;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 600,
      child: Column(
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
            height: 16,
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onBackground,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                if (help != null)
                  Icon(
                    Icons.info,
                    size: 50,
                    color: Theme.of(context).colorScheme.error,
                  ),
                SizedBox(
                  width: 20,
                ),
                for (final String string in help!)
                  Text(
                    string,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Theme.of(context).colorScheme.background,
                        ),
                    textAlign: TextAlign.center,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
