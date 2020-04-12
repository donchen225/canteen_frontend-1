import 'package:shared_preferences/shared_preferences.dart';

class PreferenceConstants {
  static const userId = "user_id";
}

class CachedSharedPreferences {
  static SharedPreferences _preferences;
  static CachedSharedPreferences _instance;
  static Map<String, dynamic> _memoryCache = {};
  static final cacheKeyList = {
    PreferenceConstants.userId,
  };

  static Future getInstance() async {
    if (_instance == null) {
      var secureStorage = CachedSharedPreferences._();
      await secureStorage._init();
      _instance = secureStorage;

      // Load cache into memory
      for (String key in cacheKeyList) {
        _memoryCache[key] = _preferences.get(key);
      }
    }
    return _instance;
  }

  CachedSharedPreferences._();

  Future _init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static String getString(String key, {String defValue = ''}) {
    if (_preferences == null) {
      return defValue;
    }

    if (cacheKeyList.contains(key)) {
      return _memoryCache[key];
    }

    return _preferences.getString(key) ?? defValue;
  }

  static Future setString(String key, String value) {
    if (_preferences == null) {
      return null;
    }

    return _preferences.setString(key, value).then((result) {
      if (result) {
        _memoryCache[key] = value;
      }
    });
  }

  static Future clear() async {
    await _preferences.clear();
  }
}
