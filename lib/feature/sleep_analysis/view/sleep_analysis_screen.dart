import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jaljayo/constants/gaps.dart';
import 'package:jaljayo/constants/sizes.dart';
import 'package:jaljayo/feature/bluetooth/views/device_screen.dart';
import 'package:jaljayo/feature/sleep_analysis/model/sleep_data_model.dart';
import 'package:jaljayo/feature/sleep_analysis/view/sleep_state_screen.dart';
import 'package:jaljayo/feature/sleep_analysis/view_model/sleep_data_view_model.dart';

const datas = [
  "2023년 10월 28일 수면 데이터 2023-10-27 23:16~2023-10-28 08:10",
  "2023년 10월 28일 수면 데이터 2023-10-27 23:16~2023-10-28 08:10",
  "2023년 10월 28일 수면 데이터 2023-10-27 23:16~2023-10-28 08:10",
  "2023년 10월 28일 수면 데이터 2023-10-27 23:16~2023-10-28 08:10",
  "2023년 10월 28일 수면 데이터 2023-10-27 23:16~2023-10-28 08:10",
  "2023년 10월 28일 수면 데이터 2023-10-27 23:16~2023-10-28 08:10",
  "2023년 10월 28일 수면 데이터 2023-10-27 23:16~2023-10-28 08:10",
  "2023년 10월 28일 수면 데이터 2023-10-27 23:16~2023-10-28 08:10",
  "2023년 10월 28일 수면 데이터 2023-10-27 23:16~2023-10-28 08:10",
  "2023년 10월 28일 수면 데이터 2023-10-27 23:16~2023-10-28 08:10",
  "2023년 10월 28일 수면 데이터 2023-10-27 23:16~2023-10-28 08:10",
  "2023년 10월 28일 수면 데이터 2023-10-27 23:16~2023-10-28 08:10",
  "2023년 10월 28일 수면 데이터 2023-10-27 23:16~2023-10-28 08:10",
  "2023년 10월 28일 수면 데이터 2023-10-27 23:16~2023-10-28 08:10",
];

class SleepAnalysisScreen extends ConsumerStatefulWidget {
  const SleepAnalysisScreen({super.key});

  @override
  ConsumerState<SleepAnalysisScreen> createState() =>
      _SleepAnalysisScreenState();
}

class _SleepAnalysisScreenState extends ConsumerState<SleepAnalysisScreen> {
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

  Future<void> uploadCSVToServer(File csvFile) async {
    var dio = Dio();
    var uri = 'http://서버주소/upload';
    var formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(csvFile.path),
    });

    try {
      var response = await dio.post(uri, data: formData);
      print('CSV 파일 업로드 성공');
      print('Response: ${response.data}');
    } catch (error) {
      print('CSV 파일 업로드 실패: $error');
    }
  }

  void _onSleepStateTap(BuildContext context, SleepDataModel sleep) {
    Navigator.of(context).pop();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SleepStateScreen(
          sleepDate: sleep.sleepDate,
        ),
      ),
    );
  }

  Future _sleepDialog(BuildContext context, SleepDataModel sleep) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xff322D3F),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          content: Container(
            decoration: const BoxDecoration(
              color: Color(0xff322D3F),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Gaps.v32,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    '${sleep.sleepDate} 수면 데이터를 분석하시겠습니까?',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 100,
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => _onSleepStateTap(context, sleep),
                      child: Container(
                        height: 40,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.white,
                        ),
                        child: const Stack(
                          alignment: Alignment.center,
                          children: [
                            Text(
                              '확인',
                              style: TextStyle(
                                color: Color(0xff322D3F),
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        height: 40,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.white,
                        ),
                        child: const Stack(
                          alignment: Alignment.center,
                          children: [
                            Text(
                              '취소',
                              style: TextStyle(
                                color: Color(0xff322D3F),
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 25,
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget dataItem(SleepDataModel sleep) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 12.0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 0.5,
            blurRadius: 7,
            offset: const Offset(0, 10),
          ),
        ],
        color: Colors.white,
      ),
      child: ListTile(
        onTap: () {
          _sleepDialog(context, sleep);
        },
        title: Text(sleep.sleepDate),
        titleAlignment: ListTileTitleAlignment.center,
        subtitle: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              '시작 시간 : ${sleep.startTime}',
              style: const TextStyle(
                fontSize: Sizes.size12,
              ),
            ),
            Text(
              '종료 시간 : ${sleep.endTime}',
              style: const TextStyle(
                fontSize: Sizes.size12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(sleepDataViewModelProvider).when(
      data: (sleepList) {
        return Scaffold(
          backgroundColor: const Color(0xFFD3D3D3),
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
                                  separatorBuilder:
                                      (BuildContext context, index) {
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
              : Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: ListView.separated(
                      itemCount: sleepList.length,
                      itemBuilder: (context, index) {
                        return dataItem(sleepList[index]);
                      },
                      separatorBuilder: (context, index) {
                        return const Divider();
                      },
                    ),
                  ),
                ),
        );
      },
      loading: () {
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
          body: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
      error: (error, stackTrace) {
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
          body: const Center(
            child: Text("error"),
          ),
        );
      },
    );
  }
}
