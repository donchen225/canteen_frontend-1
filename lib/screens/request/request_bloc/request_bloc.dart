import 'dart:async';

import 'package:canteen_frontend/models/request/request.dart';
import 'package:canteen_frontend/models/request/request_repository.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/models/user/user_repository.dart';
import 'package:canteen_frontend/utils/shared_preferences_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

import 'package:canteen_frontend/screens/request/request_bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

class RequestBloc extends Bloc<RequestEvent, RequestState> {
  final UserRepository _userRepository;
  final RequestRepository _requestRepository;
  StreamSubscription _requestSubscription;
  List<Request> _requests = [];

  RequestBloc({
    @required RequestRepository requestRepository,
    @required UserRepository userRepository,
  })  : assert(requestRepository != null),
        assert(userRepository != null),
        _requestRepository = requestRepository,
        _userRepository = userRepository;

  @override
  RequestState get initialState => RequestsUnauthenticated();

  @override
  Stream<RequestState> mapEventToState(RequestEvent event) async* {
    if (event is LoadRequests) {
      yield* _mapLoadRequestsToState();
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

    final mergedStream = Rx.merge([
      _requestRepository.getAllRequests(),
      _requestRepository.getAllReferralRequests()
    ]);

    _requestSubscription = mergedStream.listen((requests) {
      add(RequestsUpdated(requests));
    });
  }

  Stream<RequestState> _mapRequestsUpdatedToState(
      RequestsUpdated event) async* {
    yield RequestsLoading();

    final userId =
        CachedSharedPreferences.getString(PreferenceConstants.userId);

    List<Future<User>> senderListFutures = [];
    List<Future<User>> receiverReferralListFutures = [];

    final requestList = event.requests;

    requestList.forEach((request) {
      if (request.item1 == DocumentChangeType.modified ||
          request.item1 == DocumentChangeType.added) {
        final sender = _userRepository.getUser(request.item2.senderId);
        senderListFutures.add(sender);

        if (request.item2.referralId != null &&
            request.item2.referralId.isNotEmpty) {
          if (request.item2.referralId == userId) {
            // Referral
            final receiver = _userRepository.getUser(request.item2.receiverId);
            receiverReferralListFutures.add(receiver);
          } else {
            // Referred request
            final referral = _userRepository.getUser(request.item2.referralId);
            receiverReferralListFutures.add(referral);
          }
        } else {
          receiverReferralListFutures.add(Future<User>.value(null));
        }
      } else {
        senderListFutures.add(Future<User>.value(null));
        receiverReferralListFutures.add(Future<User>.value(null));
      }
    });

    final senderList = await Future.wait(senderListFutures);
    final receiverReferralList = await Future.wait(receiverReferralListFutures);

    for (int i = 0; i < requestList.length; i++) {
      final sender = senderList[i];
      final receiverReferral = receiverReferralList[i];
      final request = requestList[i];

      var detailedRequest;
      if (request.item1 == DocumentChangeType.added ||
          request.item1 == DocumentChangeType.modified) {
        if (request.item2.referralId != null &&
            request.item2.referralId.isNotEmpty) {
          if (request.item2.referralId == userId) {
            detailedRequest = Referral.fromRequest(
              request.item2,
              sender: sender,
              receiver: receiverReferral,
            );
          } else {
            detailedRequest = ReferredRequest.fromRequest(
              request.item2,
              sender: sender,
              referral: receiverReferral,
            );
          }
        } else {
          detailedRequest = DetailedRequest.fromRequest(
            request.item2,
            sender: sender,
          );
        }

        _requestRepository.updateDetailedRequest(
            request.item1, detailedRequest);
      } else if (request.item1 == DocumentChangeType.removed) {
        _requestRepository.updateDetailedRequest(request.item1, request.item2);
      }
    }

    yield RequestsLoaded(_requestRepository.currentDetailedRequests());
  }

  Stream<RequestState> _mapAcceptRequestToState(AcceptRequest event) async* {
    await _requestRepository.acceptRequest(event.requestId);
    yield RequestsLoaded(_requestRepository.currentDetailedRequests());
  }

  Stream<RequestState> _mapDeclineRequestToState(DeclineRequest event) async* {
    await _requestRepository.declineRequest(event.requestId);
    yield RequestsLoaded(_requestRepository.currentDetailedRequests());
  }

  Stream<RequestState> _mapClearRequestsToState() async* {
    _requestRepository.clearRequests();
    _requestSubscription?.cancel();
    yield RequestsUnauthenticated();
  }

  @override
  Future<void> close() {
    _requestSubscription?.cancel();
    return super.close();
  }
}
