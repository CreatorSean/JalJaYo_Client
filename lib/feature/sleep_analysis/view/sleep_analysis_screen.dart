import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jaljayo/constants/sizes.dart';
import 'package:jaljayo/feature/sleep_analysis/model/sleep_data_model.dart';
import 'package:jaljayo/feature/sleep_analysis/view_model/sleep_data_view_model.dart';
import 'package:jaljayo/feature/sleep_analysis/widgets/sleep_dialog_widget.dart';

class SleepAnalysisScreen extends ConsumerStatefulWidget {
  const SleepAnalysisScreen({super.key});

  @override
  ConsumerState<SleepAnalysisScreen> createState() =>
      _SleepAnalysisScreenState();
}

class _SleepAnalysisScreenState extends ConsumerState<SleepAnalysisScreen> {
  bool isClicked = false;
  FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
  List<ScanResult> scanResultList = [];

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD3D3D3),
      body: ref.watch(sleepDataViewModelProvider).when(
        data: (sleepList) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: ListView.separated(
                itemCount: sleepList.length,
                itemBuilder: (context, index) {
                  return dataItem(
                    index,
                    context,
                    sleepList[index],
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider();
                },
              ),
            ),
          );
        },
        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
        error: (error, stackTrace) {
          return Center(
            child: Text(
              error.toString(),
              style: const TextStyle(
                fontSize: Sizes.size16,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
      ),
    );
  }
}

Widget dataItem(int idx, BuildContext context, SleepDataModel sleep) {
  return Container(
    padding: const EdgeInsets.symmetric(
      horizontal: 8.0,
      vertical: 12.0,
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          spreadRadius: 0.5,
          blurRadius: 7,
          offset: const Offset(0, 10),
        ),
      ],
      color: Colors.white,
    ),
    child: ListTile(
      onTap: () {
        SleepDialogWidget().sleepDialog(context, sleep);
      },
      title: Text(sleep.sleepDate),
      titleAlignment: ListTileTitleAlignment.center,
      subtitle: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            '시작 시간 : ${sleep.startTime}',
            style: const TextStyle(
              fontSize: Sizes.size12,
            ),
          ),
          Text(
            '종료 시간 : ${sleep.endTime}',
            style: const TextStyle(
              fontSize: Sizes.size12,
            ),
          ),
        ],
      ),
    ),
  )
      .animate()
      .then(delay: (idx * 50).ms)
      .fadeIn(
        duration: 300.ms,
        curve: Curves.easeInOut,
      )
      .flipV(
        begin: -0.25,
        end: 0,
        duration: 300.ms,
        curve: Curves.easeInOut,
      );
}
