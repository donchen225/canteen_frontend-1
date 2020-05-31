import 'dart:async';

import 'package:canteen_frontend/models/group/group.dart';
import 'package:canteen_frontend/models/group/group_entity.dart';
import 'package:canteen_frontend/models/message/message.dart';
import 'package:canteen_frontend/models/message/message_entity.dart';
import 'package:canteen_frontend/utils/shared_preferences_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:canteen_frontend/models/match/match.dart';
import 'package:canteen_frontend/models/match/match_entity.dart';
import 'package:tuple/tuple.dart';

class GroupRepository {
  final groupCollection = Firestore.instance.collection('groups');
  static const String posts = "posts";

  GroupRepository();

  // TODO: remove this function
  Future<List<Group>> getAllGroups() async {
    return groupCollection.limit(10).getDocuments().then((querySnapshot) =>
        querySnapshot.documents
            .map((documentSnapshot) =>
                Group.fromEntity(GroupEntity.fromSnapshot(documentSnapshot)))
            .toList());
  }
}
