import 'package:json_annotation/json_annotation.dart';

part 'student_details.g.dart';

@JsonSerializable(explicitToJson: true)
class StudentDetails {
  final String? institution;
  final String? fieldOfStudy;
  
  StudentDetails({
    this.institution,
    this.fieldOfStudy,
  });

  factory StudentDetails.fromJson(Map<String, dynamic> json) => _$StudentDetailsFromJson(json);
  Map<String, dynamic> toJson() => _$StudentDetailsToJson(this);
}
