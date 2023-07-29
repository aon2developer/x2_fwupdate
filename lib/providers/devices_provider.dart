import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:quick_usb/quick_usb.dart';

// TODO: check if the device is showing as boot loader

class AvailableDevicesNotifier extends StateNotifier<List<SerialPort>> {
  AvailableDevicesNotifier() : super([]);

  Future<String> findX2Devices() async {
    final availablePorts = SerialPort.availablePorts;
    List<SerialPort> filteredPorts = [];

    for (final port in availablePorts) {
      final device = SerialPort(port);

      // TODO: Device displays twice -> prevent duplicates
      if (device.productName == 'X2' && device.manufacturer == 'AON2 Ltd') {
        filteredPorts.add(device);
      }
    }

    state = filteredPorts;

    // Check if X2 is in boot loader mode
    if (filteredPorts.isEmpty) {
      await QuickUsb.init();
      var deviceList = await QuickUsb.getDeviceList();
      await QuickUsb.exit();

      for (final device in deviceList) {
        if (device.productId == 57105 && device.vendorId == 1155) {
          print('X2 has been detected to be in BOOTLOADER MODE!');
          // If boot loader mode is activated, skip preperation
          return 'ready';
        }
      }
    }

    // If boot loader mode is not activated, the device needs to be prepared
    return 'prepare';
  }
}

final devicesProvider =
    StateNotifierProvider<AvailableDevicesNotifier, List<SerialPort>>((ref) {
  return AvailableDevicesNotifier();
});
