// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buddy.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Buddy _$BuddyFromJson(Map<String, dynamic> json) => Buddy(
      firebaseUID: json['firebaseUID'] as String,
      isBlocked: json['isBlocked'] as bool? ?? false,
      isApprovedBuddy: json['isApprovedBuddy'] as bool? ?? false,
      isApplicationToBeBuddyUnderReview:
          json['isApplicationToBeBuddyUnderReview'] as bool? ?? false,
      registrationMethod: json['registrationMethod'] as String,
      registrationDate: DateTime.parse(json['registrationDate'] as String),
      isIdentityValidated: json['isIdentityValidated'] as bool? ?? false,
      personalData:
          PersonalData.fromJson(json['personalData'] as Map<String, dynamic>),
      email: json['email'] as String,
      walletId: json['walletId'] as String?,
      phoneNumber:
          PhoneNumber.fromJson(json['phoneNumber'] as Map<String, dynamic>),
      identityCard: json['identityCard'] == null
          ? null
          : IdentityCard.fromJson(json['identityCard'] as Map<String, dynamic>),
      bankAccount: json['bankAccount'] == null
          ? null
          : BankAccount.fromJson(json['bankAccount'] as Map<String, dynamic>),
      buddyProfile: json['buddyProfile'] == null
          ? null
          : BuddyProfile.fromJson(json['buddyProfile'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BuddyToJson(Buddy instance) => <String, dynamic>{
      'firebaseUID': instance.firebaseUID,
      'isBlocked': instance.isBlocked,
      'isApprovedBuddy': instance.isApprovedBuddy,
      'isApplicationToBeBuddyUnderReview':
          instance.isApplicationToBeBuddyUnderReview,
      'registrationMethod': instance.registrationMethod,
      'registrationDate': instance.registrationDate.toIso8601String(),
      'isIdentityValidated': instance.isIdentityValidated,
      'personalData': instance.personalData.toJson(),
      'email': instance.email,
      'walletId': instance.walletId,
      'phoneNumber': instance.phoneNumber.toJson(),
      'identityCard': instance.identityCard?.toJson(),
      'bankAccount': instance.bankAccount?.toJson(),
      'buddyProfile': instance.buddyProfile?.toJson(),
    };
