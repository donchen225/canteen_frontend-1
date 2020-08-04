import 'dart:async';
import 'package:canteen_frontend/models/request/request.dart';
import 'package:canteen_frontend/models/request/request_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import 'package:canteen_frontend/models/user/user_repository.dart';
import 'package:canteen_frontend/screens/request/request_bloc/bloc.dart';
import 'package:canteen_frontend/screens/request/request_list_bloc/bloc.dart';

class RequestListBloc extends Bloc<RequestListEvent, RequestListState> {
  final RequestBloc _requestBloc;
  final UserRepository _userRepository;
  final RequestRepository _requestRepository;
  StreamSubscription _requestSubscription;

  RequestListBloc({
    @required RequestBloc requestBloc,
    @required UserRepository userRepository,
    @required RequestRepository requestRepository,
  })  : assert(requestBloc != null),
        assert(userRepository != null),
        assert(requestRepository != null),
        _requestBloc = requestBloc,
        _userRepository = userRepository,
        _requestRepository = requestRepository {
    _requestSubscription = _requestBloc.listen((requestState) {
      if (requestState is RequestsLoaded) {
        print('REQUESTS LOADED: ${requestState.requestList}');
        add(LoadRequestList(requestState.requestList));
      }
    });
  }

  @override
  RequestListState get initialState => RequestListUnauthenticated();

  @override
  Stream<RequestListState> mapEventToState(RequestListEvent event) async* {
    if (event is UpdateRequestList) {
      yield* _mapUpdateRequestListToState(event);
    } else if (event is LoadRequestList) {
      yield* _mapLoadRequestListToState(event);
    } else if (event is ClearRequestList) {
      yield* _mapClearRequestListToState();
    }
  }

  Stream<RequestListState> _mapUpdateRequestListToState(
      UpdateRequestList event) async* {
    yield DetailedRequestListLoaded(
        await _getDetailedRequestList(event.requestList));
  }

  Stream<RequestListState> _mapLoadRequestListToState(
      LoadRequestList event) async* {
    final updatedList = List.of(event.requestList);

    yield DetailedRequestListLoaded(updatedList);
  }

  Stream<RequestListState> _mapClearRequestListToState() async* {
    yield RequestListUnauthenticated();
  }

  Future<List<DetailedRequest>> _getDetailedRequestList(
      List<Request> requestList) async {
    return _requestRepository.currentDetailedRequests();
  }

  @override
  Future<void> close() {
    _requestSubscription?.cancel();
    return super.close();
  }
}
