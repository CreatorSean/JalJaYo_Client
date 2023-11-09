import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:jaljayo/constants/gaps.dart';
import 'package:jaljayo/feature/sensors/widgets/acc_sensor_widget.dart';
import 'package:jaljayo/feature/sensors/widgets/hr_sensor_widget.dart';
import 'package:jaljayo/feature/sensors/widgets/oxygen_sensor_widget.dart';

class SensorScreen extends StatelessWidget {
  static String routeURL = '/sensor';
  static String routeName = 'sensors';

  const SensorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffD3D3D3),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 400,
              child: HrSensorWidget(),
            ).animate().fadeIn(duration: 1.seconds),
            const SizedBox(
              height: 230,
              width: 360,
              child: AccSensorWidget(),
            ).animate().fadeIn(duration: 1.seconds),
            Gaps.v32,
            const SizedBox(
              height: 220,
              width: 360,
              child: OxygenSensorWidget(),
            ).animate().fadeIn(duration: 1.seconds),
          ],
        ),
      ),
    );
  }
}
