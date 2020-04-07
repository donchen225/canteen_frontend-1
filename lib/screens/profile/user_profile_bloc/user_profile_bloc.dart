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
      print('USER BLOC STATE CHANGE');
      if (state is UserLoaded) {
        add(LoadUserProfile(state.user));
      }
    });
  }

  @override
  UserProfileState get initialState =>
      UserProfileLoaded(_userRepository.currentUserNow()) ??
      UserProfileLoading();

  @override
  Stream<UserProfileState> mapEventToState(
    UserProfileEvent event,
  ) async* {
    if (event is LoadUserProfile) {
      yield* _mapLoadUserProfileToState(event.user);
    } else if (event is EditAboutSection) {
      yield* _mapEditAboutSectionToState(event.user);
    } else if (event is UpdateAboutSection) {
      yield* _mapUpdateAboutSectionToState(event.about);
    } else if (event is EditSkill) {
      yield* _mapEditTeachSkillToState(
          event.user, event.skillType, event.skillIndex);
    } else if (event is UpdateSkill) {
      yield* _mapUpdateTeachSkillToState(
          event.skill, event.skillType, event.skillIndex);
    }
  }

  Stream<UserProfileState> _mapLoadUserProfileToState(User user) async* {
    yield UserProfileLoaded(user);
  }

  Stream<UserProfileState> _mapEditAboutSectionToState(User user) async* {
    yield UserProfileEditingAbout(user);
  }

  Stream<UserProfileState> _mapUpdateAboutSectionToState(String about) async* {
    final updatedUser = _userRepository.updateAbout(about);
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
}
