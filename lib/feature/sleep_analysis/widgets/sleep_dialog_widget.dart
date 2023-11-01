import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jaljayo/constants/gaps.dart';
import 'package:jaljayo/feature/sleep_analysis/model/sleep_data_model.dart';
import 'package:jaljayo/feature/sleep_analysis/view/sleep_state_screen.dart';
import 'package:http/http.dart' as http;

class SleepDialogWidget {
  late BuildContext context;
  late SleepDataModel sleep;

  Future<void> sleepAnalysis() async {
    var url = "http://192.168.1.38:7700/sleep/data";
    var headers = {'Content-Type': 'text/plain'};
    var body = jsonEncode(sleep.modelName);

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

  void _onSleepStateTap(BuildContext context, SleepDataModel sleep) {
    Navigator.of(context).pop();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SleepStateScreen(
          sleepDate: sleep.sleepDate,
        ),
      ),
    );
  }

  Future sleepDialog(BuildContext context, SleepDataModel sleep) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xff322D3F),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          content: Container(
            decoration: const BoxDecoration(
              color: Color(0xff322D3F),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Gaps.v32,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    '${sleep.sleepDate} 수면 데이터를 분석하시겠습니까?',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 100,
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => _onSleepStateTap(context, sleep),
                      child: Container(
                        height: 40,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.white,
                        ),
                        child: const Stack(
                          alignment: Alignment.center,
                          children: [
                            Text(
                              '확인',
                              style: TextStyle(
                                color: Color(0xff322D3F),
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        height: 40,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.white,
                        ),
                        child: const Stack(
                          alignment: Alignment.center,
                          children: [
                            Text(
                              '취소',
                              style: TextStyle(
                                color: Color(0xff322D3F),
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 25,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
