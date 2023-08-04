import 'package:x2_fwupdate/models/error_message.dart';

enum ErrorType {
  unknown,
  update,
  noDriver,
  incompatablePlatform,
  noInternet,
}

Map<ErrorType, ErrorMessage> errorContent = {
  ErrorType.update: ErrorMessage(
    title: 'Failed to update',
    desc: 'An error occured while attempting to update your X2.',
    help: [
      'If this issue persists, try rebooting your X2 by holding down the middle button for 10 seconds.'
    ],
  ),
  ErrorType.noDriver: ErrorMessage(
    title: 'Failed to start update',
    desc: 'You require a boot loader driver to install this update',
    help: [
      'To fix this, click the following link to download the package.',
      '1) Unzip the folder',
      '2.1) Windows 10 and newer: double click X2Driver-Setup-2.exe',
      '2.2) Windows 8.1 and older: double click X2Serial-2.exe',
      'Return here when you\'re done!',
    ],
    link: 'https://www.aon2.co.uk/files/drivers/X2DriverPackage.zip',
  ),
  ErrorType.noInternet: ErrorMessage(
    title: 'Internet connection required',
    desc: 'You require an internet connection to carry out this update.',
    help: [
      'Please ensure that you have a stable internet connection and try again...'
    ],
  ),
};
