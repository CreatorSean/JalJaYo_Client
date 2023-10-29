import 'package:flutter/material.dart';
import 'package:jaljayo/constants/gaps.dart';

class OxygenSensorWidget extends StatefulWidget {
  const OxygenSensorWidget({Key? key}) : super(key: key);

  @override
  _OxygenSensorState createState() => _OxygenSensorState();
}

class _OxygenSensorState extends State<OxygenSensorWidget> {
  double _oxygenValue = 50.0; // 초기 산소 농도

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(
          top: 40,
          bottom: 20,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 4,
              blurRadius: 3,
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                "현재 산소 포화도", // 1자리 소수점까지 표시
                style: TextStyle(fontSize: 20.0),
              ),
              Gaps.v20,
              Text(
                "${_oxygenValue.toStringAsFixed(1)}%", // 1자리 소수점까지 표시
                style: const TextStyle(fontSize: 20.0),
              ),
              Slider(
                thumbColor: const Color(0xff322D3F),
                activeColor: const Color(0xffD3D3D3),
                inactiveColor: const Color(0xffEEEEEE),

                value: _oxygenValue,
                min: 0.0,
                max: 100.0,
                divisions: 100, // 슬라이더 분할 수
                onChanged: (double value) {
                  setState(() {
                    _oxygenValue = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
