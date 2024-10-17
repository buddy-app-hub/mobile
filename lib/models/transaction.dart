import 'dart:ffi';

import 'package:json_annotation/json_annotation.dart';

part 'transaction.g.dart';

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class Tx {
  final String paymentId;
  final String status;
  final String type;
  final String description;
  final double amount;
  final String currencyId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Tx({
    required this.paymentId,
    required this.status,
    required this.type,
    required this.description,
    required this.amount,
    required this.currencyId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Tx.fromJson(Map<String, dynamic> json) => _$TxFromJson(json);
  Map<String, dynamic> toJson() => _$TxToJson(this);
}
