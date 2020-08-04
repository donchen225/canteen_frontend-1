import 'package:canteen_frontend/models/request/request_entity.dart';
import 'package:canteen_frontend/models/request/status.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Request extends Equatable {
  final String id;
  final String senderId;
  final String receiverId;
  final String referralId;
  final String skill;
  final double price;
  final int duration;
  final String type;
  final String comment;
  final String referralComment;
  final DateTime time;
  final RequestStatus status;
  final DateTime createdOn;

  Request({
    @required this.receiverId,
    @required this.status,
    this.referralId,
    this.senderId,
    this.createdOn,
    this.id,
    this.skill,
    this.price,
    this.duration,
    this.type,
    this.comment,
    this.referralComment,
    this.time,
  });

  @override
  List<Object> get props => [
        id,
        senderId,
        receiverId,
        referralId,
        skill,
        price,
        duration,
        type,
        comment,
        referralComment,
        status,
        createdOn,
      ];

  static Request fromEntity(RequestEntity entity) {
    return Request(
        id: entity.id,
        senderId: entity.senderId,
        receiverId: entity.receiverId,
        referralId: entity.receiverId,
        skill: entity.skill,
        price: entity.price,
        duration: entity.duration,
        comment: entity.comment,
        referralComment: entity.referralComment,
        type: entity.type,
        time: entity.time,
        status: RequestStatusGenerator.parse(entity.status),
        createdOn: entity.createdOn);
  }
}

class DetailedRequest extends Request with EquatableMixin {
  final User sender;

  DetailedRequest({
    @required id,
    @required senderId,
    @required receiverId,
    @required referralId,
    @required skill,
    @required comment,
    @required referralComment,
    @required price,
    @required duration,
    @required time,
    @required type,
    @required status,
    @required createdOn,
    @required this.sender,
  }) : super(
            id: id,
            senderId: senderId,
            receiverId: receiverId,
            referralId: referralId,
            skill: skill,
            price: price,
            duration: duration,
            comment: comment,
            referralComment: referralComment,
            time: time,
            type: type,
            status: status,
            createdOn: createdOn);

  @override
  List<Object> get props => [
        id,
        senderId,
        receiverId,
        referralId,
        skill,
        price,
        duration,
        type,
        comment,
        referralComment,
        status,
        createdOn,
        sender,
      ];

  @override
  String toString() {
    return 'DetailedRequest { id: $id, senderId: $senderId, receiverId: $receiverId, referralId: $referralId, skill: $skill, price: $price, duration: $duration, type: $type, comment: $comment, referralComment: $referralComment, status: $status, createdOn: $createdOn, sender: $sender }';
  }

  static DetailedRequest fromRequest(
    Request request, {
    @required User sender,
  }) {
    return DetailedRequest(
      id: request.id,
      senderId: request.senderId,
      receiverId: request.receiverId,
      referralId: request.receiverId,
      skill: request.skill,
      price: request.price,
      duration: request.duration,
      comment: request.comment,
      referralComment: request.referralComment,
      time: request.time,
      type: request.type,
      status: request.status,
      createdOn: request.createdOn,
      sender: sender,
    );
  }
}

class Referral extends DetailedRequest with EquatableMixin {
  final User receiver;

  Referral(
      {@required id,
      @required senderId,
      @required receiverId,
      @required referralId,
      @required skill,
      @required comment,
      @required referralComment,
      @required price,
      @required duration,
      @required time,
      @required type,
      @required status,
      @required createdOn,
      @required sender,
      this.receiver})
      : super(
          id: id,
          senderId: senderId,
          receiverId: receiverId,
          referralId: referralId,
          skill: skill,
          price: price,
          duration: duration,
          comment: comment,
          referralComment: referralComment,
          time: time,
          type: type,
          status: status,
          createdOn: createdOn,
          sender: sender,
        );

  @override
  List<Object> get props => [
        id,
        senderId,
        receiverId,
        referralId,
        skill,
        price,
        duration,
        type,
        comment,
        referralComment,
        status,
        createdOn,
        sender,
        receiver,
      ];

  @override
  String toString() {
    return 'Referral { id: $id, senderId: $senderId, receiverId: $receiverId, referralId: $referralId, skill: $skill, price: $price, duration: $duration, type: $type, comment: $comment, referralComment: $referralComment, status: $status, createdOn: $createdOn, sender: $sender, receiver: $receiver }';
  }

  static Referral fromRequest(
    Request request, {
    @required User sender,
    @required User receiver,
  }) {
    return Referral(
      id: request.id,
      senderId: request.senderId,
      receiverId: request.receiverId,
      referralId: request.receiverId,
      skill: request.skill,
      price: request.price,
      duration: request.duration,
      comment: request.comment,
      referralComment: request.referralComment,
      time: request.time,
      type: request.type,
      status: request.status,
      createdOn: request.createdOn,
      sender: sender,
      receiver: receiver,
    );
  }
}

class ReferredRequest extends DetailedRequest with EquatableMixin {
  final User referral;

  ReferredRequest({
    @required id,
    @required senderId,
    @required receiverId,
    @required referralId,
    @required skill,
    @required comment,
    @required referralComment,
    @required price,
    @required duration,
    @required time,
    @required type,
    @required status,
    @required createdOn,
    @required sender,
    this.referral,
  }) : super(
            id: id,
            senderId: senderId,
            receiverId: receiverId,
            referralId: referralId,
            skill: skill,
            price: price,
            duration: duration,
            comment: comment,
            referralComment: referralComment,
            time: time,
            type: type,
            status: status,
            createdOn: createdOn,
            sender: sender);

  @override
  List<Object> get props => [
        id,
        senderId,
        receiverId,
        referralId,
        skill,
        price,
        duration,
        type,
        comment,
        referralComment,
        status,
        createdOn,
        sender,
        referral,
      ];

  @override
  String toString() {
    return 'ReferredRequest { id: $id, senderId: $senderId, receiverId: $receiverId, referralId: $referralId, skill: $skill, price: $price, duration: $duration, type: $type, comment: $comment, referralComment: $referralComment, status: $status, createdOn: $createdOn, sender: $sender, referral: $referral }';
  }

  static ReferredRequest fromRequest(
    Request request, {
    @required User sender,
    @required User referral,
  }) {
    return ReferredRequest(
      id: request.id,
      senderId: request.senderId,
      receiverId: request.receiverId,
      referralId: request.receiverId,
      skill: request.skill,
      price: request.price,
      duration: request.duration,
      comment: request.comment,
      referralComment: request.referralComment,
      time: request.time,
      type: request.type,
      status: request.status,
      createdOn: request.createdOn,
      sender: sender,
      referral: referral,
    );
  }
}
