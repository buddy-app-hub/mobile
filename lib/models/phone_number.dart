import 'package:json_annotation/json_annotation.dart';

part 'phone_number.g.dart';

@JsonSerializable(explicitToJson: true)
class PhoneNumber {
  final String number;
  final String countryCode;

  PhoneNumber({
    required this.number,
    required this.countryCode,
  });

  factory PhoneNumber.fromJson(Map<String, dynamic> json) => _$PhoneNumberFromJson(json);
  Map<String, dynamic> toJson() => _$PhoneNumberToJson(this);
}
