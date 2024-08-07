import 'package:json_annotation/json_annotation.dart';
import 'interest.dart';
import 'time_of_day.dart';

part 'elder_profile.g.dart';

@JsonSerializable(explicitToJson: true)
class ElderProfile {
  final String description;
  final List<Interest> interests;
  final List<TimeOfDay> availability;

  ElderProfile({
    required this.description,
    required this.interests,
    required this.availability,
  });

  factory ElderProfile.fromJson(Map<String, dynamic> json) => _$ElderProfileFromJson(json);
  Map<String, dynamic> toJson() => _$ElderProfileToJson(this);
}
