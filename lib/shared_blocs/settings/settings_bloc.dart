import 'dart:async';

import 'package:canteen_frontend/models/user_settings/settings_repository.dart';
import 'package:canteen_frontend/models/user_settings/user_settings.dart';
import 'package:canteen_frontend/shared_blocs/settings/settings_event.dart';
import 'package:canteen_frontend/shared_blocs/settings/settings_state.dart';
import 'package:canteen_frontend/utils/push_notifications.dart';
import 'package:canteen_frontend/utils/shared_preferences_util.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:canteen_frontend/models/user/user_repository.dart';

// SettingBloc manages all user and app settings
// There are 2 setting flows:
// 1. New user - User hasn't onboarded and settings don't exist on cloud
//    - App starts -> user onboard process -> initialize push notifications manager ->
//      user settings uploaded to cloud/saved in SharedPreferences
// 2. Existing user - User has already onboarded and settings exist on cloud
//    - App starts -> initialize push notifications manager ->
//      check and load if settings exist on cloud
class SettingBloc extends Bloc<SettingEvent, SettingState> {
  final UserRepository _userRepository;
  final SettingsRepository _settingsRepository;

  SettingBloc(
      {@required SettingsRepository settingsRepository,
      @required UserRepository userRepository})
      : assert(settingsRepository != null),
        assert(userRepository != null),
        _settingsRepository = settingsRepository,
        _userRepository = userRepository;

  // Load local settings if exists
  @override
  SettingState get initialState => SettingsUninitialized();

  @override
  Stream<SettingState> mapEventToState(
    SettingEvent event,
  ) async* {
    if (event is InitializeSettings) {
      yield* _mapInitializeSettingsToState(event);
    } else if (event is UpdateSettings) {
      yield* _mapUpdateSettingsToState();
    } else if (event is ToggleAppPushNotifications) {
      yield* _mapToggleAppPushNotificationsToState(event);
    } else if (event is ClearSettings) {
      yield* _mapClearSettingsToState();
    }
  }

  // Load settings from online only once per app start

  Stream<SettingState> _mapInitializeSettingsToState(
      InitializeSettings event) async* {
    yield SettingsLoading();
    UserSettings settings;

    try {
      settings = await _settingsRepository.getSettings();
      if (settings == null) {
        settings = await _initializeUserSettings();
      } else {
        await cacheSettings(settings);
      }
    } catch (e) {
      print('ERROR GETTING SETTINGS: $e');
    }

    PushNotificationsManager().init(_settingsRepository);

    yield SettingsLoaded(settings);
  }

  Stream<SettingState> _mapUpdateSettingsToState() async* {}

  Stream<SettingState> _mapToggleAppPushNotificationsToState(
      ToggleAppPushNotifications event) async* {
    final deviceId =
        CachedSharedPreferences.getString(PreferenceConstants.deviceId);

    _settingsRepository.toggleSettingPushNotification(event.notifications);

    await _settingsRepository.toggleDevicePushNotification(
        deviceId, event.notifications);
  }

  Future<UserSettings> _initializeUserSettings() async {
    final currentTime = DateTime.now();
    final settings = UserSettings(
        pushNotifications: true,
        timeZone: currentTime.timeZoneOffset.inSeconds,
        timeZoneName: currentTime.timeZoneName,
        settingsInitialized: true);

    _settingsRepository.createSettings(settings);
    _userRepository.updateTimeZone(currentTime.timeZoneOffset.inSeconds);

    // Save settings in shared preferences
    await cacheSettings(settings);

    return settings;
  }

  Stream<SettingState> _mapClearSettingsToState() async* {
    CachedSharedPreferences.clear();
    yield SettingsUninitialized();
  }

  Future<void> cacheSettings(UserSettings settings) async {
    await CachedSharedPreferences.setBool(
        PreferenceConstants.pushNotificationsApp, settings.pushNotifications);
    CachedSharedPreferences.setInt(
        PreferenceConstants.timeZone, settings.timeZone);
    CachedSharedPreferences.setString(
        PreferenceConstants.timeZoneName, settings.timeZoneName);
    CachedSharedPreferences.setBool(
        PreferenceConstants.settingsInitialized, settings.settingsInitialized);
  }
}
