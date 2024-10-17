import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobile/models/price.dart';
import 'package:mobile/models/transaction.dart';

part 'wallet.g.dart';

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class Wallet {
  @JsonKey(name: '_id')
  final String id;
  final Price? total;
  final Price? balance;
  final List<Tx> transactions;

  Wallet({
    required this.id,
    this.total,
    this.balance,
    required this.transactions,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) => _$WalletFromJson(json);
  Map<String, dynamic> toJson() => _$WalletToJson(this);
}
