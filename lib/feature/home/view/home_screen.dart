import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:jaljayo/common/main_navigator_screen.dart';
import 'package:jaljayo/feature/sensors/views/sensor_screen.dart';
import 'package:jaljayo/feature/sleep_analysis/view/sleep_analysis_screen.dart';

const datas = [
  "2023년 10월 28일 수면 데이터 2023-10-27 23:16~2023-10-28 08:10",
  "2023년 10월 28일 수면 데이터 2023-10-27 23:16~2023-10-28 08:10",
  "2023년 10월 28일 수면 데이터 2023-10-27 23:16~2023-10-28 08:10",
  "2023년 10월 28일 수면 데이터 2023-10-27 23:16~2023-10-28 08:10",
  "2023년 10월 28일 수면 데이터 2023-10-27 23:16~2023-10-28 08:10",
  "2023년 10월 28일 수면 데이터 2023-10-27 23:16~2023-10-28 08:10",
  "2023년 10월 28일 수면 데이터 2023-10-27 23:16~2023-10-28 08:10",
  "2023년 10월 28일 수면 데이터 2023-10-27 23:16~2023-10-28 08:10",
  "2023년 10월 28일 수면 데이터 2023-10-27 23:16~2023-10-28 08:10",
  "2023년 10월 28일 수면 데이터 2023-10-27 23:16~2023-10-28 08:10",
  "2023년 10월 28일 수면 데이터 2023-10-27 23:16~2023-10-28 08:10",
  "2023년 10월 28일 수면 데이터 2023-10-27 23:16~2023-10-28 08:10",
  "2023년 10월 28일 수면 데이터 2023-10-27 23:16~2023-10-28 08:10",
  "2023년 10월 28일 수면 데이터 2023-10-27 23:16~2023-10-28 08:10",
];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
