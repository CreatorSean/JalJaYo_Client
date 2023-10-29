import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:jaljayo/feature/sensors/widgets/acc_sensor_widget.dart';

class SensorScreen extends StatelessWidget {
  static String route = '/sensor';

  const SensorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 300,
            child: AccSensorWidget(),
          ).animate().fadeIn(duration: 1.seconds),
        ],
      ),
    );
  }
}
