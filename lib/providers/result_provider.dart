import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:process_run/shell.dart';

Shell shell = Shell();

class ResultNotifier extends StateNotifier<Future<List<ProcessResult>>> {
  ResultNotifier() : super(shell.run('echo result_provider'));

  // Find progress percentage from output
  Future<List<ProcessResult>> getResult() {
    print('Getting result!');
    Future<List<ProcessResult>> result = shell.run('echo result_provider');

    state = result;
    return result;
  }
}

final resultProvider =
    StateNotifierProvider<ResultNotifier, Future<List<ProcessResult>>>((ref) {
  return ResultNotifier();
});
