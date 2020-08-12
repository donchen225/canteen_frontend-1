import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class PrivateGroupEvent extends Equatable {
  const PrivateGroupEvent();

  @override
  List<Object> get props => [];
}

class JoinPrivateGroup extends PrivateGroupEvent {
  final String id;
  final String accessCode;

  JoinPrivateGroup({@required this.id, @required this.accessCode});

  @override
  List<Object> get props => [id, accessCode];

  @override
  String toString() => 'JoinPrivateGroup { id: $id, accessCode: $accessCode }';
}
