import 'package:json_annotation/json_annotation.dart';
import 'interest.dart';
import 'time_of_day.dart';

part 'elder_profile.g.dart';

@JsonSerializable(explicitToJson: true)
class ElderProfile {
  String? description;
  List<Interest>? interests;
  List<TimeOfDay>? availability;
  List<String>? photos;

  ElderProfile({
    this.description,
    this.interests,
    this.availability,
    this.photos,
  });

  factory ElderProfile.fromJson(Map<String, dynamic> json) => _$ElderProfileFromJson(json);
  Map<String, dynamic> toJson() => _$ElderProfileToJson(this);
}
