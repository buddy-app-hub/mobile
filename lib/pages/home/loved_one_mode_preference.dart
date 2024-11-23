import 'package:shared_preferences/shared_preferences.dart';

class LovedOneModePreference {
  static const String _key = "isLovedOneModeOn";

  Future<void> saveMode(bool isLovedOneModeOn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, isLovedOneModeOn);
  }

  Future<bool> getMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_key) ??
        false; // El default es el modo elder, no loved one.
  }
}
