class SleepDataModel {
  int modelName;
  String sleepDate;
  String startTime;
  String endTime;
  String sleepFile;
  SleepDataModel({
    required this.modelName,
    required this.sleepDate,
    required this.startTime,
    required this.endTime,
    required this.sleepFile,
  });

  SleepDataModel.fromJson(Map<String, dynamic> json)
      : modelName = json["modelName"],
        sleepDate = json["sleepDate"],
        startTime = json["startTime"],
        endTime = json["endTime"],
        sleepFile = json["sleepFile"];

  Map<String, dynamic> toMap() {
    return {
      "modelName": modelName,
      "sleepDate": sleepDate,
      "startTime": startTime,
      "endTime": endTime,
      "sleepFile": sleepFile,
    };
  }

  // String jsonString = await rootBundle.loadString('json/sleepdatas.json');
  // final jsonResponse = json.decode(jsonString);
}
