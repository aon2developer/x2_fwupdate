import 'package:x2_fwupdate/models/update_error.dart';

class UpdateStatus {
  UpdateStatus({required this.error, required this.progress});

  bool complete = false;
  UpdateError error;
  double progress;
}
