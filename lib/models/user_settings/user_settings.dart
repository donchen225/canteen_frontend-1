import 'package:canteen_frontend/models/user_settings/user_settings_entity.dart';
import 'package:equatable/equatable.dart';

class UserSettings extends Equatable {
  final String id;
  final bool pushNotifications;
  final int timeZone;
  final String timeZoneName;

  const UserSettings({
    this.id,
    this.pushNotifications = false,
    this.timeZone = 0,
    this.timeZoneName = '',
  });

  @override
  List<Object> get props => [
        id,
        pushNotifications,
        timeZone,
        timeZoneName,
      ];

  static UserSettings fromEntity(UserSettingsEntity entity) {
    return UserSettings(
      id: entity.id,
      pushNotifications: entity.pushNotifications,
      timeZone: entity.timeZone,
      timeZoneName: entity.timeZoneName,
    );
  }

  UserSettingsEntity toEntity() {
    return UserSettingsEntity(
      id: id,
      pushNotifications: pushNotifications,
      timeZone: timeZone,
      timeZoneName: timeZoneName,
    );
  }
}
