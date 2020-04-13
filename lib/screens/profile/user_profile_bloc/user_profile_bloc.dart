import 'dart:async';
import 'package:canteen_frontend/models/skill/skill.dart';
import 'package:canteen_frontend/models/user/user.dart';
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
      yield* _mapLoadUserProfileToState(event.user);
    } else if (event is EditAboutSection) {
      yield* _mapEditAboutSectionToState(event);
    } else if (event is UpdateAboutSection) {
      yield* _mapUpdateAboutSectionToState(event);
    } else if (event is EditSkill) {
      yield* _mapEditTeachSkillToState(
          event.user, event.skillType, event.skillIndex);
    } else if (event is UpdateSkill) {
      yield* _mapUpdateTeachSkillToState(
          event.skill, event.skillType, event.skillIndex);
    } else if (event is EditName) {
      yield* _mapEditNameToState(event);
    } else if (event is UpdateName) {
      yield* _mapUpdateNameToState(event);
    }
  }

  Stream<UserProfileState> _mapLoadUserProfileToState(User user) async* {
    yield UserProfileLoaded(user);
  }

  Stream<UserProfileState> _mapEditAboutSectionToState(
      EditAboutSection event) async* {
    yield UserProfileEditingAbout(event.user);
  }

  Stream<UserProfileState> _mapUpdateAboutSectionToState(
      UpdateAboutSection event) async* {
    final updatedUser = _userRepository.updateAbout(event.about);
    yield UserProfileLoaded(updatedUser);
  }

  Stream<UserProfileState> _mapEditNameToState(EditName event) async* {
    yield UserProfileEditingName(event.user);
  }

  Stream<UserProfileState> _mapUpdateNameToState(UpdateName event) async* {
    final updatedUser = _userRepository.updateName(event.name);
    yield UserProfileLoaded(updatedUser);
  }

  Stream<UserProfileState> _mapEditTeachSkillToState(
      User user, String skillType, int skillIndex) async* {
    yield UserProfileEditingSkill(user, skillType, skillIndex);
  }

  Stream<UserProfileState> _mapUpdateTeachSkillToState(
      Skill skill, String skillType, int index) async* {
    final updatedUser = skillType == 'teach'
        ? _userRepository.updateTeachSkill(skill, index)
        : _userRepository.updateLearnSkill(skill, index);
    yield UserProfileLoaded(updatedUser);
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }
}
