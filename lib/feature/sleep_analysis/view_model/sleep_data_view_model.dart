import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jaljayo/constants/constnats.dart';
import 'package:jaljayo/feature/sleep_analysis/model/sleep_data_model.dart';
import 'package:http/http.dart' as http;

class SleepDataViewModel extends AsyncNotifier<List<SleepDataModel>> {
  List<SleepDataModel> sleepList = [];
  List<String> dataList = ['apple', 'banana', 'Orange'];

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

  Future<void> sleepAnalysis() async {
    var url = "$baseUrl/sleepData";
    var headers = {'Content-Type': 'application/json'};
    var body = jsonEncode(dataList);

    try {
      var response =
          await http.post(Uri.parse(url), headers: headers, body: body);
      if (response.statusCode == 200) {
        print('데이터 전송 성공');
        print(response.body);
      } else {
        print('데이터 전송 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('데이터 전송 오류: $e');
    }
  }
}

final sleepDataViewModelProvider =
    AsyncNotifierProvider<SleepDataViewModel, List<SleepDataModel>>(
  () {
    return SleepDataViewModel();
  },
);
