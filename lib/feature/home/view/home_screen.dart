import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:jaljayo/common/main_app_bar.dart';
import 'package:jaljayo/common/main_navigator_screen.dart';
import 'package:jaljayo/feature/sensors/views/sensor_screen.dart';
import 'package:jaljayo/feature/sleep_analysis/view/sleep_analysis_screen.dart';

class HomeScreen extends StatefulWidget {
  static String route = '/';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  void changePage(int index) {
    _currentPage = index;

    _pageController.animateToPage(
      index,
      duration: 300.ms,
      curve: Curves.linear,
    );

    setState(() {});
  }

  String getTitle(int pageIdx) {
    return pageIdx == 0 ? "Sleep Analysis" : "Sensor Data";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        title: getTitle(_currentPage),
      ),
      backgroundColor: const Color(0xFFd3d3d3),
      body: PageView(
        controller: _pageController,
        onPageChanged: changePage,
        children: const [
          SleepAnalysisScreen(),
          SensorScreen(),
        ],
      ),
      bottomNavigationBar: MainNavigator(
        page: _currentPage,
        changeFunc: changePage,
      ),
    );
  }
}
