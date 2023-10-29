import 'dart:async';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jaljayo/constants/gaps.dart';

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
      padding: const EdgeInsets.only(top: 20),
      child: Stack(
        children: [
          LineChart(
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
          Positioned(
            bottom: 40,
            right: 60,
            child: Row(
              children: [
                const Icon(FontAwesomeIcons.heart).animate(
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
                Text(_hrData.last.round().toString())
              ],
            ),
          ),
        ],
      ),
    );
  }
}
