import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jaljayo/feature/bluetooth/view_model/bluetooth_devices_view_model.dart';

class BluetoothListTile extends ConsumerStatefulWidget {
  final ScanResult r;
  final int index;
  bool selected;

  BluetoothListTile({
    super.key,
    required this.r,
    required this.index,
    this.selected = false,
  });

  @override
  ConsumerState<BluetoothListTile> createState() => _BluetoothListTileState();
}

class _BluetoothListTileState extends ConsumerState<BluetoothListTile> {
  late final BluetoothDevice device;
  StreamSubscription<BluetoothDeviceState>? _stateListener;
  BluetoothDeviceState deviceState = BluetoothDeviceState.disconnected;
  String stateText = '연결중';
  String connectButtonText = 'Disconnect';

  @override
  void initState() {
    super.initState();

    device = widget.r.device;
    _stateListener = device.state.listen((event) {
      debugPrint('event :  $event');
      if (deviceState == event) {
        // 상태가 동일하다면 무시
        return;
      }
      // 연결 상태 정보 변경
      setBleConnectionState(event);
    });

    // 연결 시작
    //connect();
  }

  void disconnect() {
    try {
      setState(() {
        stateText = 'Disconnecting';
      });
      device.disconnect();
    } catch (e) {}
  }

  @override
  void dispose() {
    _stateListener?.cancel();
    disconnect();
    super.dispose();
  }

  /* 연결 상태 갱신 */
  setBleConnectionState(BluetoothDeviceState event) {
    switch (event) {
      case BluetoothDeviceState.disconnected:
        stateText = '연결 해제됨';
        // 버튼 상태 변경
        connectButtonText = 'Connect';
        break;
      case BluetoothDeviceState.disconnecting:
        stateText = '연결 해제중';
        break;
      case BluetoothDeviceState.connected:
        stateText = '연결됨';
        // 버튼 상태 변경
        connectButtonText = 'Disconnect';
        break;
      case BluetoothDeviceState.connecting:
        stateText = '연결중';
        break;
    }
    //이전 상태 이벤트 저장
    deviceState = event;
    setState(() {});
  }

  /*
   여기서부터는 장치별 출력용 함수들
  */
  /*  장치의 신호값 위젯  */
  Widget deviceSignal(ScanResult r) {
    return widget.selected
        ? Icon(
            deviceState == BluetoothDeviceState.connected
                ? Icons.check
                : Icons.cancel,
            color: deviceState == BluetoothDeviceState.connected
                ? Colors.greenAccent
                : Colors.grey,
          )
        : Text(
            r.rssi.toString(),
            style: const TextStyle(
              color: Colors.white,
            ),
          );
  }

  /* 장치의 MAC 주소 위젯  */
  Widget deviceMacAddress(ScanResult r) {
    return Text(
      widget.selected ? stateText : r.device.id.id,
      style: const TextStyle(
        color: Colors.white,
      ),
    );
  }

  /* 장치의 명 위젯  */
  Widget deviceName(ScanResult r) {
    String name = '';

    if (r.device.name.isNotEmpty) {
      // device.name에 값이 있다면
      name = r.device.name;
    } else if (r.advertisementData.localName.isNotEmpty) {
      // advertisementData.localName에 값이 있다면
      name = r.advertisementData.localName;
    } else {
      // 둘다 없다면 이름 알 수 없음...
      name = 'N/A';
    }
    return Text(
      name,
      style: const TextStyle(
        color: Colors.white,
      ),
    );
  }

  /* BLE 아이콘 위젯 */
  Widget leading(ScanResult r) {
    return CircleAvatar(
      backgroundColor: widget.selected ? Colors.blueAccent : Colors.grey,
      child: const Icon(
        Icons.bluetooth,
        color: Colors.white,
      ),
    );
  }

  /* 장치 아이템을 탭 했을때 호출 되는 함수 */
  void onTap(ScanResult r) {
    ref.read(bluetooDevicesthViewModelProvider.notifier).connectDevice(r);
  }

  /* 장치 아이템 위젯 */
  Widget listItem(ScanResult r) {
    return ListTile(
      onTap: () => onTap(r),
      leading: leading(r),
      title: deviceName(r),
      subtitle: deviceMacAddress(r),
      trailing: deviceSignal(r),
    );
  }

  @override
  Widget build(BuildContext context) {
    return listItem(widget.r)
        .animate()
        .then(
          delay: (widget.index * 50).ms,
        )
        .flipV(
          begin: -1,
          end: 0,
          duration: 500.ms,
          curve: Curves.easeOutCubic,
        )
        .fadeIn();
  }
}
