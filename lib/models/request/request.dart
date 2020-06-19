import 'package:canteen_frontend/models/request/request_entity.dart';
import 'package:canteen_frontend/models/request/status.dart';
import 'package:canteen_frontend/models/skill/skill.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:meta/meta.dart';

@immutable
class Request {
  final String id;
  final String senderId;
  final String receiverId;
  final String skill;
  final double price;
  final int duration;
  final String comment;
  final DateTime time;
  final RequestStatus status;
  final DateTime createdOn;

  Request({
    @required this.receiverId,
    @required this.status,
    this.senderId,
    this.createdOn,
    this.id,
    this.skill,
    this.price,
    this.duration,
    this.comment,
    this.time,
  });

  static Request fromEntity(RequestEntity entity) {
    return Request(
        id: entity.id,
        senderId: entity.senderId,
        receiverId: entity.receiverId,
        skill: entity.skill,
        price: entity.price,
        duration: entity.duration,
        comment: entity.comment,
        time: entity.time,
        status: RequestStatus.values[entity.status],
        createdOn: entity.createdOn);
  }

  RequestEntity toEntity() {
    return RequestEntity(
      id: id,
      senderId: senderId,
      receiverId: receiverId,
      skill: skill,
      price: price,
      duration: duration,
      comment: comment,
      time: time,
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
      @required price,
      @required duration,
      @required time,
      @required status,
      @required createdOn,
      @required this.sender})
      : super(
            id: id,
            senderId: senderId,
            receiverId: receiverId,
            skill: skill,
            price: price,
            duration: duration,
            comment: comment,
            time: time,
            status: status,
            createdOn: createdOn);

  static DetailedRequest fromRequest(Request request, User sender) {
    return DetailedRequest(
        id: request.id,
        senderId: request.senderId,
        receiverId: request.receiverId,
        skill: request.skill,
        price: request.price,
        duration: request.duration,
        comment: request.comment,
        time: request.time,
        status: request.status,
        createdOn: request.createdOn,
        sender: sender);
  }
}
