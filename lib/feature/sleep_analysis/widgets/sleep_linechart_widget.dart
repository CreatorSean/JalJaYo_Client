import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SleepLineChart extends StatefulWidget {
  List<dynamic> sleepStateData;
  SleepLineChart({
    required this.sleepStateData,
    super.key,
  });

  @override
  State<SleepLineChart> createState() => _SleepLineChartState();
}

class _SleepLineChartState extends State<SleepLineChart> {
  final double plotSmoothness = 0.5;
  final double plotWidth = 2;

  List<FlSpot> generateSpotData({List<dynamic>? accData}) {
    List<FlSpot> rtnSpots = [];

    if (accData == null) {
      accData = [];
      for (int i = 0; i < 100; i++) {
        accData.add(Random().nextDouble() * 2 - 1.0);
      }
    }

    for (int i = 0; i < accData.length; i++) {
      if (accData[i] == 0.0) {
        accData[i] = 40.0;
      } else {
        accData[i] = 20.0;
      }
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
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: 2050,
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
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false)),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false)),
                         
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
                    spots: generateSpotData(accData: widget.sleepStateData),
                    color: const Color(0xff2A2F4F),
                  )
                ]),
          ),
        ),
      ),
    );
  }
}
