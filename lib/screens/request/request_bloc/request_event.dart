import 'package:canteen_frontend/models/request/request.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:tuple/tuple.dart';

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
  final List<Tuple2<DocumentChangeType, Request>> requests;

  const RequestsUpdated(this.requests);

  @override
  List<Object> get props => [requests];

  @override
  String toString() => 'RequestsUpdated { requests: $requests }';
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
