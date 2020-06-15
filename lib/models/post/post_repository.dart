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
  List<DetailedPost> _detailedPosts = [];
  Map<String, List<DetailedComment>> _detailedComments = {};

  PostRepository();

  List<DetailedPost> currentDetailedPosts() {
    return _detailedPosts;
  }

  List<DetailedComment> currentDetailedComments(String postId) {
    return _detailedComments[postId] ?? [];
  }

  void clearPosts() {
    _detailedPosts = [];
  }

  void clearComments() {
    _detailedComments = {};
  }

  void saveDetailedPost(DetailedPost post) {
    var idx = 0;
    while (idx < _detailedPosts.length) {
      if (post.lastUpdated.isAfter(_detailedPosts[idx].lastUpdated)) {
        break;
      }

      idx++;
    }
    _detailedPosts.insert(idx, post);
  }

  void saveDetailedComment(String postId, DetailedComment comment) {
    var idx = 0;

    if (_detailedComments[postId] == null) {
      _detailedComments[postId] = [];
    }

    final comments = _detailedComments[postId];
    while (idx < comments.length) {
      if (comment.lastUpdated.isAfter(comments[idx].lastUpdated)) {
        break;
      }

      idx++;
    }
    comments.insert(idx, comment);
  }

  void updateDetailedPost(DocumentChangeType type, Post post) {
    if (type == DocumentChangeType.modified) {
      _detailedPosts.removeWhere((p) => p.id == post.id);
      _detailedPosts.insert(0, post);
    } else if (type == DocumentChangeType.removed) {
      _detailedPosts.removeWhere((p) => p.id == post.id);
    }
  }

  void updateDetailedComment(
      String postId, DocumentChangeType type, Comment comment) {
    final comments = _detailedComments[postId];
    if (type == DocumentChangeType.modified) {
      comments.removeWhere((c) => c.id == comment.id);
      comments.insert(0, comment);
    } else if (type == DocumentChangeType.removed) {
      comments.removeWhere((c) => c.id == comment.id);
    }
  }

  Future<void> addPost(String groupId, Post post) async {
    print('ADD POST');
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

    final post = groupCollection
        .document(groupId)
        .collection(postsCollection)
        .document(postId);

    return Firestore.instance.runTransaction((Transaction tx) async {
      final userLike =
          await tx.get(post.collection(likesCollection).document(userId));

      if (!(userLike.exists)) {
        await tx.set(
          post.collection(likesCollection).document(userId),
          like.toEntity().toDocument(),
        );
      }
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
        .delete();
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
      String groupId, String postId) {
    final lastFetch = _detailedComments[postId]?.first?.lastUpdated ?? null;
    print('LAST FETCH: $lastFetch');
    print('GET COMMENTS: $postId');
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
}
