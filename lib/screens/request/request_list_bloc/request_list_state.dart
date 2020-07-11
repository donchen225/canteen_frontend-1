import 'package:canteen_frontend/models/request/request.dart';
import 'package:equatable/equatable.dart';

abstract class RequestListState extends Equatable {
  const RequestListState();

  @override
  List<Object> get props => [];
}

class RequestListLoading extends RequestListState {}

class RequestListLoaded extends RequestListState {
  final List<Request> requestList;

  const RequestListLoaded(this.requestList);

  @override
  List<Object> get props => [requestList];

  @override
  String toString() {
    return 'RequestListLoaded { requestList: $requestList }';
  }
}

class DetailedRequestListLoaded extends RequestListState {
  final List<DetailedRequest> requestList;

  const DetailedRequestListLoaded(this.requestList);

  @override
  List<Object> get props => [requestList];

  @override
  String toString() {
    return 'DetailedRequestListLoaded { requestList: $requestList }';
  }
}

class RequestListUnauthenticated extends RequestListState {}
