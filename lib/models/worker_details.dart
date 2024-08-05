import 'package:json_annotation/json_annotation.dart';

part 'worker_details.g.dart';

@JsonSerializable(explicitToJson: true)
class WorkerDetails {
  final String company;
  final String position;
  
  WorkerDetails({
    required this.company,
    required this.position,
  });

  factory WorkerDetails.fromJson(Map<String, dynamic> json) => _$WorkerDetailsFromJson(json);
  Map<String, dynamic> toJson() => _$WorkerDetailsToJson(this);
}
