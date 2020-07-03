import 'dart:convert';

import 'package:flutter/services.dart';

class AppConfig {
  static String storageUrl;
  static String defaultGroupId;

  AppConfig._();

  static AppConfig _instance;

  static Future<AppConfig> getInstance() async {
    if (_instance == null) {
      final configString =
          await rootBundle.loadString('assets/app_config.json');
      final config = json.decode(configString) as Map<String, dynamic>;
      _instance = AppConfig._();
      storageUrl = config['STORAGE_URL'];
      defaultGroupId =
          config['DEFAULT_GROUP_ID']; // TODO: move this to cloud config

      return _instance;
    }
    return _instance;
  }
}
