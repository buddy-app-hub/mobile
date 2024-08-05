import 'package:json_annotation/json_annotation.dart';
import 'phone_number.dart';
import 'identity_card.dart';
import 'address.dart';
import 'elder_profile.dart';
import 'loved_one.dart';

part 'elder.g.dart';

@JsonSerializable(explicitToJson: true)
class Elder {
  final String firebaseUID;
  final bool isBlocked;
  final String registrationMethod;
  final DateTime registrationDate;
  final bool onLovedOneMode;
  final LovedOne? lovedOne;
  final String firstName;
  final String lastName;
  final int? age;
  final String gender;
  final DateTime? birthDate;
  final String? nationality;
  final String? maritalStatus;
  final String email;
  final PhoneNumber phoneNumber;
  final IdentityCard? identityCard;
  final Address? address;
  final ElderProfile? elderProfile;

  Elder({
    required this.firebaseUID,
    this.isBlocked = false,
    required this.registrationMethod,
    required this.registrationDate,
    required this.onLovedOneMode,
    this.lovedOne,
    required this.firstName,
    required this.lastName,
    this.age,
    required this.gender,
    this.birthDate,
    this.nationality,
    this.maritalStatus,
    required this.email,
    required this.phoneNumber,
    this.identityCard,
    this.address,
    this.elderProfile,
  });

  factory Elder.fromJson(Map<String, dynamic> json) => _$ElderFromJson(json);
  Map<String, dynamic> toJson() => _$ElderToJson(this);
}
