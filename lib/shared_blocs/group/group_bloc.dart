import 'dart:async';

import 'package:canteen_frontend/models/group/group.dart';
import 'package:canteen_frontend/models/group/group_repository.dart';
import 'package:canteen_frontend/models/group/user_group.dart';
import 'package:canteen_frontend/models/user/user_repository.dart';
import 'package:canteen_frontend/shared_blocs/group/group_event.dart';
import 'package:canteen_frontend/shared_blocs/group/group_state.dart';
import 'package:canteen_frontend/shared_blocs/group_home/bloc.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

class GroupBloc extends Bloc<GroupEvent, GroupState> {
  final GroupRepository _groupRepository;
  final UserRepository _userRepository;
  Group currentGroup;
  List<UserGroup> currentUserGroups = [];
  List<Group> currentGroups = [];
  GroupHomeBloc _groupHomeBloc;

  GroupBloc({
    @required GroupRepository groupRepository,
    @required UserRepository userRepository,
    @required GroupHomeBloc groupHomeBloc,
  })  : assert(groupRepository != null),
        assert(userRepository != null),
        assert(groupHomeBloc != null),
        _groupRepository = groupRepository,
        _userRepository = userRepository,
        _groupHomeBloc = groupHomeBloc;

  // Load local settings if exists
  @override
  GroupState get initialState => GroupUninitialized();

  @override
  Stream<GroupState> mapEventToState(
    GroupEvent event,
  ) async* {
    if (event is LoadGroup) {
      yield* _mapLoadGroupToState(event);
    } else if (event is JoinGroup) {
      yield* _mapJoinGroupToState(event);
    }
  }

  Stream<GroupState> _mapLoadGroupToState(LoadGroup event) async* {
    currentGroup = event.group;
    yield GroupLoaded(group: event.group);
  }

  Stream<GroupState> _mapJoinGroupToState(JoinGroup event) async* {
    await _groupRepository.joinGroup(event.groupId);
    final group = await _groupRepository.getGroup(event.groupId);
    _groupHomeBloc.add(LoadUserGroups());
    yield GroupLoaded(group: group);
  }
}
