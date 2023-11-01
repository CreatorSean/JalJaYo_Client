import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BluetoothDevicesViewModel extends AsyncNotifier<List<ScanResult>> {
  List<ScanResult> scanResultList = <ScanResult>[];
  final FlutterBluePlus flutterBlue = FlutterBluePlus.instance;

  void initBLE() {
    flutterBlue.isScanning.listen((isScanning) {
      print("isScanning: $isScanning");
    });
  }

  List<ScanResult> sortDevices(List<ScanResult> result) {
    List<ScanResult> names =
        result.where((r) => r.device.name.isNotEmpty).toList();

    names.addAll(result
        .where((r) =>
            r.advertisementData.localName.isNotEmpty && r.device.name.isEmpty)
        .toList());
    final noNames = result
        .where((r) =>
            r.device.name.isEmpty && r.advertisementData.localName.isEmpty)
        .toList();

    names.sort((a, b) => a.device.name.compareTo(b.device.name));

    names.addAll(noNames);

    return names;
  }

  Future<void> scanDevices() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      scanResultList.clear();
      // 스캔 결과 리스너
      flutterBlue.scanResults.listen((results) {
        scanResultList = results;
      });
      // 스캔 시작, 제한 시간 4초
      await flutterBlue.startScan(timeout: const Duration(seconds: 4));

      scanResultList = sortDevices(scanResultList);

      return scanResultList;
    });
  }

  @override
  FutureOr<List<ScanResult>> build() {
    // initBLE();

    return scanResultList;
  }
}

final bluetooDevicesthViewModelProvider =
    AsyncNotifierProvider<BluetoothDevicesViewModel, List<ScanResult>>(
  () => BluetoothDevicesViewModel(),
);
