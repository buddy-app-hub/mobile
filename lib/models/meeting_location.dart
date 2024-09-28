import 'package:json_annotation/json_annotation.dart';

part 'meeting_location.g.dart';

@JsonSerializable(explicitToJson: true)
class MeetingLocation {
  bool isEldersHome;
  String placeName;
  String streetName;
  int streetNumber;
  String city;
  String state;
  String country;

  MeetingLocation({
    required this.isEldersHome,
    required this.placeName,
    required this.streetName,
    required this.streetNumber,
    required this.city,
    required this.state,
    required this.country,
  });

  factory MeetingLocation.fromJson(Map<String, dynamic> json) => _$MeetingLocationFromJson(json);
  Map<String, dynamic> toJson() => _$MeetingLocationToJson(this);
}
