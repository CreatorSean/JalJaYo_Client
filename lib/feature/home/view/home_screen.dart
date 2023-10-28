import 'package:flutter/material.dart';
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
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(
        title: "Gae GGul Sleep",
      ),
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
