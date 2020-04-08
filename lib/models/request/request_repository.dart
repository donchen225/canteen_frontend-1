import 'package:canteen_frontend/models/request/request.dart';
import 'package:canteen_frontend/models/request/request_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RequestRepository {
  final requestCollection = Firestore.instance.collection('request');
  List<Request> _requests = [];
  List<DetailedRequest> _detailedRequests = [];

  RequestRepository();

  Future<void> addRequest(Request request) {
    return Firestore.instance.runTransaction((Transaction tx) async {
      tx.set(requestCollection.document(request.id),
          request.toEntity().toDocument());
    });
  }

  Future<void> deleteRequest(Request request) async {
    return Firestore.instance.runTransaction((Transaction tx) async {
      tx.delete(requestCollection.document(request.id));
    });
  }

  List<DetailedRequest> currentRequests() {
    return _detailedRequests;
  }

  Future<void> saveDetailedRequest(DetailedRequest request) async {
    _detailedRequests.add(request);
  }

  Stream<List<Request>> getAllRequests(String userId) {
    return requestCollection
        .where('receiver', isEqualTo: userId)
        .where('status', isEqualTo: 0)
        .snapshots()
        .map((snapshot) {
      snapshot.documentChanges.forEach((doc) => _processRequests(doc.type,
          Request.fromEntity(RequestEntity.fromSnapshot(doc.document))));
      return _requests;
    });
  }

  void _processRequests(DocumentChangeType type, Request newRequest) {
    if (type == DocumentChangeType.added) {
      _requests.insert(0, newRequest);
    } else if (type == DocumentChangeType.modified) {
      _requests.removeWhere((request) => request.id == newRequest.id);
      _requests.insert(0, newRequest);
    } else if (type == DocumentChangeType.removed) {
      _requests.removeWhere((request) => request.id == newRequest.id);
    }
  }
}
