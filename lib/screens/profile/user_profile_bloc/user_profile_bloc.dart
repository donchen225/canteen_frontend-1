import 'dart:async';
import 'package:canteen_frontend/models/skill/skill_type.dart';
import 'package:canteen_frontend/models/user/user_repository.dart';
import 'package:canteen_frontend/models/user_settings/settings_repository.dart';
import 'package:canteen_frontend/models/user_settings/user_settings.dart';
import 'package:canteen_frontend/utils/shared_preferences_util.dart';
import 'package:meta/meta.dart';

import 'package:canteen_frontend/screens/profile/user_profile_bloc/user_profile_event.dart';
import 'package:canteen_frontend/screens/profile/user_profile_bloc/user_profile_state.dart';
import 'package:canteen_frontend/shared_blocs/user/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final UserRepository _userRepository;
  final SettingsRepository _settingsRepository;
  final UserBloc _userBloc;
  StreamSubscription _userSubscription;

  UserProfileBloc({
    @required UserRepository userRepository,
    @required SettingsRepository settingsRepository,
    @required UserBloc userBloc,
  })  : assert(userRepository != null),
        assert(settingsRepository != null),
        assert(userBloc != null),
        _userRepository = userRepository,
        _settingsRepository = settingsRepository,
        _userBloc = userBloc {
    _userSubscription = _userBloc.listen((state) {
      if (state is UserLoaded) {
        add(LoadUserProfile(state.user));
      }
    });
  }

  @override
  UserProfileState get initialState {
    final user = _userRepository.currentUserNow();
    final settings = _settingsRepository.getCurrentSettings();
    return (user != null && settings != null)
        ? UserProfileLoaded(user, settings)
        : UserProfileLoading();
  }

  @override
  Stream<UserProfileState> mapEventToState(
    UserProfileEvent event,
  ) async* {
    if (event is LoadUserProfile) {
      yield* _mapLoadUserProfileToState(event);
    } else if (event is EditAboutSection) {
      yield* _mapEditAboutSectionToState(event);
    } else if (event is UpdateAboutSection) {
      yield* _mapUpdateAboutSectionToState(event);
    } else if (event is EditSkill) {
      yield* _mapEditSkillToState(event);
    } else if (event is UpdateSkill) {
      yield* _mapUpdateSkillToState(event);
    } else if (event is DeleteSkill) {
      yield* _mapDeleteSkillToState(event);
    } else if (event is EditName) {
      yield* _mapEditNameToState(event);
    } else if (event is UpdateName) {
      yield* _mapUpdateNameToState(event);
    } else if (event is EditTitle) {
      yield* _mapEditTitleToState(event);
    } else if (event is UpdateTitle) {
      yield* _mapUpdateTitleToState(event);
    } else if (event is EditInterests) {
      yield* _mapEditInterestsToState(event);
    } else if (event is UpdateInterests) {
      yield* _mapUpdateInterestsToState(event);
    } else if (event is EditAvailability) {
      yield* _mapEditAvailabilityToState(event);
    } else if (event is UpdateAvailability) {
      yield* _mapUpdateAvailabilityToState(event);
    } else if (event is ShowSettings) {
      yield* _mapShowSettingsToState();
    }
  }

  Stream<UserProfileState> _mapLoadUserProfileToState(
      LoadUserProfile event) async* {
    // Load settings from cache here
    // final pushNotifications = CachedSharedPreferences.getBool(
    //     PreferenceConstants.pushNotificationsSystem);
    final timeZone =
        CachedSharedPreferences.getInt(PreferenceConstants.timeZone);
    final timeZoneName =
        CachedSharedPreferences.getString(PreferenceConstants.timeZoneName);
    final settings = UserSettings(
        // pushNotifications: pushNotifications,
        timeZone: timeZone,
        timeZoneName: timeZoneName);

    yield UserProfileLoaded(event.user, settings);
  }

  Stream<UserProfileState> _mapEditAboutSectionToState(
      EditAboutSection event) async* {
    yield UserProfileEditingAbout(event.user);
  }

  Stream<UserProfileState> _mapUpdateAboutSectionToState(
      UpdateAboutSection event) async* {
    await _userRepository.updateAbout(event.about);
  }

  Stream<UserProfileState> _mapEditNameToState(EditName event) async* {
    yield UserProfileEditingName(event.user);
  }

  Stream<UserProfileState> _mapUpdateNameToState(UpdateName event) async* {
    await _userRepository.updateName(event.name);
  }

  Stream<UserProfileState> _mapEditTitleToState(EditTitle event) async* {
    yield UserProfileEditingTitle(event.user);
  }

  Stream<UserProfileState> _mapUpdateTitleToState(UpdateTitle event) async* {
    await _userRepository.updateTitle(event.title);
  }

  Stream<UserProfileState> _mapEditInterestsToState(
      EditInterests event) async* {
    yield UserProfileEditingInterests(event.user);
  }

  Stream<UserProfileState> _mapUpdateInterestsToState(
      UpdateInterests event) async* {
    await _userRepository.updateInterests(event.interests);
  }

  Stream<UserProfileState> _mapEditAvailabilityToState(
      EditAvailability event) async* {
    yield UserProfileEditingAvailability(
        user: event.user,
        day: event.day,
        startTime: event.startTime,
        endTime: event.endTime);
  }

  Stream<UserProfileState> _mapUpdateAvailabilityToState(
      UpdateAvailability event) async* {
    await _userRepository.updateAvailability(
        event.day.index, event.startTimeSeconds, event.endTimeSeconds);
  }

  Stream<UserProfileState> _mapEditSkillToState(EditSkill event) async* {
    yield UserProfileEditingSkill(
        event.user, event.skillType, event.skillIndex);
  }

  Stream<UserProfileState> _mapUpdateSkillToState(UpdateSkill event) async* {
    event.skillType == SkillType.offer
        ? await _userRepository.updateTeachSkill(event.skill, event.skillIndex)
        : await _userRepository.updateLearnSkill(event.skill, event.skillIndex);
  }

  Stream<UserProfileState> _mapDeleteSkillToState(DeleteSkill event) async* {
    final user = _userRepository.currentUserNow();

    if (event.skillType == SkillType.offer) {
      if (user.teachSkill.length > 0 &&
          event.skillIndex >= 0 &&
          event.skillIndex <= user.teachSkill.length) {
        _userRepository.deleteTeachSkill(event.skillIndex);
        user.teachSkill.removeAt(event.skillIndex);
      }
    } else {
      if (user.learnSkill.length > 0 &&
          event.skillIndex >= 0 &&
          event.skillIndex <= user.learnSkill.length) {
        _userRepository.deleteLearnSkill(event.skillIndex);
        user.learnSkill.removeAt(event.skillIndex);
      }
    }

    yield UserProfileLoaded(user, _settingsRepository.getCurrentSettings());
  }

  Stream<UserProfileState> _mapShowSettingsToState() async* {
    yield SettingsMenu();
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }
}
