import 'package:json_annotation/json_annotation.dart';
import 'time_of_day.dart';
import 'meeting_location.dart';

part 'meeting.g.dart';

@JsonSerializable(explicitToJson: true)
class Meeting {
  final TimeOfDay date;
  final bool isCancelled;
  final bool isConfirmedByBuddy;
  final bool isConfirmedByElder;
  final bool isRescheduled;
  final String activity;
  final DateTime dateLastModification;

  @JsonKey(name: 'location')
  final MeetingLocation location;

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
