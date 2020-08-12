import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';

class AppConfig {
  static String storageUrl;
  static String defaultGroupId;
  static String logLevel;
  static String appVersion;

  AppConfig._();

  static AppConfig _instance;

  static Future<AppConfig> getInstance() async {
    if (_instance == null) {
      final configString =
          await rootBundle.loadString('assets/app_config.json');
      final config = json.decode(configString) as Map<String, dynamic>;
      _instance = AppConfig._();
      storageUrl = config['STORAGE_URL'];
      logLevel = config['LOG_LEVEL'];
      defaultGroupId =
          config['DEFAULT_GROUP_ID']; // TODO: move this to cloud config

      // Get package info
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      appVersion = '${packageInfo.version}.${packageInfo.buildNumber}';

      return _instance;
    }
    return _instance;
  }
}
