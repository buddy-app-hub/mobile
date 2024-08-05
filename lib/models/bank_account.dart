import 'package:json_annotation/json_annotation.dart';

part 'bank_account.g.dart';

@JsonSerializable(explicitToJson: true)
class BankAccount {
  final String bankAccountNumber;
  final String bankName;

  BankAccount({
    required this.bankAccountNumber,
    required this.bankName,
  });

  factory BankAccount.fromJson(Map<String, dynamic> json) => _$BankAccountFromJson(json);
  Map<String, dynamic> toJson() => _$BankAccountToJson(this);
}
