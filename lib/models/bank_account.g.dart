// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bank_account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BankAccount _$BankAccountFromJson(Map<String, dynamic> json) => BankAccount(
      bankAccountNumber: json['bankAccountNumber'] as String,
      bankName: json['bankName'] as String,
    );

Map<String, dynamic> _$BankAccountToJson(BankAccount instance) =>
    <String, dynamic>{
      'bankAccountNumber': instance.bankAccountNumber,
      'bankName': instance.bankName,
    };
