import 'package:canteen_frontend/models/user_settings/user_settings.dart';
import 'package:equatable/equatable.dart';

abstract class SettingState extends Equatable {
  const SettingState();

  @override
  List<Object> get props => [];
}

class SettingsUninitialized extends SettingState {}

class SettingsLoaded extends SettingState {
  final UserSettings settings;

  const SettingsLoaded(this.settings);

  @override
  List<Object> get props => [settings];

  @override
  String toString() => 'SettingsLoaded { $settings  }';
}

class SettingsClearing extends SettingState {}
