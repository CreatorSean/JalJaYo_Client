import 'package:flutter/material.dart';

class SleepAnalysisScreen extends StatefulWidget {
  const SleepAnalysisScreen({super.key});

  @override
  State<SleepAnalysisScreen> createState() => _SleepAnalysisScreenState();
}

class _SleepAnalysisScreenState extends State<SleepAnalysisScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Center(
        child: Text('Sleep Analysis'),
      ),
    );
  }
}
