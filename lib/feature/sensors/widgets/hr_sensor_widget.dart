import 'dart:async';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jaljayo/constants/gaps.dart';
import 'package:jaljayo/constants/sizes.dart';

class HrSensorWidget extends StatefulWidget {
  const HrSensorWidget({
    super.key,
  });

  @override
  State<HrSensorWidget> createState() => _HrSensorWidgetState();
}

class _HrSensorWidgetState extends State<HrSensorWidget> {
  late final Timer _timer;
  final List<double> _hrData = List.filled(100, 0.0, growable: true);

  final double plotSmoothness = 0.5;
  final double plotWidth = 2;

  List<FlSpot> generateSpotData({List<double>? hrData}) {
    List<FlSpot> rtnSpots = [];

    if (hrData == null) {
      hrData = [];
      for (int i = 0; i < 100; i++) {
        hrData.add(Random().nextDouble() * 2 - 1.0);
      }
    }

    for (int i = 0; i < hrData.length; i++) {
      rtnSpots.add(FlSpot(i.toDouble(), hrData[i]));
    }

    return rtnSpots;
  }

  LineChartBarData buildLineChartBarData({
    required List<FlSpot> spots,
    required Color color,
  }) {
    return LineChartBarData(
      color: color,
      isStrokeJoinRound: true,
      barWidth: plotWidth,
      dotData: const FlDotData(
        show: false,
      ),
      isCurved: true,
      curveSmoothness: plotSmoothness,
      spots: spots,
    );
  }

  void initTimer() {
    _timer = Timer.periodic(
      1.seconds,
      (timer) {
        setState(() {
          _hrData.removeAt(0);
          _hrData.add(Random().nextDouble() * 50 + 50);
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    initTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25),
      child: Container(
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
        child: Stack(
          children: [
            Positioned(
              left: 5,
              right: 5,
              top: 20,
              bottom: 150,
              child: LineChart(
                duration: 0.ms,
                LineChartData(
                  clipData: const FlClipData.all(),
                  maxY: 120.0,
                  baselineY: 0,
                  minY: 0.0,
                  titlesData: const FlTitlesData(
                    show: true,
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: false,
                      ),
                    ),
                  ),
                  gridData: FlGridData(
                    horizontalInterval: 20,
                    getDrawingHorizontalLine: (value) {
                      return const FlLine(
                        color: Colors.grey,
                        strokeWidth: 0.5,
                      );
                    },
                  ),
                  lineBarsData: [
                    buildLineChartBarData(
                      spots: generateSpotData(hrData: _hrData),
                      color: Colors.redAccent,
                    ),
                  ],
                ),
              ),
            ),
            const Positioned(
              bottom: 50,
              right: 135,
              child: Text(
                "현재 심박수",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: Sizes.size18,
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              right: 130,
              child: Row(
                children: [
                  const Icon(FontAwesomeIcons.heartPulse).animate(
                    // 움직이는 아이콘
                    onComplete: (controller) {
                      controller.repeat(
                        reverse: true,
                        period: 200.ms,
                      );
                    },
                  ).scale(
                    begin: const Offset(1, 1),
                    end: const Offset(1.2, 1.2),
                    duration: 500.ms,
                    curve: Curves.easeInOut,
                  ),
                  Gaps.h10,
                  Text(
                    _hrData.last.round().toString(), // 실시간으로 변하는 현재 심박수
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: Sizes.size32,
                    ),
                  ),
                  Gaps.h5,
                  const Text("BPM"), // 단위 BPM
                ],
              ),
            ),
            const Positioned(
              bottom: 115,
              left: 45,
              child: Text(
                "수면중 평균 심박수",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: Sizes.size14,
                ),
              ),
            ),
            Positioned(
              bottom: 80,
              left: 70,
              child: Row(
                children: [
                  Text(
                    _hrData.last.round().toString(), // 수면중 평균 심박수 바꾸는 부분
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: Sizes.size24,
                    ),
                  ),
                  Gaps.h5,
                  const Text("BPM"),
                ],
              ),
            ),
            const Positioned(
              bottom: 115,
              right: 45,
              child: Text(
                "활동중 평균 심박수",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: Sizes.size14,
                ),
              ),
            ),
            Positioned(
              bottom: 80,
              right: 65,
              child: Row(
                children: [
                  Text(
                    _hrData.last.round().toString(), // 활동중 평균 심박수 바꾸는 부분
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: Sizes.size24,
                    ),
                  ),
                  Gaps.h5,
                  const Text("BPM"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
