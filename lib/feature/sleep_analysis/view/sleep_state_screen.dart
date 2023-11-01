import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jaljayo/common/main_app_bar.dart';
import 'package:jaljayo/constants/gaps.dart';
import 'package:jaljayo/constants/sizes.dart';
import 'package:jaljayo/feature/sleep_analysis/model/sleep_data_model.dart';
import 'package:jaljayo/feature/sleep_analysis/view_model/sleep_server_view_model.dart';
import 'package:jaljayo/feature/sleep_analysis/widgets/sleep_linechart_widget.dart';
import 'package:jaljayo/feature/sleep_analysis/widgets/sleep_piechart_widget.dart';

class SleepStateScreen extends StatefulWidget {
  final SleepDataModel sleep;
  const SleepStateScreen({
    super.key,
    required this.sleep,
  });

  @override
  State<SleepStateScreen> createState() => _SleepStateScreenState();
}

class _SleepStateScreenState extends State<SleepStateScreen> {
  late Future<Map<String, dynamic>> sleepAnalysisData;

  @override
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: SleepServerViewModel().sleepAnalysis(widget.sleep.modelName),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!;

          final String sleepTSTHour = data['tst_hour'].toString();
          final String sleepTSTMinu = data['tst_minute'].toString();
          final String sleepWASOMin = data['waso_minute'].toString();
          final int sleepTSTHourInt = data['tst_hour'];
          final int totalSleepMin = data['tst_minute'] + data['waso_minute'];
          final int extrasleepHr = totalSleepMin ~/ 60;
          final int extrasleepMin = totalSleepMin % 60;
          final int totalsleepHr = extrasleepHr + sleepTSTHourInt;
          final String totalsleepHorstr = totalsleepHr.toString();
          final String extrasleepMinStr = extrasleepMin.toString();
          print(totalsleepHorstr);
          print(extrasleepMinStr);
          final int sleepSE = data['se: '] ~/ 1;

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
                          Text(
                            '${totalsleepHorstr}H ${extrasleepMinStr}M',
                            style: const TextStyle(
                              color: Color(0xff322d3f),
                              fontSize: Sizes.size20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Gaps.v16,
                          Text(
                            widget.sleep.sleepDate,
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
                    height: 300,
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
                        Gaps.v16,
                        SizedBox(
                          height: 200,
                          width: 400,
                          child: SleepLineChart(),
                        )
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
                  SizedBox(
                    width: 300,
                    height: 150,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '순수 수면 시간',
                              style: TextStyle(
                                color: Color(0xFF322D3F),
                                fontSize: Sizes.size12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              '${sleepTSTHour}H ${sleepTSTMinu}M',
                              style: const TextStyle(
                                color: Color(0xFF322D3F),
                                fontSize: Sizes.size24,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Text(
                              '깬 시간',
                              style: TextStyle(
                                color: Color(0xFF322D3F),
                                fontSize: Sizes.size12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              '${sleepWASOMin}M',
                              style: const TextStyle(
                                color: Color(0xFF322D3F),
                                fontSize: Sizes.size24,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: CustomPaint(
                                // CustomPaint를 그리고 이 안에 차트를 그려줍니다..
                                size: const Size(80,
                                    80), // CustomPaint의 크기는 가로 세로 80, 80 합니다.
                                painter: SleepPieChartWidget(
                                  percentage: sleepSE,
                                  textScaleFactor: 1.0,
                                  textColor: '0xFF322D3F',
                                ),
                              ),
                            ),
                            Gaps.v5,
                            const Text(
                              '수면 효율',
                              style: TextStyle(
                                  color: Color(0xFF322D3F),
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return const Text('error');
        }
        return const Scaffold(
          appBar: MainAppBar(
            title: 'SleepState',
          ),
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
