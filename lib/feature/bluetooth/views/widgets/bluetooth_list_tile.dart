import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jaljayo/feature/bluetooth/view_model/bluetooth_devices_view_model.dart';

class BluetoothListTile extends ConsumerStatefulWidget {
  final ScanResult r;
  final int index;

  const BluetoothListTile({
    super.key,
    required this.r,
    required this.index,
  });

  @override
  ConsumerState<BluetoothListTile> createState() => _BluetoothListTileState();
}

class _BluetoothListTileState extends ConsumerState<BluetoothListTile> {
  /*
   여기서부터는 장치별 출력용 함수들
  */
  /*  장치의 신호값 위젯  */
  Widget deviceSignal(ScanResult r) {
    return Text(
      r.rssi.toString(),
      style: const TextStyle(
        color: Colors.white,
      ),
    );
  }

  /* 장치의 MAC 주소 위젯  */
  Widget deviceMacAddress(ScanResult r) {
    return Text(
      r.device.id.id,
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
    return const CircleAvatar(
      backgroundColor: Colors.cyan,
      child: Icon(
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
