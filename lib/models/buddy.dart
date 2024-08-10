import 'package:json_annotation/json_annotation.dart';
import 'package:mobile/models/personal_data.dart';
import 'phone_number.dart';
import 'identity_card.dart';
import 'bank_account.dart';
import 'buddy_profile.dart';

part 'buddy.g.dart';

@JsonSerializable(explicitToJson: true)
class Buddy {
  final String firebaseUID;
  final bool isBlocked;
  final bool isApprovedBuddy;
  final bool isApplicationToBeBuddyUnderReview;
  final String registrationMethod;
  final DateTime registrationDate;
  final bool isIdentityValidated;
  final PersonalData personalData;
  final String email;
  final PhoneNumber phoneNumber;
  final IdentityCard? identityCard;
  final BankAccount? bankAccount;
  final BuddyProfile? buddyProfile;

  Buddy({
    required this.firebaseUID,
    this.isBlocked = false,
    this.isApprovedBuddy = false,
    this.isApplicationToBeBuddyUnderReview = false,
    required this.registrationMethod,
    required this.registrationDate,
    this.isIdentityValidated = false,
    required this.personalData,
    required this.email,
    required this.phoneNumber,
    this.identityCard,
    this.bankAccount,
    this.buddyProfile,
  });

  factory Buddy.fromJson(Map<String, dynamic> json) => _$BuddyFromJson(json);
  Map<String, dynamic> toJson() => _$BuddyToJson(this);
}
