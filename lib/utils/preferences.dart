import 'package:shared_preferences/shared_preferences.dart';

class PreferenceUtils {
  static final PreferenceUtils _instance = PreferenceUtils._internal();

  static SharedPreferences? sharedPreferences;

  factory PreferenceUtils() {
    return _instance;
  }

  PreferenceUtils._internal() {
    getPreferences();
  }

  static getKey(String key, dynamic var1) {
    if (sharedPreferences != null) {
      if (var1 == null || var1 is String) {
        return sharedPreferences!.getString(key);
      } else if (var1 == false) {
        return sharedPreferences!.getBool(key);
      }
    }
  }

  static getPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static setKey(String key, dynamic value) async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (value is String) {
      sharedPreferences!.setString(key, value);
    } else if (value is bool) {
      sharedPreferences!.setBool(key, value);
    }else{
      sharedPreferences!.clear();
    }
  }

  static void setPreference(String key, Object? data) {
    setKey(key, data);
  }

  static dynamic getPreference(String key, param1) {
    var data = getKey(key, param1);
    if (data != null) {
      return data;
    } else {
      return param1;
    }
  }
}
