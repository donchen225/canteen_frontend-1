import 'package:canteen_frontend/models/request/request.dart';
import 'package:equatable/equatable.dart';

abstract class RequestState extends Equatable {
  const RequestState();

  @override
  List<Object> get props => [];
}

class RequestsLoading extends RequestState {}

class RequestsLoaded extends RequestState {
  final List<Request> requestList;

  const RequestsLoaded(this.requestList);

  @override
  List<Object> get props => [requestList];

  @override
  String toString() {
    return 'RequestsLoaded { requestList: $requestList }';
  }
}

// class DetailedRequestLoaded extends RequestState {
//   final List<DetailedRequest> requestList;

//   const DetailedRequestLoaded(this.requestList);

//   @override
//   List<Object> get props => [requestList];

//   @override
//   String toString() {
//     return 'DetailedRequestLoaded { requestList: $requestList }';
//   }
// }
