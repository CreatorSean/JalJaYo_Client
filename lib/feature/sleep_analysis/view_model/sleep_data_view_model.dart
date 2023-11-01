import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jaljayo/feature/sleep_analysis/model/sleep_data_model.dart';

class SleepDataViewModel extends AsyncNotifier<List<SleepDataModel>> {
  List<SleepDataModel> sleepList = [];

  Future<List<SleepDataModel>> loadSleepList() async {
    // JSON 파일 불러오기
    String jsonData =
        await rootBundle.loadString('assets/json/sleepdatas.json');

    // JSON 디코딩
    var data = json.decode(jsonData);

    // 데이터를 리스트로 변환
    List<dynamic> dataList = data['datas'] as List<dynamic>;

    // SleepData 객체로 변환하여 리스트에 저장
    for (var item in dataList) {
      SleepDataModel sleepData = SleepDataModel(
        modelName: item['modelName'],
        sleepDate: item['sleepDate'],
        startTime: item['startTime'],
        endTime: item['endTime'],
        sleepFile: item['sleepFile'],
      );
      sleepList.add(sleepData);
    }

    return sleepList;
  }

  @override
  FutureOr<List<SleepDataModel>> build() async {
    await loadSleepList();
    return sleepList;
  }
}

final sleepDataViewModelProvider =
    AsyncNotifierProvider<SleepDataViewModel, List<SleepDataModel>>(
  () {
    return SleepDataViewModel();
  },
);
