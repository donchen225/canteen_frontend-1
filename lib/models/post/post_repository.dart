import 'dart:async';

import 'package:canteen_frontend/models/post/post.dart';
import 'package:canteen_frontend/models/post/post_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:tuple/tuple.dart';

class PostRepository {
  final postCollection = Firestore.instance.collection('posts');
  List<DetailedPost> _detailedPosts = [];

  PostRepository();

  List<DetailedPost> currentDetailedPosts() {
    return _detailedPosts;
  }

  void clearPosts() {
    _detailedPosts = [];
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

  void updateDetailedPost(DocumentChangeType type, Post post) {
    if (type == DocumentChangeType.modified) {
      _detailedPosts.removeWhere((p) => p.id == post.id);
      _detailedPosts.insert(0, post);
    } else if (type == DocumentChangeType.removed) {
      _detailedPosts.removeWhere((p) => p.id == post.id);
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
