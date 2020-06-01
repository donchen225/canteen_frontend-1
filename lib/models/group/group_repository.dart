import 'dart:async';

import 'package:canteen_frontend/models/group/group.dart';
import 'package:canteen_frontend/models/group/group_entity.dart';
import 'package:canteen_frontend/models/group/user_group.dart';
import 'package:canteen_frontend/models/group/user_group_entity.dart';
import 'package:canteen_frontend/utils/shared_preferences_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GroupRepository {
  final userCollection = Firestore.instance.collection('users');
  final groupCollection = Firestore.instance.collection('groups');
  static const String groups = "groups";
  static const String posts = "posts";

  GroupRepository();

  Future<List<UserGroup>> getUserGroups() async {
    final userId =
        CachedSharedPreferences.getString(PreferenceConstants.userId);

    return userCollection
        .document(userId)
        .collection(groups)
        .getDocuments()
        .then((querySnapshot) {
      return querySnapshot.documents
          .map((snapshot) =>
              UserGroup.fromEntity(UserGroupEntity.fromSnapshot(snapshot)))
          .toList();
    });
  }

  Future<Group> getGroup(String groupId) async {
    return groupCollection.document(groupId).get().then((documentSnapshot) {
      if (!(documentSnapshot.exists)) {
        return null;
      }
      return Group.fromEntity(GroupEntity.fromSnapshot(documentSnapshot));
    });
  }

  // TODO: remove this function
  Future<List<Group>> getAllGroups() async {
    return groupCollection.limit(10).getDocuments().then((querySnapshot) =>
        querySnapshot.documents
            .map((documentSnapshot) =>
                Group.fromEntity(GroupEntity.fromSnapshot(documentSnapshot)))
            .toList());
  }
}
