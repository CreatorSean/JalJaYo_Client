import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jaljayo/feature/bluetooth/model/selected_device_model.dart';

class SelectedDeviceViewModel extends AsyncNotifier<SelectedDeviceModel> {
  SelectedDeviceModel model = SelectedDeviceModel();
  List<BluetoothService> bluetoothService = [];
  Map<String, List<int>> notifyDatas = {};
  StreamSubscription<BluetoothDeviceState>? _stateListener;
  bool reading = false;
  Timer timer = Timer.periodic(const Duration(seconds: 1), (timer) {});

  void select(BluetoothDevice device) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      if (model.device != null) {
        model.device!.disconnect();
        model.device = null;
        return model;
      }

      _stateListener = device.state.listen((event) {
        if (model.deviceState == event) {
          return;
        }
        setBleConnectionState(event);
      });
      model.device = device;

      return model;
    });

    if (model.device == null) {
      return;
    }

    connect();

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      readCharacteristic();
    });
  }

  void readCharacteristic() async {
    for (BluetoothService service in bluetoothService) {
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        if (characteristic.uuid ==
            Guid("2FB6A5AA-1219-4129-BC97-DD4DF70613CD")) {
          if (!reading) {
            reading = true;
            List<int> value = await characteristic.read();
            // convet value to string from byte array
            final str = String.fromCharCodes(value);

            debugPrint('read value: $str');
            reading = false;
          }
        }
      }
    }
  }

  /* 연결 상태 갱신 */
  void setBleConnectionState(BluetoothDeviceState event) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      switch (event) {
        case BluetoothDeviceState.disconnected:
          model.stateText = '연결 해제됨';
          // 버튼 상태 변경
          break;
        case BluetoothDeviceState.disconnecting:
          model.stateText = '연결 해제중';
          break;
        case BluetoothDeviceState.connected:
          model.stateText = '연결됨';
          // 버튼 상태 변경
          break;
        case BluetoothDeviceState.connecting:
          model.stateText = '연결중';
          break;
      }

      model.deviceState = event;

      return model;
    });
  }

  Future<bool> connect() async {
    Future<bool>? returnValue;

    setBleConnectionState(BluetoothDeviceState.connecting);

    await model.device!
        .connect(autoConnect: false)
        .timeout(const Duration(milliseconds: 15000), onTimeout: () {
      returnValue = Future.value(false);
      debugPrint('timeout failed');
      setBleConnectionState(BluetoothDeviceState.disconnected);
    }).then((data) async {
      bluetoothService.clear();
      if (returnValue == null) {
        //returnValue가 null이면 timeout이 발생한 것이 아니므로 연결 성공
        setBleConnectionState(BluetoothDeviceState.connected);
        debugPrint('connection successful');
        debugPrint('start discover service');
        List<BluetoothService> bleServices =
            await model.device!.discoverServices();

        bluetoothService = bleServices;

        returnValue = Future.value(true);
      }
    });

    return returnValue ?? Future.value(false);
  }

  void disconnect() {
    //timer.cancel();
    try {
      model.stateText = 'Disconnecting';
      if (model.device != null) {
        model.device!.disconnect();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  FutureOr<SelectedDeviceModel> build() {
    return model;
  }
}

final selectedDeviceViewModelProvider =
    AsyncNotifierProvider<SelectedDeviceViewModel, SelectedDeviceModel>(
  () => SelectedDeviceViewModel(),
);
