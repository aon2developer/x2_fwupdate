import 'package:x2_fwupdate/errors/errors.dart';

class UpdateError {
  UpdateError({required this.code, required this.type, this.driverInstalled});

  int code;
  ErrorType type;
  bool? driverInstalled = false;
}
