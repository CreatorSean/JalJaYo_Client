import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SleepLineChart extends StatefulWidget {
  const SleepLineChart({
    super.key,
  });

  @override
  State<SleepLineChart> createState() => _SleepLineChartState();
}

class _SleepLineChartState extends State<SleepLineChart> {
  final List<double> sleep_data = List.generate(
    30,
    (index) {
      if (index % 2 == 0) {
        return Random().nextDouble() * 10 + 45; // 45에서 55 사이의 난수 생성
      } else {
        return Random().nextDouble() * 10 + 20; // 20에서 30 사이의 난수 생성
      }
    },
  );

  final double plotSmoothness = 0.5;
  final double plotWidth = 2;

  List<FlSpot> generateSpotData({List<double>? accData}) {
    List<FlSpot> rtnSpots = [];

    if (accData == null) {
      accData = [];
      for (int i = 0; i < 100; i++) {
        accData.add(Random().nextDouble() * 2 - 1.0);
      }
    }

    for (int i = 0; i < accData.length; i++) {
      rtnSpots.add(FlSpot(i.toDouble(), accData[i]));
    }

    return rtnSpots;
  }

  LineChartBarData generateLineChartBarData({
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

  @override
  Widget build(BuildContext context) {
    return Container(
      child: LineChart(
        LineChartData(
            clipData: const FlClipData.all(),
            maxY: 60,
            minY: 0,
            baselineY: 0,
            titlesData: const FlTitlesData(
              show: true,
              topTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: false,
                ),
              ),
            ),
            // gridData: FlGridData(
            //   horizontalInterval: 1.0,
            //   getDrawingHorizontalLine: (value) {
            //     return const FlLine(
            //       color: Colors.grey,
            //       strokeWidth: 0.5,
            //     );
            //   },
            // ),
            lineBarsData: [
              generateLineChartBarData(
                spots: generateSpotData(accData: sleep_data),
                color: const Color(0xff2A2F4F),
              )
            ]),
      ),
    );
  }
}
