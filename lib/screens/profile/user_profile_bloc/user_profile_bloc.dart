import 'dart:async';
import 'package:canteen_frontend/models/skill/skill_type.dart';
import 'package:canteen_frontend/models/user/user_repository.dart';
import 'package:meta/meta.dart';

import 'package:canteen_frontend/screens/profile/user_profile_bloc/user_profile_event.dart';
import 'package:canteen_frontend/screens/profile/user_profile_bloc/user_profile_state.dart';
import 'package:canteen_frontend/shared_blocs/user/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final UserRepository _userRepository;
  final UserBloc _userBloc;
  StreamSubscription _userSubscription;

  UserProfileBloc({
    @required UserRepository userRepository,
    @required UserBloc userBloc,
  })  : assert(userRepository != null),
        assert(userBloc != null),
        _userRepository = userRepository,
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
    return user != null ? UserProfileLoaded(user) : UserProfileLoading();
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
      yield* _mapEditTeachSkillToState(event);
    } else if (event is UpdateSkill) {
      yield* _mapUpdateTeachSkillToState(event);
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
    } else if (event is ShowUserProfile) {
      yield* _mapShowUserProfileToState();
    }
  }

  Stream<UserProfileState> _mapLoadUserProfileToState(
      LoadUserProfile event) async* {
    yield UserProfileLoaded(event.user);
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
    // await _userRepository.updateTitle(event.title);
  }

  Stream<UserProfileState> _mapEditAvailabilityToState(
      EditAvailability event) async* {
    yield UserProfileEditingAvailability(event.user, event.day);
  }

  Stream<UserProfileState> _mapUpdateAvailabilityToState(
      UpdateAvailability event) async* {
    await _userRepository.updateAvailability(
        event.day.index, event.startTime, event.endTime);
  }

  Stream<UserProfileState> _mapEditTeachSkillToState(EditSkill event) async* {
    yield UserProfileEditingSkill(
        event.user, event.skillType, event.skillIndex);
  }

  Stream<UserProfileState> _mapUpdateTeachSkillToState(
      UpdateSkill event) async* {
    event.skillType == SkillType.teach
        ? await _userRepository.updateTeachSkill(event.skill, event.skillIndex)
        : await _userRepository.updateLearnSkill(event.skill, event.skillIndex);
  }

  Stream<UserProfileState> _mapShowSettingsToState() async* {
    yield SettingsMenu();
  }

  Stream<UserProfileState> _mapShowUserProfileToState() async* {
    final userState = _userBloc.state;
    if (userState is UserLoaded) {
      yield UserProfileLoaded(userState.user);
    } else {
      yield UserProfileLoading();
      yield UserProfileLoaded(await _userRepository.currentUser());
    }
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }
}
