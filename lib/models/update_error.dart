class UpdateError {
  UpdateError({required this.code, required this.reason, this.driverInstalled});

  int code;
  String reason;
  bool? driverInstalled = false;
}
