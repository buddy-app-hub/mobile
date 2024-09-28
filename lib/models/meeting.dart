import 'package:json_annotation/json_annotation.dart';
import 'time_of_day.dart';
import 'meeting_location.dart';

part 'meeting.g.dart';

@JsonSerializable(explicitToJson: true)
class Meeting {
  TimeOfDay date;
  bool isCancelled;
  bool isConfirmedByBuddy;
  bool isConfirmedByElder;
  bool isRescheduled;
  String activity;
  DateTime dateLastModification;

  @JsonKey(name: 'location')
  MeetingLocation location;

  Meeting({
    required this.date,
    required this.location,
    this.isCancelled = false,
    this.isConfirmedByBuddy = false,
    this.isConfirmedByElder = false,
    this.isRescheduled = false,
    required this.activity,
    required this.dateLastModification,
  });

  factory Meeting.fromJson(Map<String, dynamic> json) => _$MeetingFromJson(json);
  Map<String, dynamic> toJson() => _$MeetingToJson(this);
}
