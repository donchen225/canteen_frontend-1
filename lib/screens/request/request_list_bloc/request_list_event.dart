import 'package:canteen_frontend/models/request/request.dart';
import 'package:equatable/equatable.dart';

abstract class RequestListEvent extends Equatable {
  const RequestListEvent();

  @override
  List<Object> get props => [];
}

class LoadRequestList extends RequestListEvent {
  final List<DetailedRequest> requestList;

  const LoadRequestList(this.requestList);

  @override
  List<Object> get props => requestList;

  @override
  String toString() => 'LoadRequestList { requestList: $requestList }';
}

class UpdateRequestList extends RequestListEvent {
  final List<Request> requestList;

  const UpdateRequestList(this.requestList);

  @override
  List<Object> get props => requestList;

  @override
  String toString() => 'UpdateRequestList { requestList: $requestList }';
}

class ClearRequestList extends RequestListEvent {}
