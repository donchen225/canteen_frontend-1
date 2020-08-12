import 'package:flutter/foundation.dart';

enum RequestStatus {
  sentToReceiver, // 0
  receiverAccepted, // 1
  receiverDeclined, // 2
  reported, // 3
  sentToReferral, // 10
  refferalDeclined, // 12
}

extension SkillTypeExtension on RequestStatus {
  String get name => describeEnum(this);
}

class RequestStatusGenerator {
  static RequestStatus parse(int status) {
    switch (status) {
      case 0:
        return RequestStatus.sentToReceiver;
      case 1:
        return RequestStatus.receiverAccepted;
      case 2:
        return RequestStatus.receiverDeclined;
      case 3:
        return RequestStatus.reported;
      case 10:
        return RequestStatus.sentToReferral;
      case 12:
        return RequestStatus.refferalDeclined;
      default:
        throw RangeError("Invalid value for RequestStatus: $status");
    }
  }
}
