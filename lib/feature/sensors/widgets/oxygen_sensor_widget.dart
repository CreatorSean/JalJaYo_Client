import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jaljayo/constants/gaps.dart';
import 'package:jaljayo/constants/sizes.dart';

class OxygenSensorWidget extends StatefulWidget {
  const OxygenSensorWidget({Key? key}) : super(key: key);

  @override
  _OxygenSensorState createState() => _OxygenSensorState();
}

class _OxygenSensorState extends State<OxygenSensorWidget> {
  double _oxygenValue = 95.0; // 초기 산소 농도
  late Timer _timer; // 타이머 변수

  @override
  void initState() {
    super.initState();
    startTimer(); // 타이머 시작
  }

  @override
  void dispose() {
    _timer.cancel(); // 타이머 취소
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        // 객체가 트리에 여전히 존재하는 경우에만 setState() 호출
        setState(() {
          // 난수 생성 및 값 업데이트
          final random = Random();
          _oxygenValue = random.nextInt(5) + 95;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffd3d3d3),
      body: Padding(
        padding: const EdgeInsets.only(
          bottom: 20,
          left: 25,
          right: 25,
        ),
        child: Container(
          height: 200,
          padding: const EdgeInsets.only(
            top: 30,
            bottom: 10,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: Sizes.size4,
                blurRadius: Sizes.size3,
              ),
            ],
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  "현재 산소포화도", // 소수점 이하 자리 없이 표시
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Gaps.v10,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(FontAwesomeIcons.hospital),
                    Gaps.h8,
                    Text(
                      "${_oxygenValue.toStringAsFixed(0)}%", // 소수점 이하 자리 없이 표시
                      style: const TextStyle(
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Gaps.v20,
                Expanded(
                  child: Slider(
                    thumbColor: const Color(0xff322D3F),
                    activeColor: const Color(0xffD3D3D3),
                    inactiveColor: const Color(0xffEEEEEE),
                    value: _oxygenValue,
                    min: 0.0, // 최소값 설정
                    max: 100.0, // 최대값 설정

                    onChanged: (double value) {},
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
