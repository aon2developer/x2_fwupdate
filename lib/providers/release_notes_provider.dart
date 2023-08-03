import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class ReleaseNotesNotifier extends StateNotifier<String> {
  ReleaseNotesNotifier() : super('Unable to get newest firmware version...');

  Future<bool> getReleaseNotes() async {
    final url = Uri.https('aon2.co.uk', 'files/firmware/X2_fw_ver.txt');

    final response = await http.get(url);

    if (response.statusCode >= 400) return false;

    state = response.body.trim();
    return true;
  }
}

final releaseNotesProvider =
    StateNotifierProvider<ReleaseNotesNotifier, String>((ref) {
  return ReleaseNotesNotifier();
});
