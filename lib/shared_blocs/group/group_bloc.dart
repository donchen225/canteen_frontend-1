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
    }
  }

  Stream<GroupState> _mapLoadUserGroupsToState() async* {
    final userGroups = await _groupRepository.getUserGroups();

    currentUserGroups = userGroups;

    final group =
        await _groupRepository.getGroup(currentUserGroups[0]?.groupId ?? '');

    currentGroup = group;

    yield GroupLoaded(group: currentGroup);
  }

  Stream<GroupState> _mapLoadGroupToState(LoadGroup event) async* {
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
}
