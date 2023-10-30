import 'dart:async';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jaljayo/constants/sizes.dart';

class HrSensorWidget extends StatefulWidget {
  const HrSensorWidget({
    Key? key,
  }) : super(key: key);

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
      const Duration(seconds: 1),
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
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: LineChart(
                  duration: const Duration(milliseconds: 0),
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
            ),
            const Padding(
              padding: EdgeInsets.only(top: 5),
              child: Text(
                "현재 심박수",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: Sizes.size18,
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 1, end: 1.2),
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                        builder: (context, value, child) {
                          return Transform.scale(
                            scale: value,
                            child: child,
                          );
                        },
                        child: const Icon(
                          FontAwesomeIcons.heartPulse,
                          size: Sizes.size32,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        _hrData.last.round().toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: Sizes.size32,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        "BPM",
                        style: TextStyle(
                          fontSize: Sizes.size18,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Column(
                      children: [
                        const Text(
                          "수면중 평균 심박수",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: Sizes.size14,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              _hrData.last.round().toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: Sizes.size24,
                              ),
                            ),
                            const Text("BPM"),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Column(
                      children: [
                        const Text(
                          "활동중 평균 심박수",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: Sizes.size14,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              _hrData.last.round().toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: Sizes.size24,
                              ),
                            ),
                            const Text("BPM"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
