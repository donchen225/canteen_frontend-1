import 'package:canteen_frontend/models/request/request.dart';
import 'package:equatable/equatable.dart';

abstract class RequestEvent extends Equatable {
  const RequestEvent();
}

class LoadRequests extends RequestEvent {
  const LoadRequests();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'LoadRequests';
}

class RequestsUpdated extends RequestEvent {
  final List<Request> requests;

  const RequestsUpdated(this.requests);

  @override
  List<Object> get props => [requests];

  @override
  String toString() => 'RequestsUpdated { requests: $requests }';
}

class AddRequest extends RequestEvent {
  final String receiverId;
  final String comment;
  final int index;
  final String type;
  final DateTime time;

  const AddRequest(
      {this.receiverId, this.comment, this.index, this.type, this.time});

  @override
  List<Object> get props => [receiverId, comment, index, type, time];

  @override
  String toString() =>
      'AddRequest { receiverId: $receiverId, comment: $comment, index: $index, type: $type, time: $time }';
}

class UpdateRequest extends RequestEvent {
  final List<Request> requestList;

  const UpdateRequest(this.requestList);

  @override
  List<Object> get props => [requestList];

  @override
  String toString() => 'UpdateRequest { requestList: $requestList }';
}

class AcceptRequest extends RequestEvent {
  final String requestId;

  const AcceptRequest({this.requestId});

  @override
  List<Object> get props => [requestId];

  @override
  String toString() => 'AcceptRequest { requestId: $requestId }';
}

class DeclineRequest extends RequestEvent {
  final String requestId;

  const DeclineRequest({this.requestId});

  @override
  List<Object> get props => [requestId];

  @override
  String toString() => 'DeclineRequest { requestId: $requestId }';
}

class ClearRequests extends RequestEvent {
  const ClearRequests();

  @override
  List<Object> get props => null;

  @override
  String toString() => 'ClearRequests';
}
