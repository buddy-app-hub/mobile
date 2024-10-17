// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Wallet _$WalletFromJson(Map<String, dynamic> json) => Wallet(
      id: json['_id'] as String,
      total: json['total'] == null
          ? null
          : Price.fromJson(json['total'] as Map<String, dynamic>),
      balance: json['balance'] == null
          ? null
          : Price.fromJson(json['balance'] as Map<String, dynamic>),
      transactions: (json['transactions'] as List<dynamic>)
          .map((e) => Tx.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WalletToJson(Wallet instance) => <String, dynamic>{
      '_id': instance.id,
      'total': instance.total?.toJson(),
      'balance': instance.balance?.toJson(),
      'transactions': instance.transactions.map((e) => e.toJson()).toList(),
    };
