import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jaljayo/feature/bluetooth/views/bluetooth.dart';
import 'package:jaljayo/feature/sensors/widgets/acc_sensor_widget.dart';
import 'package:jaljayo/feature/sensors/widgets/hr_sensor_widget.dart';

class SensorScreen extends StatelessWidget {
  static String route = '/sensor';

  const SensorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: IconButton(
              onPressed: () => const Bluetooth(),
              icon: const Icon(FontAwesomeIcons.bluetooth),
            ),
          ),
        ],
        backgroundColor: const Color(0xff322D3F),
        elevation: 3,
        title: const Text(
          "Gae GGul Sleep",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      backgroundColor: const Color(0xffD3D3D3),
      body: Column(
        children: [
          const SizedBox(
            height: 150,
            child: HrSensorWidget(),
          ).animate().fadeIn(duration: 1.seconds),
          const Center(heightFactor: 10, child: Text("예쁘게 만들어주세요!")),
          const SizedBox(
            height: 300,
            child: AccSensorWidget(),
          ).animate().fadeIn(duration: 1.seconds),
        ],
      ),
    );
  }
}
