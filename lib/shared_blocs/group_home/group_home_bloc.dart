import 'dart:async';

import 'package:canteen_frontend/models/group/group.dart';
import 'package:canteen_frontend/models/group/group_repository.dart';
import 'package:canteen_frontend/models/group/user_group.dart';
import 'package:canteen_frontend/models/user/user_repository.dart';
import 'package:canteen_frontend/shared_blocs/group_home/group_home_event.dart';
import 'package:canteen_frontend/shared_blocs/group_home/group_home_state.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

class GroupHomeBloc extends Bloc<GroupHomeEvent, GroupHomeState> {
  final GroupRepository _groupRepository;
  final UserRepository _userRepository;
  Group currentGroup;
  List<UserGroup> currentUserGroups = [];
  List<Group> currentGroups = [];

  GroupHomeBloc(
      {@required GroupRepository groupRepository,
      @required UserRepository userRepository})
      : assert(groupRepository != null),
        assert(userRepository != null),
        _groupRepository = groupRepository,
        _userRepository = userRepository;

  // Load local settings if exists
  @override
  GroupHomeState get initialState => GroupHomeUninitialized();

  @override
  Stream<GroupHomeState> mapEventToState(
    GroupHomeEvent event,
  ) async* {
    if (event is LoadUserGroups) {
      yield* _mapLoadUserGroupsToState();
    } else if (event is LoadHomeGroup) {
      yield* _mapLoadGroupToState(event);
    } else if (event is LoadCurrentGroup) {
      yield* _mapLoadCurrentGroupToState();
    } else if (event is LoadHomeGroupMembers) {
      yield* _mapLoadHomeGroupMembersToState();
    }
  }

  Stream<GroupHomeState> _mapLoadUserGroupsToState() async* {
    final userGroups = await _groupRepository.getUserGroups();

    currentUserGroups = userGroups;

    final groups = await Future.wait(currentUserGroups.map((userGroup) {
      return _groupRepository.getGroup(userGroup.id);
    }));

    if (groups.isNotEmpty) {
      currentGroup = groups[0];
      currentGroups = groups;

      yield GroupHomeLoaded(group: currentGroup);
    } else {
      yield GroupHomeEmpty();
    }
  }

  Stream<GroupHomeState> _mapLoadGroupToState(LoadHomeGroup event) async* {
    currentGroup = event.group;
    yield GroupHomeLoaded(group: event.group);
  }

  Stream<GroupHomeState> _mapLoadCurrentGroupToState() async* {
    if (currentGroup != null) {
      yield GroupHomeLoaded(group: currentGroup);
    } else {
      //_userRepository
      yield GroupHomeLoaded(group: currentGroup);
    }
  }

  Stream<GroupHomeState> _mapLoadHomeGroupMembersToState() async* {
    if (currentGroup != null) {
      if (currentGroup is DetailedGroup) {
        yield GroupHomeLoaded(group: currentGroup);
      } else {
        final members = await _groupRepository.getGroupMembers(currentGroup.id);
        final detailedGroup = DetailedGroup.fromGroup(currentGroup, members);

        final index =
            currentGroups.indexWhere((group) => group.id == currentGroup.id);
        currentGroup = detailedGroup;
        currentGroups[index] = detailedGroup;

        yield GroupHomeLoaded(group: detailedGroup);
      }
    }
  }
}