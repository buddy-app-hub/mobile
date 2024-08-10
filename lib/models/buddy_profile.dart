import 'package:json_annotation/json_annotation.dart';
import 'student_details.dart';
import 'worker_details.dart';
import 'interest.dart';
import 'time_of_day.dart';

part 'buddy_profile.g.dart';

@JsonSerializable(explicitToJson: true)
class BuddyProfile {
  final bool isOnPause;
  String? description;
  final StudentDetails? studentDetails;
  final WorkerDetails? workerDetails;
  final List<Interest>? interests;
  final List<TimeOfDay>? availability;

  BuddyProfile({
    this.isOnPause = false,
    this.description,
    this.studentDetails,
    this.workerDetails,
    this.interests,
    this.availability,
  });

  factory BuddyProfile.fromJson(Map<String, dynamic> json) => _$BuddyProfileFromJson(json);
  Map<String, dynamic> toJson() => _$BuddyProfileToJson(this);
}
