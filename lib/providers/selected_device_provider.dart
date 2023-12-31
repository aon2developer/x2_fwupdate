import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';

class AvailableDevicesNotifier extends StateNotifier<SerialPort> {
  AvailableDevicesNotifier()
      : super(SerialPort(SerialPort.availablePorts.first));

  void selectDevice(SerialPort device) {
    state = device;
  }
}

final selectedDeviceProvider =
    StateNotifierProvider<AvailableDevicesNotifier, SerialPort>((ref) {
  return AvailableDevicesNotifier();
});
