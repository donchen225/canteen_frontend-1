import 'dart:async';
import 'package:canteen_frontend/models/api_response/api_response_status.dart';
import 'package:canteen_frontend/models/group/group_repository.dart';
import 'package:canteen_frontend/screens/private_group_dialog/bloc/private_group_event.dart';
import 'package:canteen_frontend/screens/private_group_dialog/bloc/private_group_state.dart';
import 'package:meta/meta.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class PrivateGroupBloc extends Bloc<PrivateGroupEvent, PrivateGroupState> {
  final GroupRepository _groupRepository;

  PrivateGroupBloc({
    @required GroupRepository groupRepository,
  })  : assert(groupRepository != null),
        _groupRepository = groupRepository;

  @override
  PrivateGroupState get initialState => PrivateGroupUninitialized();

  @override
  Stream<PrivateGroupState> mapEventToState(
    PrivateGroupEvent event,
  ) async* {
    if (event is JoinPrivateGroup) {
      yield* _mapJoinPrivateGroupToState(event);
    }
  }

  Stream<PrivateGroupState> _mapJoinPrivateGroupToState(
      JoinPrivateGroup event) async* {
    if (event.accessCode == null || event.accessCode.isEmpty) {
      yield PrivateGroupJoinFailed(message: 'You must enter an access code.');
    } else {
      yield PrivateGroupLoading();

      try {
        final response = await _groupRepository.joinGroup(event.id,
            accessCode: event.accessCode);

        if (response.status == ApiResponseStatus.success) {
          yield PrivateGroupJoined(id: event.id);
        } else if (response.status == ApiResponseStatus.failure) {
          yield PrivateGroupJoinFailed(message: response.message);
        } else {
          throw Exception(response.message);
        }
      } catch (error) {
        print('Error joining group: $error');
        yield PrivateGroupJoinFailed(message: 'Unable to join group.');
      }
    }
  }
}
