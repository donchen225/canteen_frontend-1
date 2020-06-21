import 'package:shared_preferences/shared_preferences.dart';

class PreferenceConstants {
  static const userId = "user_id";
  static const userPhotoUrl = "user_photo_url";
  static const userName = "user_name";
  static const deviceId = "device_id";
  static const pushNotificationsSystem = "push_notifications_system";
  static const pushNotificationsApp = "push_notifications_app";
  static const timeZone = "time_zone";
  static const timeZoneName = "time_zone_name";
  static const settingsInitialized = "settings_initialized";
}

class CachedSharedPreferences {
  static SharedPreferences _preferences;
  static CachedSharedPreferences _instance;
  static Map<String, dynamic> _memoryCache = {};
  static final cacheKeyList = [
    PreferenceConstants.userId,
  ];

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

  static Future<void> setString(String key, String value) {
    if (_preferences == null) {
      return null;
    }

    return _preferences.setString(key, value).then((result) {
      if (result) {
        _memoryCache[key] = value;
      }
    });
  }

  static bool getBool(String key, {bool defValue = false}) {
    if (_preferences == null) {
      return defValue;
    }

    if (cacheKeyList.contains(key)) {
      return _memoryCache[key];
    }

    return _preferences.getBool(key) ?? defValue;
  }

  static Future<void> setBool(String key, bool value) {
    if (_preferences == null) {
      return null;
    }

    return _preferences.setBool(key, value).then((result) {
      if (result) {
        _memoryCache[key] = value;
      }
    });
  }

  static int getInt(String key, {int defValue = 0}) {
    if (_preferences == null) {
      return defValue;
    }

    if (cacheKeyList.contains(key)) {
      return _memoryCache[key];
    }

    return _preferences.getInt(key) ?? defValue;
  }

  static Future<void> setInt(String key, int value) {
    if (_preferences == null) {
      return null;
    }

    return _preferences.setInt(key, value).then((result) {
      if (result) {
        _memoryCache[key] = value;
      }
    });
  }

  static Future clear() async {
    await _preferences.clear();
  }
}
