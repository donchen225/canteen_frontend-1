import 'dart:async';
import 'package:canteen_frontend/models/api_response/api_response_status.dart';
import 'package:canteen_frontend/models/group/group_repository.dart';
import 'package:canteen_frontend/models/request/create_request_payload.dart';
import 'package:canteen_frontend/models/request/request_repository.dart';
import 'package:canteen_frontend/screens/request/send_request_dialog/bloc/send_request_event.dart';
import 'package:canteen_frontend/screens/request/send_request_dialog/bloc/send_request_state.dart';
import 'package:meta/meta.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class SendRequestBloc extends Bloc<SendRequestEvent, SendRequestState> {
  final RequestRepository _requestRepository;

  SendRequestBloc({
    @required RequestRepository requestRepository,
  })  : assert(requestRepository != null),
        _requestRepository = requestRepository;

  @override
  SendRequestState get initialState => RequestSending();

  @override
  Stream<SendRequestState> mapEventToState(
    SendRequestEvent event,
  ) async* {
    if (event is SendRequest) {
      yield* _mapSendRequestToState(event);
    }
  }

  Stream<SendRequestState> _mapSendRequestToState(SendRequest event) async* {
    yield RequestSending();

    try {
      final payload = CreateRequestPayload(
        receiverId: event.receiverId,
        comment: event.comment,
        index: event.index,
        type: event.type,
        time: event.time != null ? event.time.toUtc() : event.time,
      );

      final response = await _requestRepository.addRequest(payload);

      if (response.status == ApiResponseStatus.success) {
        yield RequestSent(message: response.message);
      } else if (response.status == ApiResponseStatus.failure) {
        yield RequestFailed(message: response.message);
      } else {
        throw Exception(response.message);
      }
    } catch (error) {
      print('Error sending request: $error');
      yield RequestFailed(message: 'Unable to send request.');
    }
  }
}
