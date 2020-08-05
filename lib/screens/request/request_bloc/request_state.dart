import 'package:canteen_frontend/models/request/request.dart';
import 'package:equatable/equatable.dart';

abstract class RequestState extends Equatable {
  const RequestState();

  @override
  List<Object> get props => [];
}

class RequestsUnauthenticated extends RequestState {}

class RequestsLoading extends RequestState {}

class RequestsLoaded extends RequestState {
  final List<DetailedRequest> requestList;

  const RequestsLoaded([this.requestList = const []]);

  @override
  List<Object> get props => [requestList];

  @override
  String toString() {
    return 'RequestsLoaded { requestList: $requestList }';
  }
}
