import 'package:provider/provider.dart';

class ScheduleModel {
  final String id;
  final String content;
  final DateTime date;
  final int startTime;
  final int endTime;
}

ScheduleModel({
  required this.id,
  required this.content,
  required this.date,
  required this.date,
  required this.startTime,
  required this.endTime,
});

ScheduleModel.fromJson({
  required Map<String, dynamic> json,
}) : id = json['id'],
content = json['content'],
date = DateTime.parse(json['date']),
StartTime = json['startTime'],
endTime = json['endTime'];

Map<String, dynamic> toJson() {
  return {
    'id' : id,
    'content' : content,
    'date' :
    '${date.year}${date.month.toString().padLeft(2, '0')}$
    {date.day.toString().padF}'
  }
}