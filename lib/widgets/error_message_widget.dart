import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:x2_fwupdate/models/error_message.dart';

class ErrorMessageWidget extends StatelessWidget {
  ErrorMessageWidget({super.key, required this.error});

  final ErrorMessage error;

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
              error.title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              error.desc,
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
                  if (error.help != null)
                    Icon(
                      Icons.info,
                      size: 50,
                      color: Theme.of(context).colorScheme.error,
                    ),
                  SizedBox(
                    width: 20,
                  ),
                  for (final String string in error.help!)
                    Text(
                      string,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Theme.of(context).colorScheme.background,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  if (error.link != null)
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
                                  print('Sending to ${error.link}');
                                  await launchUrl(Uri.parse(error.link!));
                                },
                                child: Text(
                                  error.link!,
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
