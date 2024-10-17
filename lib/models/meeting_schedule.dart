import 'package:json_annotation/json_annotation.dart';

part 'meeting_schedule.g.dart';

@JsonSerializable(explicitToJson: true)
class MeetingSchedule {
  final DateTime date;
  final int startHour;
  final int endHour;
  
  MeetingSchedule({
    required this.date,
    required this.startHour,
    required this.endHour,
  });

  factory MeetingSchedule.fromJson(Map<String, dynamic> json) => _$MeetingScheduleFromJson(json);
  Map<String, dynamic> toJson() => _$MeetingScheduleToJson(this);
}
