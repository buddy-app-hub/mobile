import 'package:json_annotation/json_annotation.dart';
import 'phone_number.dart';

part 'loved_one.g.dart';

@JsonSerializable()
class LovedOne {
  final String firstName;
  final String lastName;
  final int age;
  final PhoneNumber phoneNumber;
  final String email;
  final String relationshipToElder;

  LovedOne({
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.phoneNumber,
    required this.email,
    required this.relationshipToElder,
  });

  factory LovedOne.fromJson(Map<String, dynamic> json) => _$LovedOneFromJson(json);
  Map<String, dynamic> toJson() => _$LovedOneToJson(this);
}
