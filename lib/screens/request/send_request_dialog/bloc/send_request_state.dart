import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class SendRequestState extends Equatable {
  const SendRequestState();

  @override
  List<Object> get props => [];
}

class RequestSending extends SendRequestState {
  @override
  String toString() => 'RequestSending';
}

class RequestSent extends SendRequestState {
  final String message;

  RequestSent({@required this.message});

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'RequestSent { message: $message }';
}

class RequestFailed extends SendRequestState {
  final String message;

  RequestFailed({@required this.message});

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'RequestFailed { message: $message }';
}
