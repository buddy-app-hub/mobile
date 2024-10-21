import 'package:json_annotation/json_annotation.dart';
import 'package:mobile/models/address.dart';

part 'personal_data.g.dart';

@JsonSerializable(explicitToJson: true)
class PersonalData {
  final String firstName;
  final String lastName;
  final int? age;
  final String gender;
  final DateTime? birthDate;
  final String? nationality;
  final String? maritalStatus;
  Address? address;

  PersonalData({
    required this.firstName,
    required this.lastName,
    this.age,
    required this.gender,
    this.birthDate,
    this.nationality,
    this.maritalStatus,
    this.address,
  });

  factory PersonalData.fromJson(Map<String, dynamic> json) =>
      _$PersonalDataFromJson(json);
  Map<String, dynamic> toJson() => _$PersonalDataToJson(this);
}
