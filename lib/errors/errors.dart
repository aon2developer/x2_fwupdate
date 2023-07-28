import 'package:x2_fwupdate/models/error_message.dart';

enum ErrorType {
  unknown,
  stty,
  util,
  noDriver,
  incompatablePlatform,
}

Map<ErrorType, ErrorMessage> errorContent = {
  ErrorType.unknown: ErrorMessage(
    title: 'Failed to update',
    desc: 'Update error.',
    help: ['Please try again.'],
  ),
  ErrorType.stty: ErrorMessage(
    title: 'Failed to prepare for update',
    desc: 'Could not activate boot loader mode',
    help: [
      'If this happens again, try holding down the top and middle buttons at the same time for 20 seconds.'
    ],
  ),
  ErrorType.util: ErrorMessage(
    title: 'Failed to start update...',
    desc: 'Issue with dfu-util',
    help: [
      'To fix this, hold the middle and top buttons for 20 seconds to shutdown the X2 and try again.',
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
};
