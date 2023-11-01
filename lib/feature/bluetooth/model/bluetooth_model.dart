import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothModel {
  List<ScanResult> scanResultList = <ScanResult>[];
  ScanResult? selectedDevice;

  BluetoothModel({
    this.scanResultList = const <ScanResult>[],
    this.selectedDevice,
  });

  BluetoothModel copyWith({
    List<ScanResult>? scanResultList,
    ScanResult? selectedDevice,
  }) {
    return BluetoothModel(
      scanResultList: scanResultList ?? this.scanResultList,
      selectedDevice: selectedDevice ?? this.selectedDevice,
    );
  }
}
