import 'package:json_annotation/json_annotation.dart';

part 'address.g.dart';

@JsonSerializable(explicitToJson: true)
class Address {
  final String streetName;
  final int? streetNumber;
  final String apartmentNumber;
  final String city;
  final String state;
  final String postalCode;
  final String country;

  Address({
    required this.streetName,
    this.streetNumber,
    required this.apartmentNumber,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
  });

  factory Address.fromJson(Map<String, dynamic> json) => _$AddressFromJson(json);
  Map<String, dynamic> toJson() => _$AddressToJson(this);
}
