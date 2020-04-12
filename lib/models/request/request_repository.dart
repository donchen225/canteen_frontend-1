import 'package:canteen_frontend/models/request/request.dart';
import 'package:canteen_frontend/models/request/request_entity.dart';
import 'package:canteen_frontend/utils/cloud_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RequestRepository {
  final requestCollection = Firestore.instance.collection('requests');
  List<Request> _requests = [];
  List<DetailedRequest> _detailedRequests = [];

  RequestRepository();

  Future<void> addRequest(Request request) {
    print('ADDING REQUEST');
    CloudFunctionManager.addRequest.call(request.toEntity().toDocument()).then(
        (result) {
      print(result.data);
    }, onError: (error) {
      print('ERROR: $error');
    });
    // return Firestore.instance.runTransaction((Transaction tx) async {
    //   tx.set(requestCollection.document(request.id),
    //       request.toEntity().toDocument());
    // });
  }

  Future<void> deleteRequest(Request request) async {
    return Firestore.instance.runTransaction((Transaction tx) async {
      tx.delete(requestCollection.document(request.id));
    });
  }

  Future<void> acceptRequest(Request request) {
    Firestore.instance.runTransaction((Transaction tx) async {
      tx.update(requestCollection.document(request.id), {"status": 1});
    });

    _requests.removeWhere((r) => r.id == request.id);
    _detailedRequests.removeWhere((r) => r.id == request.id);
  }

  Future<void> declineRequest(Request request) {
    Firestore.instance.runTransaction((Transaction tx) async {
      tx.update(requestCollection.document(request.id), {"status": 2});
    });

    _requests.removeWhere((r) => r.id == request.id);
    _detailedRequests.removeWhere((r) => r.id == request.id);
  }

  List<Request> currentRequests() {
    return _requests;
  }

  List<DetailedRequest> currentDetailedRequests() {
    return _detailedRequests;
  }

  Future<void> saveDetailedRequest(DetailedRequest request) async {
    _detailedRequests.add(request);
  }

  Stream<List<Request>> getAllRequests(String userId) {
    return requestCollection
        .where('receiver_id', isEqualTo: userId)
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
