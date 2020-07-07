import 'dart:async';

import 'package:canteen_frontend/models/comment/comment.dart';
import 'package:canteen_frontend/models/comment/comment_entity.dart';
import 'package:canteen_frontend/models/like/like.dart';
import 'package:canteen_frontend/models/post/post.dart';
import 'package:canteen_frontend/models/post/post_entity.dart';
import 'package:canteen_frontend/utils/shared_preferences_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:tuple/tuple.dart';

class PostRepository {
  final groupCollection = Firestore.instance.collection('groups');
  final postsCollection = 'posts';
  final commentsCollection = 'comments';
  final likesCollection = 'likes';

  PostRepository();

  Future<void> addPost(String groupId, Post post) async {
    return Firestore.instance.runTransaction((Transaction tx) async {
      await tx.set(
        groupCollection
            .document(groupId)
            .collection(postsCollection)
            .document(),
        post.toEntity().toDocument(),
      );
    });
  }

  Future<void> addComment(
      String groupId, String postId, Comment comment) async {
    return Firestore.instance.runTransaction((Transaction tx) async {
      await tx.set(
        groupCollection
            .document(groupId)
            .collection(postsCollection)
            .document(postId)
            .collection(commentsCollection)
            .document(),
        comment.toEntity().toDocument(),
      );
    });
  }

  Future<void> addLike(String groupId, String postId, Like like) async {
    final userId =
        CachedSharedPreferences.getString(PreferenceConstants.userId);

    final likeRef = groupCollection
        .document(groupId)
        .collection(postsCollection)
        .document(postId)
        .collection(likesCollection)
        .document(userId);

    return likeRef.get().then((docSnapshot) {
      if (!docSnapshot.exists) {
        likeRef.setData(like.toEntity().toDocument());
      }
    }).catchError((error) {
      print('Error adding like: $error');
    });
  }

  Future<void> deleteLike(String groupId, String postId) async {
    final userId =
        CachedSharedPreferences.getString(PreferenceConstants.userId);

    return groupCollection
        .document(groupId)
        .collection(postsCollection)
        .document(postId)
        .collection(likesCollection)
        .document(userId)
        .delete()
        .catchError((error) {
      print('Error deleting like: $error');
    });
    ;
  }

  Future<bool> checkLike(String groupId, String postId) async {
    final userId =
        CachedSharedPreferences.getString(PreferenceConstants.userId);

    return groupCollection
        .document(groupId)
        .collection(postsCollection)
        .document(postId)
        .collection(likesCollection)
        .document(userId)
        .get()
        .then((snapshot) {
      return snapshot.exists;
    });
  }

  Stream<List<Tuple2<DocumentChangeType, Comment>>> getComments(
      String groupId, String postId,
      {DateTime lastFetch}) {
    final collection = groupCollection
        .document(groupId)
        .collection(postsCollection)
        .document(postId)
        .collection(commentsCollection);

    // Only query comments since last fetch
    final query = lastFetch == null
        ? collection.orderBy("last_updated", descending: true)
        : collection
            .where("last_updated",
                isGreaterThan: lastFetch.add(Duration(
                    microseconds:
                        1))) // TODO: REMOVE THIS HACK, WHY IS THIS NOT WORKING ON FIRESTORE?????
            .orderBy("last_updated", descending: true);

    return query.snapshots().map((snapshot) {
      return snapshot.documentChanges
          .map((doc) => Tuple2<DocumentChangeType, Comment>(doc.type,
              Comment.fromEntity(CommentEntity.fromSnapshot(doc.document))))
          .toList();
    });
  }

  Future<Tuple2<List<Post>, DocumentSnapshot>> getPosts(String groupId,
      {DocumentSnapshot startAfterDocument}) {
    Query query = groupCollection
        .document(groupId)
        .collection(postsCollection)
        .orderBy("last_updated", descending: true)
        .limit(25);

    if (startAfterDocument != null && startAfterDocument.exists) {
      query = query.startAfterDocument(startAfterDocument);
    }

    return query.getDocuments().then((querySnapshot) {
      return Tuple2<List<Post>, DocumentSnapshot>(
          querySnapshot.documents
              .map((doc) => Post.fromEntity(PostEntity.fromSnapshot(doc)))
              .toList(),
          querySnapshot.documents.isNotEmpty
              ? querySnapshot.documents.last
              : null);
    }).catchError((error) {
      print('Error fetching posts: $error');
      throw error;
    });
  }

  Future<Post> getPost(String postId, String groupId) {
    return groupCollection
        .document(groupId)
        .collection(postsCollection)
        .document(postId)
        .get()
        .then((docSnapshot) {
      return Post.fromEntity(PostEntity.fromSnapshot(docSnapshot));
    }).catchError((error) {
      print('Error fetching posts: $error');
      throw error;
    });
  }
}
