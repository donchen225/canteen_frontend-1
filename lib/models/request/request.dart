import 'package:canteen_frontend/models/request/request_entity.dart';
import 'package:canteen_frontend/models/request/status.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:meta/meta.dart';

@immutable
class Request {
  final String id;
  final String senderId;
  final String receiverId;
  final String skill;
  final String comment;
  final RequestStatus status;
  final DateTime createdOn;

  Request({
    @required this.senderId,
    @required this.receiverId,
    @required this.status,
    this.createdOn,
    this.id,
    this.skill,
    this.comment,
  });

  static Request create({String senderId, String receiverId}) {
    return Request(
      senderId: senderId,
      receiverId: receiverId,
      status: RequestStatus.initialized,
    );
  }

  static Request fromEntity(RequestEntity entity) {
    return Request(
        id: entity.id,
        senderId: entity.senderId,
        receiverId: entity.receiverId,
        skill: entity.skill,
        comment: entity.comment,
        status: RequestStatus.values[entity.status],
        createdOn: entity.createdOn);
  }

  RequestEntity toEntity() {
    return RequestEntity(
      id: id,
      senderId: senderId,
      receiverId: receiverId,
      skill: skill,
      comment: comment,
      status: status.index,
      createdOn: createdOn,
    );
  }
}

class DetailedRequest extends Request {
  final User sender;

  DetailedRequest(
      {@required id,
      @required senderId,
      @required receiverId,
      @required skill,
      @required comment,
      @required status,
      @required createdOn,
      @required this.sender})
      : super(
            id: id,
            senderId: senderId,
            receiverId: receiverId,
            skill: skill,
            comment: comment,
            status: status,
            createdOn: createdOn);

  static DetailedRequest fromRequest(Request request, User sender) {
    return DetailedRequest(
        id: request.id,
        senderId: request.senderId,
        receiverId: request.receiverId,
        skill: request.skill,
        comment: request.comment,
        status: request.status,
        createdOn: request.createdOn,
        sender: sender);
  }
}
