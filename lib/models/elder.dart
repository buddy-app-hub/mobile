import 'package:json_annotation/json_annotation.dart';
import 'package:mobile/models/personal_data.dart';
import 'phone_number.dart';
import 'identity_card.dart';
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
  final PersonalData personalData;
  final String email;
  final PhoneNumber phoneNumber;
  final IdentityCard? identityCard;
  final ElderProfile? elderProfile;

  Elder({
    required this.firebaseUID,
    this.isBlocked = false,
    required this.registrationMethod,
    required this.registrationDate,
    required this.onLovedOneMode,
    this.lovedOne,
    required this.personalData,
    required this.email,
    required this.phoneNumber,
    this.identityCard,
    this.elderProfile,
  });

  factory Elder.fromJson(Map<String, dynamic> json) => _$ElderFromJson(json);
  Map<String, dynamic> toJson() => _$ElderToJson(this);
}
