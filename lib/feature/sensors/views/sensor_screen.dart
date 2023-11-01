import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jaljayo/constants/gaps.dart';
import 'package:jaljayo/feature/bluetooth/views/bluetooth.dart';
import 'package:jaljayo/feature/bluetooth/views/device_screen.dart';
import 'package:jaljayo/feature/sensors/widgets/acc_sensor_widget.dart';
import 'package:jaljayo/feature/sensors/widgets/hr_sensor_widget.dart';
import 'package:jaljayo/feature/sensors/widgets/oxygen_sensor_widget.dart';

class SensorScreen extends StatefulWidget {
  static String route = '/sensor';

  const SensorScreen({super.key});

  @override
  State<SensorScreen> createState() => _SensorScreenState();
}

class _SensorScreenState extends State<SensorScreen> {
  bool isClicked = false;

  FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
  List<ScanResult> scanResultList = [];
  bool _isScanning = false;

  @override
  initState() {
    super.initState();
    // 블루투스 초기화
    initBle();
  }

  void initBle() {
    // BLE 스캔 상태 얻기 위한 리스너
    flutterBlue.isScanning.listen((isScanning) {
      _isScanning = isScanning;
      setState(() {});
    });
  }

  /*
  스캔 시작/정지 함수
  */
  scan() async {
    if (!_isScanning) {
      // 스캔 중이 아니라면
      // 기존에 스캔된 리스트 삭제
      scanResultList.clear();
      // 스캔 시작, 제한 시간 4초
      flutterBlue.startScan(timeout: const Duration(seconds: 4));
      // 스캔 결과 리스너
      flutterBlue.scanResults.listen((results) {
        // UI 갱신
        setState(() {
          scanResultList = results;
        });
      });
    } else {
      // 스캔 중이라면 스캔 정지
      flutterBlue.stopScan();
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: IconButton(
              onPressed: () {
                setState(() {
                  isClicked = !isClicked;
                });
              },
              icon: const Icon(FontAwesomeIcons.bluetooth),
            ),
          ),
        ],
        backgroundColor: const Color(0xFF322D3F),
        elevation: 3,
        title: const Text(
          "Gae GGul Sleep",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      backgroundColor: const Color(0xffD3D3D3),
      body: isClicked
          ? GestureDetector(
              onTap: () {
                setState(() {
                  isClicked = !isClicked;
                });
              },
              child: Stack(
                children: [
                  const Center(
                    child: Text('not Clicked'),
                  ),
                  Container(
                    color: Colors.grey.withOpacity(0.8),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height / 2 - 300,
                    left: MediaQuery.of(context).size.width / 2 - 160,
                    child: Container(
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
                      height: 400,
                      width: 320,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Gaps.v12,
                          const Text(
                            '페어링 할 기기 선택',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Color(0xffFFFFFF)),
                          ),
                          SizedBox(
                            height: 300,
                            child: ListView.separated(
                              itemCount: scanResultList.length,
                              itemBuilder: (context, index) {
                                return listItem(scanResultList[index]);
                              },
                              separatorBuilder: (BuildContext context, index) {
                                return const Divider();
                              },
                            ),
                          ),
                          CupertinoButton(
                            onPressed: () {
                              scan();
                            },
                            child: _isScanning
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
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 400,
                    width: 550,
                    child: HrSensorWidget(),
                  ).animate().fadeIn(duration: 1.seconds),
                  //const Center(heightFactor: 10, child: Text("예쁘게 만들어주세요!")),
                  const SizedBox(
                    height: 230,
                    width: 310,
                    child: AccSensorWidget(),
                  ).animate().fadeIn(duration: 1.seconds),
                  Gaps.v32,
                  const SizedBox(
                    height: 220,
                    width: 310,
                    child: OxygenSensorWidget(),
                  ).animate().fadeIn(duration: 1.seconds),
                ],
              ),
            ),
    );
  }
}
