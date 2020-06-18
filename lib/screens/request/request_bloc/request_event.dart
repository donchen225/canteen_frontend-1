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
  final Request request;

  const AddRequest(this.request);

  @override
  List<Object> get props => [request];

  @override
  String toString() => 'AddRequest { request: $request }';
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
  final Request request;

  const AcceptRequest(this.request);

  @override
  List<Object> get props => [request];

  @override
  String toString() => 'AcceptRequest { request: $request }';
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
