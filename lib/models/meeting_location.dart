import 'package:json_annotation/json_annotation.dart';

part 'meeting_location.g.dart';

@JsonSerializable()
class MeetingLocation {
  final bool isEldersHome;
  final String placeName;
  final String streetName;
  final int streetNumber;
  final String city;
  final String state;
  final String country;

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
