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
