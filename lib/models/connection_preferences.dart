import 'package:json_annotation/json_annotation.dart';

part 'connection_preferences.g.dart';

@JsonSerializable(explicitToJson: true)
class ConnectionPreferences {
  int maxDistanceKM = 10;

  ConnectionPreferences({
    required this.maxDistanceKM
  });

  factory ConnectionPreferences.fromJson(Map<String, dynamic> json) => _$ConnectionPreferencesFromJson(json);
  Map<String, dynamic> toJson() => _$ConnectionPreferencesToJson(this);
}
