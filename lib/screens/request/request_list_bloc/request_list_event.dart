import 'package:canteen_frontend/models/request/request.dart';
import 'package:equatable/equatable.dart';

abstract class RequestListEvent extends Equatable {
  const RequestListEvent();
}

class LoadRequestList extends RequestListEvent {
  const LoadRequestList();

  @override
  List<Object> get props => [];
}

class UpdateRequestList extends RequestListEvent {
  final List<Request> requestList;

  const UpdateRequestList(this.requestList);

  @override
  List<Object> get props => [requestList];

  @override
  String toString() => 'UpdateRequestList { requestList: $requestList }';
}

class InspectDetailedRequest extends RequestListEvent {
  final DetailedRequest request;

  const InspectDetailedRequest(this.request);

  @override
  List<Object> get props => [request];

  @override
  String toString() => 'InspectDetailedRequest { request: $request }';
}
