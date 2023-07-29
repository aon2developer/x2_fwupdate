import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';

// TODO: check if the device is showing as boot loader

class AvailableDevicesNotifier extends StateNotifier<List<SerialPort>> {
  AvailableDevicesNotifier() : super([]);

  void findX2Devices() {
    final availablePorts = SerialPort.availablePorts;
    List<SerialPort> filteredPorts = [];

    for (final port in availablePorts) {
      final device = SerialPort(port);

      if (device.productName == 'X2' && device.manufacturer == 'AON2 Ltd') {
        filteredPorts.add(device);
      }
    }

    state = filteredPorts;
  }
}

final devicesProvider =
    StateNotifierProvider<AvailableDevicesNotifier, List<SerialPort>>((ref) {
  return AvailableDevicesNotifier();
});
