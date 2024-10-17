import 'package:json_annotation/json_annotation.dart';
import 'meeting.dart';

part 'connection.g.dart';

@JsonSerializable(explicitToJson: true)
class Connection {
  final String? id;
  final String elderID;
  final String buddyID;
  final DateTime creationDate;
  List<Meeting> meetings;

  Connection({
    this.id,
    required this.elderID,
    required this.buddyID,
    required this.creationDate,
    required this.meetings,
  });

  factory Connection.fromJson(Map<String, dynamic> json) => _$ConnectionFromJson(json);
  Map<String, dynamic> toJson() => _$ConnectionToJson(this);
}
