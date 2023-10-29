import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:jaljayo/common/main_app_bar.dart';
import 'package:jaljayo/common/main_navigator_screen.dart';

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

  Widget dataItem(String r) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 12.0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
      ),
      child: ListTile(
        title: Text(r),
        titleAlignment: ListTileTitleAlignment.center,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(
        title: "Gae GGul Sleep",
      ),
      backgroundColor: const Color(0xFFd3d3d3),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
            child: ListView.separated(
          itemCount: datas.length,
          itemBuilder: (context, index) {
            return dataItem(datas[index]);
          },
          separatorBuilder: (context, index) {
            return const Divider();
          },
        )),
      ),
      bottomNavigationBar: MainNavigator(
        page: _currentPage,
        changeFunc: changePage,
      ),
    );
  }
}
