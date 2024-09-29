import 'package:json_annotation/json_annotation.dart';
import 'package:mobile/models/connection_preferences.dart';
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
  List<Interest>? interests;
  List<TimeOfDay>? availability;
  List<String>? photos;
  int? globalRating; // Average rating of each of the meetings in which he participated (1 to 5)
  ConnectionPreferences connectionPreferences;

  BuddyProfile({
    this.isOnPause = false,
    this.description,
    this.studentDetails,
    this.workerDetails,
    this.interests,
    this.availability,
    this.photos,
    this.globalRating,
    required this.connectionPreferences
  });

  factory BuddyProfile.fromJson(Map<String, dynamic> json) => _$BuddyProfileFromJson(json);
  Map<String, dynamic> toJson() => _$BuddyProfileToJson(this);
}
