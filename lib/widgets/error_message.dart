import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// TODO: turn into popup rather than enture new screen
class ErrorMessage extends StatelessWidget {
  ErrorMessage(
      {required this.title,
      required this.desc,
      this.help,
      this.link,
      super.key});

  final String title;
  final String desc;
  final List<String>? help;
  final String? link;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        alignment: Alignment.center,
        width: 600,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
                  if (link != null)
                    Container(
                      width: 400,
                      height: 120,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Card(
                              margin: EdgeInsets.symmetric(
                                horizontal: 50,
                                vertical: 20,
                              ),
                              child: InkWell(
                                onTap: () async {
                                  print('Sending to $link');
                                  await launchUrl(Uri.parse(link!));
                                },
                                child: Text(
                                  'Download boot loader driver',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
