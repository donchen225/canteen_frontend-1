import 'package:canteen_frontend/models/request/request_entity.dart';
import 'package:canteen_frontend/models/request/status.dart';
import 'package:meta/meta.dart';

@immutable
class Request {
  final String id;
  final String sender;
  final String receiver;
  final String skill;
  final String comment;
  final RequestStatus status;

  Request({
    @required this.sender,
    @required this.receiver,
    @required this.status,
    this.id,
    this.skill,
    this.comment,
  });

  static Request fromEntity(RequestEntity entity) {
    return Request(
        id: entity.id,
        sender: entity.sender,
        receiver: entity.receiver,
        skill: entity.skill,
        comment: entity.comment,
        status: RequestStatus.values[entity.status]);
  }

  RequestEntity toEntity() {
    return RequestEntity(
      id: id,
      sender: sender,
      receiver: receiver,
      skill: skill,
      comment: comment,
      status: status.index,
    );
  }
}
