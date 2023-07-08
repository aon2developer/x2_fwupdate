import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';

// flutter: Product id: 3268
// flutter: Vendor id: 5840

class AvailableDevicesNotifier extends StateNotifier<List<SerialPort>> {
  AvailableDevicesNotifier() : super([]);

  // TODO: able to implement getter instead?
  void getFilteredPorts() {
    final availablePorts = SerialPort.availablePorts;
    List<SerialPort> filteredPorts = [];

    for (final port in availablePorts) {
      final device = SerialPort(port);

      // print('device.name: ${device.name}');
      // print('productId: ${device.productId}');
      // print('vendorId: ${device.vendorId}');

      // TODO: find a more specific way to filter devices
      // if (device.productId == 3268 && device.vendorId == 5840) {
      if (device.description!.contains('X2')) {
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
