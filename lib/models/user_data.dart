import 'buddy.dart';
import 'elder.dart';

class UserData {
  final Buddy? buddy;
  final Elder? elder;

  UserData({
    this.buddy,
    this.elder,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    if (json['userType'] == 'buddy') {
      return UserData(buddy: Buddy.fromJson(json));
    } else if (json['userType'] == 'elder') {
      return UserData(elder: Elder.fromJson(json));
    } else {
      throw Exception('Unknown user type');
    }
  }

  Map<String, dynamic> toJson() {
    if (buddy != null) {
      return buddy!.toJson();
    } else if (elder != null) {
      return elder!.toJson();
    } else {
      throw Exception('Unknown user type');
    }
  }
}
