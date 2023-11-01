import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jaljayo/feature/bluetooth/model/bluetooth_model.dart';

class BluetoothDevicesViewModel extends AsyncNotifier<BluetoothModel> {
  BluetoothModel model = BluetoothModel();
  final FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
  List<BluetoothService> bluetoothService = [];
  Map<String, List<int>> notifyDatas = {};

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

  Future<void> connectDevice(ScanResult device) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      model = model.copyWith(selectedDevice: device);
      List<ScanResult> scanResultList = model.scanResultList;
      if (model.selectedDevice != null) {
        scanResultList.removeWhere((element) =>
            element.device.id.id == model.selectedDevice!.device.id.id);

        model = model.copyWith(
            scanResultList: [model.selectedDevice!] + scanResultList);
      }

      for (device in model.scanResultList) {
        await device.device.disconnect();
      }

      return model;
    });

    await connect();
  }

  Future<void> scanDevices() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      try {
        List<ScanResult> scanResultList = <ScanResult>[];
        scanResultList.clear();
        // 스캔 결과 리스너
        flutterBlue.scanResults.listen((results) {
          scanResultList = results;
        });
        // 스캔 시작, 제한 시간 4초
        await flutterBlue.startScan(timeout: const Duration(seconds: 4));

        scanResultList = sortDevices(scanResultList);

        model = model.copyWith(scanResultList: scanResultList);

        return model;
      } catch (e) {
        print(e);
        return model;
      }
    });
  }

  @override
  FutureOr<BluetoothModel> build() {
    // initBLE();

    return model;
  }

  Future<bool> connect() async {
    Future<bool>? returnValue;
    /* 
      타임아웃을 15초(15000ms)로 설정 및 autoconnect 해제
       참고로 autoconnect가 true되어있으면 연결이 지연되는 경우가 있음.
     */
    await model.selectedDevice!.device
        .connect(autoConnect: false)
        .timeout(const Duration(milliseconds: 15000), onTimeout: () {
      //타임아웃 발생
      //returnValue를 false로 설정
      returnValue = Future.value(false);
      debugPrint('timeout failed');
    }).then((data) async {
      bluetoothService.clear();
      if (returnValue == null) {
        //returnValue가 null이면 timeout이 발생한 것이 아니므로 연결 성공
        debugPrint('connection successful');
        debugPrint('start discover service');
        List<BluetoothService> bleServices =
            await model.selectedDevice!.device.discoverServices();

        bluetoothService = bleServices;

        // 각 속성을 디버그에 출력
        for (BluetoothService service in bleServices) {
          debugPrint('============================================');
          debugPrint('Service UUID: ${service.uuid}');
          for (BluetoothCharacteristic c in service.characteristics) {
            debugPrint('\tcharacteristic UUID: ${c.uuid.toString()}');
            debugPrint('\t\twrite: ${c.properties.write}');
            debugPrint('\t\tread: ${c.properties.read}');
            debugPrint('\t\tnotify: ${c.properties.notify}');
            debugPrint('\t\tisNotifying: ${c.isNotifying}');
            debugPrint(
                '\t\twriteWithoutResponse: ${c.properties.writeWithoutResponse}');
            debugPrint('\t\tindicate: ${c.properties.indicate}');

            // notify나 indicate가 true면 디바이스에서 데이터를 보낼 수 있는 캐릭터리스틱이니 활성화 한다.
            // 단, descriptors가 비었다면 notify를 할 수 없으므로 패스!
            if (c.properties.notify && c.descriptors.isNotEmpty) {
              // 진짜 0x2902 가 있는지 단순 체크용!
              for (BluetoothDescriptor d in c.descriptors) {
                debugPrint('BluetoothDescriptor uuid ${d.uuid}');
                if (d.uuid == BluetoothDescriptor.cccd) {
                  debugPrint('d.lastValue: ${d.lastValue}');
                }
              }
              print("ok1");
              if (c.properties.read) {
                print("ok2");
                List<int> value = await c.read();
                print("value:  $value");
                print(String.fromCharCodes(value));
                c.value.listen((value) {
                  // 데이터 읽기 처리!
                  print('${c.uuid}: $value');
                });
              }

              // notify가 설정 안되었다면...
              // if (!c.isNotifying) {
              //   try {
              //     await c.setNotifyValue(true);
              //     // 받을 데이터 변수 Map 형식으로 키 생성
              //     notifyDatas[c.uuid.toString()] = List.empty();
              //     c.value.listen((value) {
              //       // 데이터 읽기 처리!
              //       print('${c.uuid}: $value');

              //       // 받은 데이터 저장 화면 표시용
              //       notifyDatas[c.uuid.toString()] = value;
              //       print('this is notifyDatas : $notifyDatas');
              //     });

              //     // 설정 후 일정시간 지연
              //     await Future.delayed(const Duration(milliseconds: 500));
              //   } catch (e) {
              //     print('error ${c.uuid} $e');
              //   }
              // }
            }
          }
        }
        returnValue = Future.value(true);
      }
    });

    return returnValue ?? Future.value(false);
  }
}

final bluetooDevicesthViewModelProvider =
    AsyncNotifierProvider<BluetoothDevicesViewModel, BluetoothModel>(
  () => BluetoothDevicesViewModel(),
);
