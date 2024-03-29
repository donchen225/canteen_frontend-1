import 'dart:async';

import 'package:canteen_frontend/models/group/group.dart';
import 'package:canteen_frontend/models/group/group_repository.dart';
import 'package:canteen_frontend/models/group/user_group.dart';
import 'package:canteen_frontend/models/user/user_repository.dart';
import 'package:canteen_frontend/shared_blocs/group_home/group_home_event.dart';
import 'package:canteen_frontend/shared_blocs/group_home/group_home_state.dart';
import 'package:canteen_frontend/utils/app_config.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

class GroupHomeBloc extends Bloc<GroupHomeEvent, GroupHomeState> {
  final GroupRepository _groupRepository;
  final UserRepository _userRepository;
  Group currentGroup;
  List<UserGroup> currentUserGroups = [];
  List<Group> currentGroups = [];
  DateTime _lastUpdated;

  GroupHomeBloc(
      {@required GroupRepository groupRepository,
      @required UserRepository userRepository})
      : assert(groupRepository != null),
        assert(userRepository != null),
        _groupRepository = groupRepository,
        _userRepository = userRepository;

  // Load local settings if exists
  @override
  GroupHomeState get initialState => GroupHomeUnauthenticated();

  @override
  Stream<GroupHomeState> mapEventToState(
    GroupHomeEvent event,
  ) async* {
    if (event is LoadUserGroups) {
      yield* _mapLoadUserGroupsToState(event);
    } else if (event is LoadHomeGroup) {
      yield* _mapLoadHomeGroupToState(event);
    } else if (event is LoadHomeGroupMembers) {
      yield* _mapLoadHomeGroupMembersToState();
    } else if (event is LoadDefaultGroup) {
      yield* _mapLoadDefaultGroupToState();
    } else if (event is ClearHomeGroup) {
      yield* _mapClearHomeGroupToState();
    }
  }

  Stream<GroupHomeState> _mapLoadUserGroupsToState(
      LoadUserGroups event) async* {
    if (event.showLoading) {
      yield GroupHomeLoading();
    }

    final userGroups = await _groupRepository.getUserGroups();

    currentUserGroups = userGroups;

    final groups = await Future.wait(currentUserGroups.map((userGroup) {
      return _groupRepository.getGroup(userGroup.id);
    }));

    if (groups.isNotEmpty) {
      currentGroup = groups[0];
      currentGroups = groups;

      final time = DateTime.now();
      _lastUpdated = time;

      yield GroupHomeLoaded(group: currentGroup, lastUpdated: time);
    } else {
      yield GroupHomeEmpty();
    }
  }

  Stream<GroupHomeState> _mapLoadHomeGroupToState(LoadHomeGroup event) async* {
    currentGroup = event.group;

    final time = DateTime.now();
    _lastUpdated = time;

    yield GroupHomeLoaded(group: event.group, lastUpdated: time);
  }

  Stream<GroupHomeState> _mapLoadHomeGroupMembersToState() async* {
    if (currentGroup != null) {
      if (currentGroup is DetailedGroup) {
        yield GroupHomeLoaded(group: currentGroup, lastUpdated: _lastUpdated);
      } else {
        final members = await _groupRepository.getGroupMembers(currentGroup.id);
        final detailedGroup = DetailedGroup.fromGroup(currentGroup, members);

        final index =
            currentGroups.indexWhere((group) => group.id == currentGroup.id);
        currentGroup = detailedGroup;
        currentGroups[index] = detailedGroup;

        yield GroupHomeLoaded(group: detailedGroup, lastUpdated: _lastUpdated);
      }
    }
  }

  Stream<GroupHomeState> _mapLoadDefaultGroupToState() async* {
    final group = await _groupRepository.getGroup(AppConfig.defaultGroupId);

    final members = await _groupRepository.getGroupMembers(group.id);
    final detailedGroup = DetailedGroup.fromGroup(group, members);

    currentGroup = detailedGroup;
    currentGroups = [detailedGroup];

    final time = DateTime.now();
    _lastUpdated = time;

    yield GroupHomeLoaded(group: detailedGroup, lastUpdated: time);
  }

  Stream<GroupHomeState> _mapClearHomeGroupToState() async* {
    currentGroup = null;
    currentGroups = [];
    currentUserGroups = [];

    yield GroupHomeUnauthenticated();
  }
}
