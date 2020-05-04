import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class UserSettingsEntity extends Equatable {
  final String id;
  final bool pushNotifications;
  final int timeZone;
  final String timeZoneName;
  final bool settingsInitialized;

  const UserSettingsEntity({
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

  static UserSettingsEntity fromSnapshot(DocumentSnapshot snap) {
    return UserSettingsEntity(
      id: snap.documentID,
      pushNotifications: snap.data["push_notifications"],
      timeZone: snap.data["time_zone"],
      timeZoneName: snap.data["time_zone_name"],
      settingsInitialized: snap.data["settings_initialized"],
    );
  }

  Map<String, Object> toDocument() {
    return {
      "push_notifications": pushNotifications,
      "time_zone": timeZone,
      "time_zone_name": timeZoneName,
      "settings_initialized": settingsInitialized,
    };
  }
}
