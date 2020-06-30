import 'dart:convert';

import 'package:flutter/services.dart';

class AppConfig {
  static String storageUrl;

  AppConfig._();

  static AppConfig _instance;

  static Future<AppConfig> getInstance() async {
    if (_instance == null) {
      final configString =
          await rootBundle.loadString('assets/app_config.json');
      final config = json.decode(configString) as Map<String, dynamic>;
      _instance = AppConfig._();
      storageUrl = config['STORAGE_URL'];

      return _instance;
    }
    return _instance;
  }
}
