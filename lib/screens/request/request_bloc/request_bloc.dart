import 'dart:async';
import 'package:canteen_frontend/models/request/request_repository.dart';
import 'package:meta/meta.dart';

import 'package:canteen_frontend/screens/request/request_bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RequestBloc extends Bloc<RequestEvent, RequestState> {
  final RequestRepository _requestRepository;
  StreamSubscription _requestSubscription;

  RequestBloc({@required RequestRepository requestRepository})
      : assert(requestRepository != null),
        _requestRepository = requestRepository;

  @override
  RequestState get initialState => RequestsLoading();

  @override
  Stream<RequestState> mapEventToState(RequestEvent event) async* {
    if (event is LoadRequests) {
      yield* _mapLoadRequestsToState();
    } else if (event is AddRequest) {
      yield* _mapAddRequestToState(event);
    } else if (event is RequestsUpdated) {
      yield* _mapRequestsUpdatedToState(event);
    } else if (event is AcceptRequest) {
      yield* _mapAcceptRequestToState(event);
    } else if (event is DeclineRequest) {
      yield* _mapDeclineRequestToState(event);
    } else if (event is ClearRequests) {
      yield* _mapClearRequestsToState();
    }
  }

  Stream<RequestState> _mapLoadRequestsToState() async* {
    _requestSubscription?.cancel();
    _requestSubscription =
        _requestRepository.getAllRequests().listen((requests) {
      print('RECEIVING REQUESTS FROM FIRESTORE');
      add(RequestsUpdated(requests));
    });
  }

  Stream<RequestState> _mapAddRequestToState(AddRequest event) async* {
    _requestRepository.addRequest(event.request);
  }

  Stream<RequestState> _mapRequestsUpdatedToState(
      RequestsUpdated event) async* {
    yield RequestsLoading();
    yield RequestsLoaded(event.requests);
  }

  Stream<RequestState> _mapAcceptRequestToState(AcceptRequest event) async* {
    await _requestRepository.acceptRequest(event.request);
    yield RequestsLoaded(_requestRepository.currentRequests());
  }

  Stream<RequestState> _mapDeclineRequestToState(DeclineRequest event) async* {
    await _requestRepository.declineRequest(event.requestId);
    yield RequestsLoaded(_requestRepository.currentRequests());
  }

  Stream<RequestState> _mapClearRequestsToState() async* {
    _requestRepository.clearRequests();
    _requestSubscription?.cancel();
    yield ReqeustsCleared();
  }

  @override
  Future<void> close() {
    _requestSubscription?.cancel();
    return super.close();
  }
}
