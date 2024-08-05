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
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      age: (json['age'] as num?)?.toInt(),
      gender: json['gender'] as String,
      birthDate: json['birthDate'] == null
          ? null
          : DateTime.parse(json['birthDate'] as String),
      nationality: json['nationality'] as String?,
      maritalStatus: json['maritalStatus'] as String?,
      email: json['email'] as String,
      phoneNumber:
          PhoneNumber.fromJson(json['phoneNumber'] as Map<String, dynamic>),
      identityCard: json['identityCard'] == null
          ? null
          : IdentityCard.fromJson(json['identityCard'] as Map<String, dynamic>),
      bankAccount: json['bankAccount'] == null
          ? null
          : BankAccount.fromJson(json['bankAccount'] as Map<String, dynamic>),
      address: json['address'] == null
          ? null
          : Address.fromJson(json['address'] as Map<String, dynamic>),
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
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'age': instance.age,
      'gender': instance.gender,
      'birthDate': instance.birthDate?.toIso8601String(),
      'nationality': instance.nationality,
      'maritalStatus': instance.maritalStatus,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber.toJson(),
      'identityCard': instance.identityCard?.toJson(),
      'bankAccount': instance.bankAccount?.toJson(),
      'address': instance.address?.toJson(),
      'buddyProfile': instance.buddyProfile?.toJson(),
    };
