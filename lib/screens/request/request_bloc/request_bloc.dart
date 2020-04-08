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
      yield* _mapLoadRequestsToState(event);
    } else if (event is AddRequest) {
      yield* _mapAddRequestToState(event);
    } else if (event is RequestsUpdated) {
      yield* _mapRequestsUpdatedToState(event);
    } else if (event is AcceptRequest) {
      yield* _mapAcceptRequestToState(event);
    } else if (event is DeclineRequest) {
      yield* _mapDeclineRequestToState(event);
    }
  }

  Stream<RequestState> _mapLoadRequestsToState(LoadRequests event) async* {
    _requestSubscription?.cancel();
    _requestSubscription =
        _requestRepository.getAllRequests(event.userId).listen((requests) {
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
    await _requestRepository.declineRequest(event.request);
    yield RequestsLoaded(_requestRepository.currentRequests());
  }
}
