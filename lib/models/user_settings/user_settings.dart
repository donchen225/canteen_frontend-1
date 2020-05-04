import 'package:canteen_frontend/models/user_settings/user_settings_entity.dart';
import 'package:canteen_frontend/utils/shared_preferences_util.dart';
import 'package:equatable/equatable.dart';

class UserSettings extends Equatable {
  final String id;
  final bool pushNotifications;
  final int timeZone;
  final String timeZoneName;
  final bool settingsInitialized;

  const UserSettings({
    this.id,
    this.pushNotifications = false,
    this.timeZone = 0,
    this.timeZoneName = '',
    this.settingsInitialized = false,
  });

  @override
  List<Object> get props => [
        id,
        pushNotifications,
        timeZone,
        timeZoneName,
        settingsInitialized,
      ];

  static UserSettings fromEntity(UserSettingsEntity entity) {
    return UserSettings(
      id: entity.id,
      pushNotifications: entity.pushNotifications,
      timeZone: entity.timeZone,
      timeZoneName: entity.timeZoneName,
      settingsInitialized: entity.settingsInitialized,
    );
  }

  UserSettingsEntity toEntity() {
    return UserSettingsEntity(
      id: id,
      pushNotifications: pushNotifications,
      timeZone: timeZone,
      timeZoneName: timeZoneName,
      settingsInitialized: settingsInitialized,
    );
  }
}
