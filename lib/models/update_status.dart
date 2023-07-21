import 'package:x2_fwupdate/models/update_error.dart';

class UpdateStatus {
  UpdateStatus({required this.error, required this.progress});

  UpdateError error;
  double progress;
}
