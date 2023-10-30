import 'dart:io';

class SleepDataModel {
  String sleepDate;
  String startTime;
  String endTime;
  String sleepFile;
  SleepDataModel({
    required this.sleepDate,
    required this.startTime,
    required this.endTime,
    required this.sleepFile,
  });

  SleepDataModel.fromJson(Map<String, dynamic> json)
      : sleepDate = json["sleepDate"],
        startTime = json["startTime"],
        endTime = json["endTime"],
        sleepFile = json["sleepFile"];

  Map<String, dynamic> toMap() {
    return {
      "sleepDate": sleepDate,
      "startTime": startTime,
      "endTime": endTime,
      "sleepFile": sleepFile,
    };
  }

  // String jsonString = await rootBundle.loadString('json/sleepdatas.json');
  // final jsonResponse = json.decode(jsonString);
}
