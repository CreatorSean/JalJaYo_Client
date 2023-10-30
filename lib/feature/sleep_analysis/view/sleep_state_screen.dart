import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jaljayo/constants/gaps.dart';
import 'package:jaljayo/constants/sizes.dart';
import 'package:jaljayo/feature/sleep_analysis/widgets/sleep_piechart_widget.dart';

class SleepStateScreen extends StatelessWidget {
  String sleepDate;
  SleepStateScreen({
    super.key,
    required this.sleepDate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(FontAwesomeIcons.bluetooth),
            ),
          ),
        ],
        backgroundColor: const Color(0xFF322D3F),
        elevation: 3,
        title: const Text(
          "Gae GGul Sleep",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Gaps.v16,
            const Padding(
              padding: EdgeInsets.only(left: 12.0),
              child: Text(
                '총 수면시간',
                style: TextStyle(
                  color: Color(0xFF322D3F),
                  fontSize: Sizes.size24,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Gaps.v24,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    const Text(
                      '7H 4M',
                      style: TextStyle(
                        color: Color(0xff322d3f),
                        fontSize: Sizes.size20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Gaps.v16,
                    Text(
                      sleepDate,
                      style: const TextStyle(
                        color: Color(0xff322d3f),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                )
              ],
            ),
            Gaps.v28,
            Container(
              width: 300,
              height: 320,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: const Color(0xffeeeeee),
              ),
              child: const Column(
                children: [
                  Gaps.v24,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Gaps.h28,
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 6,
                            backgroundColor: Color(0xff2E4374),
                          ),
                          Gaps.h8,
                          Text(
                            '실제 수면 시간',
                            style: TextStyle(
                              fontSize: Sizes.size10,
                            ),
                          ),
                        ],
                      ),
                      Gaps.h20,
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 6,
                            backgroundColor: Color(0xff707070),
                          ),
                          Gaps.h8,
                          Text(
                            '수면 중 깬 시간',
                            style: TextStyle(
                              fontSize: Sizes.size10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Gaps.v24,
            const Row(
              children: [
                Gaps.h40,
                CircleAvatar(
                  radius: 10,
                  backgroundColor: Color(0xFF322D3F),
                ),
                Gaps.h10,
                Text(
                  '수면 기록',
                  style: TextStyle(
                    fontSize: Sizes.size16,
                    color: Color(0xFF322D3F),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Gaps.h8,
                Icon(
                  FontAwesomeIcons.bed,
                  color: Color(0xFF322D3F),
                ),
              ],
            ),
            Gaps.v24,
            SizedBox(
              width: 300,
              height: 320,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '취침 시간',
                        style: TextStyle(
                          color: Color(0xFF322D3F),
                          fontSize: Sizes.size12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        '오전 02:30',
                        style: TextStyle(
                          color: Color(0xFF322D3F),
                          fontSize: Sizes.size24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '기상 시간',
                        style: TextStyle(
                          color: Color(0xFF322D3F),
                          fontSize: Sizes.size12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        '오전 07:25',
                        style: TextStyle(
                          color: Color(0xFF322D3F),
                          fontSize: Sizes.size24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: CustomPaint(
                          // CustomPaint를 그리고 이 안에 차트를 그려줍니다..
                          size: const Size(
                              80, 80), // CustomPaint의 크기는 가로 세로 150, 150으로 합니다.
                          painter: SleepPieChartWidget(
                            percentage: 75,
                            textScaleFactor: 1.0,
                            textColor: '0xFF322D3F',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
