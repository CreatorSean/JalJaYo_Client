import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jaljayo/constants/gaps.dart';
import 'package:jaljayo/feature/bluetooth/view_model/bluetooth_devices_view_model.dart';
import 'package:jaljayo/feature/bluetooth/views/device_screen.dart';

class Bluetooth extends ConsumerStatefulWidget {
  const Bluetooth({super.key});

  @override
  ConsumerState<Bluetooth> createState() => _BluetoothState();
}

class _BluetoothState extends ConsumerState<Bluetooth> {
  FlutterBluePlus flutterBlue = FlutterBluePlus.instance;

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
    // 단순히 이름만 출력
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DeviceScreen(device: r.device)),
    );
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

  void onScan(WidgetRef ref) async {
    ref.read(bluetooDevicesthViewModelProvider.notifier).scanDevices();
  }

  @override
  Widget build(BuildContext context) {
    final displayWidth = MediaQuery.of(context).size.width;
    final displayHeight = MediaQuery.of(context).size.height;

    return Dialog(
      backgroundColor: Colors.transparent,
      clipBehavior: Clip.antiAlias,
      child: Container(
        height: displayHeight * 0.5,
        width: displayHeight * 0.8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: const Color(0xff322D3F),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Gaps.v12,
            const Text(
              '연결 할 기기 선택',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xffFFFFFF)),
            ),
            ref.watch(bluetooDevicesthViewModelProvider).when(
                  data: (scanResultList) {
                    return Expanded(
                      child: ListView.separated(
                        itemCount: scanResultList.length,
                        itemBuilder: (context, index) {
                          return listItem(scanResultList[index]);
                        },
                        separatorBuilder: (BuildContext context, index) {
                          return const Divider(
                            color: Colors.white24,
                          );
                        },
                      ),
                    );
                  },
                  loading: () => const Expanded(
                    child: Center(
                      child: CircularProgressIndicator.adaptive(),
                    ),
                  ),
                  error: (error, stackTrace) => const Center(
                    child: Text(
                      '에러 발생',
                      style: TextStyle(
                        color: Color(0xffffffff),
                      ),
                    ),
                  ),
                ),
            CupertinoButton(
              onPressed: () {
                onScan(ref);
              },
              child: false
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        color: Color(0xffffffff),
                      ),
                    )
                  : const Icon(
                      Icons.search,
                      size: 22,
                      color: Color(0xffffffff),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
