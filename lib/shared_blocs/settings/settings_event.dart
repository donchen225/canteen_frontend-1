import 'package:canteen_frontend/models/user_settings/user_settings.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class SettingEvent extends Equatable {
  const SettingEvent();

  @override
  List<Object> get props => [];
}

class InitializeSettings extends SettingEvent {
  final bool hasOnboarded;

  const InitializeSettings({@required this.hasOnboarded});

  @override
  List<Object> get props => [hasOnboarded];

  @override
  String toString() => 'InitializeSettings { hasOnboarded: $hasOnboarded }';
}

class LoadSettings extends SettingEvent {
  final UserSettings settings;

  const LoadSettings(this.settings);

  @override
  List<Object> get props => [settings];

  @override
  String toString() => 'LoadSettings { settings: $settings }';
}

class UpdateSettings extends SettingEvent {
  final UserSettings settings;

  const UpdateSettings(this.settings);

  @override
  List<Object> get props => [settings];

  @override
  String toString() => 'UpdateSettings { settings: $settings }';
}

class ClearSettings extends SettingEvent {
  const ClearSettings();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'ClearSettings';
}