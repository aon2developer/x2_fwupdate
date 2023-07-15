import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProgressNotifier extends StateNotifier<double> {
  ProgressNotifier() : super(0.0);

  // Executed every time a new output is given from process status
  void getProgress() {
    // Find progress percentage from output
    // Set as progress
    print('Getting progress!');
    double progress = 0.2;

    state = progress;
  }
}

final progressProvider = StateNotifierProvider<ProgressNotifier, double>((ref) {
  return ProgressNotifier();
});
