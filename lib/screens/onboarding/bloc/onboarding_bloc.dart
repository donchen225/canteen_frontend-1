import 'package:canteen_frontend/models/group/group.dart';
import 'package:canteen_frontend/models/group/group_repository.dart';
import 'package:canteen_frontend/models/skill/skill.dart';
import 'package:canteen_frontend/models/skill/skill_type.dart';
import 'package:canteen_frontend/models/user/user_repository.dart';
import 'package:canteen_frontend/screens/onboarding/bloc/onboarding_event.dart';
import 'package:canteen_frontend/screens/onboarding/bloc/onboarding_state.dart';
import 'package:canteen_frontend/services/firebase_storage.dart';
import 'package:canteen_frontend/utils/shared_preferences_util.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final UserRepository _userRepository;
  final GroupRepository _groupRepository;
  String _name = '';
  String _photoUrl = '';
  String _about = '';
  Skill _skill;
  List<Group> _groups;
  List<bool> _groupJoined;

  OnboardingBloc({
    @required UserRepository userRepository,
    @required GroupRepository groupRepository,
  })  : assert(userRepository != null),
        assert(groupRepository != null),
        _userRepository = userRepository,
        _groupRepository = groupRepository;

  @override
  OnboardingState get initialState => OnboardingUninitialized();

  @override
  Stream<OnboardingState> mapEventToState(OnboardingEvent event) async* {
    if (event is UpdateName) {
      yield* _mapUpdateNameToState(event);
    } else if (event is UpdatePhoto) {
      yield* _mapUpdatePhotoToState(event);
    } else if (event is UpdateAbout) {
      yield* _mapUpdateAboutToState(event);
    } else if (event is UpdateSkill) {
      yield* _mapUpdateSkillToState(event);
    } else if (event is LoadGroups) {
      yield* _mapLoadGroupsToState();
    } else if (event is JoinGroup) {
      yield* _mapJoinGroupToState(event);
    } else if (event is CompleteOnboarding) {
      yield* _mapCompleteOnboardingToState();
    }
  }

  Stream<OnboardingState> _mapUpdateNameToState(UpdateName event) async* {
    if (event.name != null && event.name.isNotEmpty) {
      _name = event.name;
    } else {
      final user = _userRepository.currentUserNow();
      _name = user.email?.split('@')?.first ?? '';
    }

    _userRepository.updateName(_name);

    yield OnboardingInProgress(name: _name);
  }

  Stream<OnboardingState> _mapUpdatePhotoToState(UpdatePhoto event) async* {
    final userId =
        CachedSharedPreferences.getString(PreferenceConstants.userId);

    await CloudStorage().upload(event.file, userId).then((task) async {
      final downloadUrl = (await task.onComplete);
      _photoUrl = (await downloadUrl.ref.getDownloadURL());
      _userRepository.updatePhoto(_photoUrl);
    });

    yield OnboardingInProgress(name: _name, photoUrl: _photoUrl);
  }

  Stream<OnboardingState> _mapUpdateAboutToState(UpdateAbout event) async* {
    _userRepository.updateAbout(event.about);

    _about = event.about;

    yield OnboardingInProgress(
        name: _name, photoUrl: _photoUrl, about: event.about);
  }

  Stream<OnboardingState> _mapUpdateSkillToState(UpdateSkill event) async* {
    final skill = Skill(
        name: event.name,
        description: event.description,
        price: event.price,
        duration: event.duration,
        type: event.isOffering ? SkillType.teach : SkillType.learn);

    if (event.isOffering) {
      _userRepository.updateTeachSkill(skill, 0);
    } else {
      _userRepository.updateLearnSkill(skill, 0);
    }

    _skill = skill;

    yield OnboardingInProgress(
        name: _name, photoUrl: _photoUrl, about: _about, skill: _skill);
  }

  Stream<OnboardingState> _mapLoadGroupsToState() async* {
    _groups = await _groupRepository.getAllGroups();
    _groupJoined = List<bool>.generate(_groups?.length ?? 0, (index) => false);

    final groupJoined = List<bool>.from(_groupJoined);

    yield OnboardingGroups(groups: _groups, joined: groupJoined);
  }

  Stream<OnboardingState> _mapJoinGroupToState(JoinGroup event) async* {
    _groupRepository.joinGroup(event.groupId);

    final index = _groups.indexWhere((group) => group.id == event.groupId);
    _groupJoined[index] = true;

    final groupJoined = List<bool>.from(_groupJoined);

    yield OnboardingGroups(groups: _groups, joined: groupJoined);
  }

  Stream<OnboardingState> _mapCompleteOnboardingToState() async* {
    _userRepository.completeOnboarding();
  }
}
