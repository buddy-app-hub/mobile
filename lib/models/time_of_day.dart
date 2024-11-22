import 'package:json_annotation/json_annotation.dart';

part 'time_of_day.g.dart';

@JsonSerializable(explicitToJson: true)
class TimeOfDay {
  String dayOfWeek;
  int from;
  int to;
  
  TimeOfDay({
    required this.dayOfWeek,
    required this.from,
    required this.to,
  });

  factory TimeOfDay.fromJson(Map<String, dynamic> json) => _$TimeOfDayFromJson(json);
  Map<String, dynamic> toJson() => _$TimeOfDayToJson(this);
}
