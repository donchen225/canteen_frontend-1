import 'dart:async';

import 'package:canteen_frontend/models/group/group.dart';
import 'package:canteen_frontend/models/group/group_repository.dart';
import 'package:canteen_frontend/models/group/user_group.dart';
import 'package:canteen_frontend/models/user/user_repository.dart';
import 'package:canteen_frontend/shared_blocs/group/group_event.dart';
import 'package:canteen_frontend/shared_blocs/group/group_state.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

class GroupBloc extends Bloc<GroupEvent, GroupState> {
  final GroupRepository _groupRepository;
  final UserRepository _userRepository;
  Group currentGroup;
  List<UserGroup> currentUserGroups = [];
  List<Group> currentGroups = [];

  GroupBloc(
      {@required GroupRepository groupRepository,
      @required UserRepository userRepository})
      : assert(groupRepository != null),
        assert(userRepository != null),
        _groupRepository = groupRepository,
        _userRepository = userRepository;

  // Load local settings if exists
  @override
  GroupState get initialState => GroupUninitialized();

  @override
  Stream<GroupState> mapEventToState(
    GroupEvent event,
  ) async* {
    if (event is LoadUserGroups) {
      yield* _mapLoadUserGroupsToState();
    } else if (event is LoadGroup) {
      yield* _mapLoadGroupToState(event);
    } else if (event is LoadCurrentGroup) {
      yield* _mapLoadCurrentGroupToState();
    } else if (event is JoinGroup) {
      yield* _mapJoinGroupToState(event);
    }
  }

  Stream<GroupState> _mapLoadUserGroupsToState() async* {
    final userGroups = await _groupRepository.getUserGroups();

    currentUserGroups = userGroups;

    final groups = await Future.wait(currentUserGroups.map((userGroup) {
      return _groupRepository.getGroup(userGroup.id);
    }));

    if (groups.isNotEmpty) {
      currentGroup = groups[0];
      currentGroups = groups;

      yield GroupLoaded(group: currentGroup);
    } else {
      yield GroupEmpty();
    }
  }

  Stream<GroupState> _mapLoadGroupToState(LoadGroup event) async* {
    currentGroup = event.group;
    yield GroupLoaded(group: event.group);
  }

  Stream<GroupState> _mapLoadCurrentGroupToState() async* {
    if (currentGroup != null) {
      yield GroupLoaded(group: currentGroup);
    } else {
      //_userRepository
      yield GroupLoaded(group: currentGroup);
    }
  }

  Stream<GroupState> _mapJoinGroupToState(JoinGroup event) async* {
    await _groupRepository.joinGroup(event.groupId);
    final group = await _groupRepository.getGroup(event.groupId);
    yield GroupLoaded(group: group);
  }
}
