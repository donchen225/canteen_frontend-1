import 'dart:async';

import 'package:canteen_frontend/models/api_response/api_response.dart';
import 'package:canteen_frontend/models/group/group.dart';
import 'package:canteen_frontend/models/group/group_entity.dart';
import 'package:canteen_frontend/models/group/group_member.dart';
import 'package:canteen_frontend/models/group/group_member_entity.dart';
import 'package:canteen_frontend/models/group/user_group.dart';
import 'package:canteen_frontend/models/group/user_group_entity.dart';
import 'package:canteen_frontend/utils/app_config.dart';
import 'package:canteen_frontend/utils/cloud_functions.dart';
import 'package:canteen_frontend/utils/shared_preferences_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GroupRepository {
  final userCollection = Firestore.instance.collection('users');
  final groupCollection = Firestore.instance.collection('groups');
  static const String groups = "groups";
  static const String posts = "posts";
  static const String members = "members";

  GroupRepository();

  Future<ApiResponse> joinGroup(String groupId, {String accessCode}) async {
    return CloudFunctionManager.joinGroup.call({
      "group_id": groupId,
      "access_code": accessCode,
    }).then((result) {
      if (result.data == null) {
        throw Exception("No data received from server.");
      }
      return ApiResponse.fromHttpResult(result);
    });
  }

  Future<List<UserGroup>> getUserGroups() async {
    final userId =
        CachedSharedPreferences.getString(PreferenceConstants.userId);

    return userCollection
        .document(userId)
        .collection(groups)
        .orderBy('joined_on', descending: false)
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

  Future<List<GroupMember>> getGroupMembers(String groupId) async {
    return groupCollection
        .document(groupId)
        .collection(members)
        .getDocuments()
        .then((querySnapshot) {
      return querySnapshot.documents
          .map((document) =>
              GroupMember.fromEntity(GroupMemberEntity.fromSnapshot(document)))
          .toList();
    });
  }

  // TODO: remove this function
  Future<List<Group>> getAllGroups({bool ignoreMainGroup = true}) async {
    return groupCollection.limit(10).getDocuments().then((querySnapshot) {
      final docs = ignoreMainGroup
          ? (querySnapshot.documents
            ..removeWhere((doc) => doc.documentID == AppConfig.defaultGroupId))
          : querySnapshot.documents;

      return docs
          .map((documentSnapshot) =>
              Group.fromEntity(GroupEntity.fromSnapshot(documentSnapshot)))
          .toList();
    });
  }
}
