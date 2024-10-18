import 'package:json_annotation/json_annotation.dart';
import 'package:mobile/models/meeting_schedule.dart';
import 'package:mobile/models/review.dart';
import 'meeting_location.dart';

part 'meeting.g.dart';

@JsonSerializable(explicitToJson: true)
class Meeting {
  String? meetingID;
  bool isCancelled;
  bool isConfirmedByBuddy;
  bool isConfirmedByElder;
  bool isRescheduled;
  bool isPaymentPending;
  String activity;
  DateTime dateLastModification;
  Review? elderRatingForBuddy; // Review that Elder made to Buddy
  Review? buddyRatingForElder; // Review that Buddy made to Elder

  @JsonKey(name: 'location')
  MeetingLocation location;

  @JsonKey(name: 'schedule')
  MeetingSchedule schedule;

  Meeting({
    this.meetingID,
    required this.schedule,
    required this.location,
    this.isCancelled = false,
    this.isConfirmedByBuddy = false,
    this.isConfirmedByElder = false,
    this.isRescheduled = false,
    this.isPaymentPending = false,
    required this.activity,
    required this.dateLastModification,
    this.elderRatingForBuddy,
    this.buddyRatingForElder,
  });

  factory Meeting.fromJson(Map<String, dynamic> json) =>
      _$MeetingFromJson(json);
  Map<String, dynamic> toJson() => _$MeetingToJson(this);
}
