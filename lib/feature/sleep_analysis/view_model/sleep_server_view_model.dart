import 'dart:convert';

import 'package:http/http.dart' as http;

class SleepServerViewModel {
  Future<Map<String, dynamic>> sleepAnalysis(int modelNum) async {
    const url = "http://192.168.1.15:7700/api/sleep/data";
    final headers = {'Content-Type': 'text/plain'};
    final body = jsonEncode(modelNum);
    try {
      final response =
          await http.post(Uri.parse(url), headers: headers, body: body);

      if (response.statusCode == 200) {
        print('데이터 전송 성공');
        final data = json.decode(response.body) as Map<String, dynamic>;
        print(data);
        return data;
      } else {
        print('데이터 전송 실패: ${response.statusCode}');
        final data = json.decode(response.body) as Map<String, dynamic>;
        return data;
      }
    } catch (e) {
      print('데이터 전송 오류: $e');
      return {'데이터 전송 오류': e};
    }
  }
}
