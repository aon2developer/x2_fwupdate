import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';

class AvailableDevicesNotifier extends StateNotifier<List<String>> {
  AvailableDevicesNotifier() : super(SerialPort.availablePorts);

  // TODO: able to implement getter instead?
  void getAvailablePorts() {
    state = SerialPort.availablePorts;
  }
}

final devicesProvider =
    StateNotifierProvider<AvailableDevicesNotifier, List<String>>((ref) {
  return AvailableDevicesNotifier();
});
