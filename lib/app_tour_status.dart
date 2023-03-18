import 'package:shared_preferences/shared_preferences.dart';

class SaveAppTour {
  Future<SharedPreferences> data = SharedPreferences.getInstance();

  Future<bool> alreadyDone(String key) async {
    final value = await data;
    if (value.containsKey(key)) {
      return value.getBool(key)!;
    }
    return false;
  }

  void saveStatus(String key) async {
    final value = await data;
    value.setBool(key, true);
  }
}
