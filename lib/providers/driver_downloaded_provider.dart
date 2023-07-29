import 'package:flutter_riverpod/flutter_riverpod.dart';

class DriverDownloadedNotifier extends StateNotifier<bool> {
  DriverDownloadedNotifier() : super(false);

  void setDriverDownloaded(bool driverDownloaded) {
    state = driverDownloaded;
  }
}

final driverDownloadedProvider =
    StateNotifierProvider<DriverDownloadedNotifier, bool>((ref) {
  return DriverDownloadedNotifier();
});
