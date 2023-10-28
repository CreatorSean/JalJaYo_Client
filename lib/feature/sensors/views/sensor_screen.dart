import 'package:flutter/material.dart';

class SensorScreen extends StatelessWidget {
  static String route = '/sensor';

  const SensorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Sensor'),
      ),
    );
  }
}
