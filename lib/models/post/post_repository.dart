import 'dart:async';

import 'package:canteen_frontend/models/comment/comment.dart';
import 'package:canteen_frontend/models/comment/comment_entity.dart';
import 'package:canteen_frontend/models/like/like.dart';
import 'package:canteen_frontend/models/post/post.dart';
import 'package:canteen_frontend/models/post/post_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:tuple/tuple.dart';

class PostRepository {
  final postCollection = Firestore.instance.collection('posts');
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

  Future<void> addPost(Post post) {
    return Firestore.instance.runTransaction((Transaction tx) async {
      tx.set(
        postCollection.document(),
        post.toEntity().toDocument(),
      );
    });
  }

  Future<void> addComment(String postId, Comment comment) {
    return Firestore.instance.runTransaction((Transaction tx) async {
      tx.set(
        postCollection
            .document(postId)
            .collection(commentsCollection)
            .document(),
        comment.toEntity().toDocument(),
      );

      tx.update(postCollection.document(postId),
          {"comment_count": FieldValue.increment(1)});
    });
  }

  Future<void> addLike(String postId, Like like) {
    return Firestore.instance.runTransaction((Transaction tx) async {
      tx.set(
        postCollection
            .document(postId)
            .collection(commentsCollection)
            .document(),
        like.toEntity().toDocument(),
      );

      tx.update(postCollection.document(postId),
          {"like_count": FieldValue.increment(1)});
    });
  }

  Stream<List<Tuple2<DocumentChangeType, Comment>>> getComments(String postId) {
    final lastFetch = _detailedComments[postId]?.first?.lastUpdated ?? null;

    final collection =
        postCollection.document(postId).collection(commentsCollection);

    // Only query comments since last fetch
    final query = lastFetch == null
        ? collection.orderBy("last_updated", descending: true)
        : collection
            .where("last_updated", isGreaterThan: lastFetch)
            .orderBy("last_updated", descending: true);

    return query.snapshots().map((snapshot) {
      return snapshot.documentChanges
          .map((doc) => Tuple2<DocumentChangeType, Comment>(doc.type,
              Comment.fromEntity(CommentEntity.fromSnapshot(doc.document))))
          .toList();
    });
  }

  Stream<List<Tuple2<DocumentChangeType, Post>>> getPosts() {
    return postCollection
        .orderBy("last_updated", descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.documentChanges
          .map((doc) => Tuple2<DocumentChangeType, Post>(
              doc.type, Post.fromEntity(PostEntity.fromSnapshot(doc.document))))
          .toList();
    });
  }
}
