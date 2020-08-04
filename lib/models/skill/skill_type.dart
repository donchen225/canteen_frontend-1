import 'package:flutter/foundation.dart';

enum SkillType {
  request,
  offer,
}

extension SkillTypeExtension on SkillType {
  String get name => describeEnum(this);
}
