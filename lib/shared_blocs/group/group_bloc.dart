import 'dart:async';

import 'package:canteen_frontend/models/group/group.dart';
import 'package:canteen_frontend/models/group/group_repository.dart';
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
    } else if (event is JoinPublicGroup) {
      yield* _mapJoinPublicGroupToState(event);
    } else if (event is JoinedPrivateGroup) {
      yield* _mapJoinedPrivateGroupToState(event);
    } else if (event is LoadGroupMembers) {
      yield* _mapLoadGroupMembersToState();
    }
  }

  Stream<GroupState> _mapLoadGroupToState(LoadGroup event) async* {
    currentGroup = event.group;
    yield GroupLoaded(group: event.group);
  }

  Stream<GroupState> _mapJoinPublicGroupToState(JoinPublicGroup event) async* {
    await _groupRepository.joinGroup(event.group.id);
    final group = await _groupRepository.getGroup(event.group.id);
    _groupHomeBloc.add(LoadUserGroups());
    yield GroupLoaded(group: group);
  }

  Stream<GroupState> _mapJoinedPrivateGroupToState(
      JoinedPrivateGroup event) async* {
    final group = await _groupRepository.getGroup(event.group.id);
    _groupHomeBloc.add(LoadUserGroups());
    yield GroupLoaded(group: group);
  }

  Stream<GroupState> _mapLoadGroupMembersToState() async* {
    if (currentGroup != null) {
      if (currentGroup is DetailedGroup) {
        yield GroupLoaded(group: currentGroup);
      } else {
        final members = await _groupRepository.getGroupMembers(currentGroup.id);
        final detailedGroup = DetailedGroup.fromGroup(currentGroup, members);

        final index =
            currentGroups.indexWhere((group) => group.id == currentGroup.id);
        currentGroup = detailedGroup;

        if (index == -1) {
          currentGroups.add(detailedGroup);
        } else {
          currentGroups[index] = detailedGroup;
        }

        yield GroupLoaded(group: detailedGroup);
      }
    }
  }
}
