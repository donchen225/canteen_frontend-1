import 'package:canteen_frontend/models/discover/popular_user.dart';
import 'package:canteen_frontend/models/discover/popular_user_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DiscoverRepository {
  final discoverCollection = Firestore.instance.collection('discover');

  DiscoverRepository();

  Future<List<PopularUser>> getPopularUsers() async {
    final discoverId = await discoverCollection
        .where("active", isEqualTo: true)
        .getDocuments()
        .then((querySnapshot) {
      if (querySnapshot.documents.isEmpty) {
        return null;
      }
      return querySnapshot.documents.first.documentID;
    }).catchError((error) {
      print('Error loading discover document: $error');
      return null;
    });

    if (discoverId == null) {
      return null;
    }

    return discoverCollection
        .document(discoverId)
        .collection('users')
        .getDocuments()
        .then((querySnapshot) => querySnapshot.documents
            .map((documentSnapshot) => PopularUser.fromEntity(
                PopularUserEntity.fromSnapshot(documentSnapshot)))
            .toList())
        .catchError((error) {
      print('Error loading discover data: $error');
      return null;
    });
  }
}
