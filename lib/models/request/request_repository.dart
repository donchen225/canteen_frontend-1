import 'package:canteen_frontend/models/api_response/api_response.dart';
import 'package:canteen_frontend/models/request/create_request_payload.dart';
import 'package:canteen_frontend/models/request/request.dart';
import 'package:canteen_frontend/models/request/request_entity.dart';
import 'package:canteen_frontend/utils/cloud_functions.dart';
import 'package:canteen_frontend/utils/shared_preferences_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RequestRepository {
  final requestCollection = Firestore.instance.collection('requests');
  List<Request> _requests = [];
  List<DetailedRequest> _detailedRequests = [];

  RequestRepository();

  Future<ApiResponse> addRequest(CreateRequestPayload payload) {
    return CloudFunctionManager.addRequest
        .call(payload.toJson())
        .then((result) {
      if (result.data == null) {
        throw Exception("No data received from server.");
      }
      return ApiResponse.fromHttpResult(result);
    });
  }

  Future<void> deleteRequest(Request request) async {
    return Firestore.instance.runTransaction((Transaction tx) async {
      await tx.delete(requestCollection.document(request.id));
    });
  }

  Future<void> acceptRequest(String requestId) {
    _requests.removeWhere((r) => r.id == requestId);
    _detailedRequests.removeWhere((r) => r.id == requestId);

    return Firestore.instance.runTransaction((Transaction tx) async {
      await tx.update(requestCollection.document(requestId), {"status": 1});
    });
  }

  Future<void> declineRequest(String requestId) {
    _requests.removeWhere((r) => r.id == requestId);
    _detailedRequests.removeWhere((r) => r.id == requestId);

    return Firestore.instance.runTransaction((Transaction tx) async {
      await tx.update(requestCollection.document(requestId), {"status": 2});
    });
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

  void clearRequests() {
    _requests = [];
    _detailedRequests = [];
  }

  Stream<List<Request>> getAllRequests() {
    final userId =
        CachedSharedPreferences.getString(PreferenceConstants.userId);

    return requestCollection
        .where('receiver_id', isEqualTo: userId)
        .where('status', isEqualTo: 0)
        .orderBy("created_on", descending: true)
        .snapshots()
        .map((snapshot) {
      snapshot.documentChanges.forEach((doc) => _processRequests(doc.type,
          Request.fromEntity(RequestEntity.fromSnapshot(doc.document))));
      return _requests;
    });
  }

  void _processRequests(DocumentChangeType type, Request newRequest) {
    if (type == DocumentChangeType.added) {
      var idx = 0;
      while (idx < _requests.length) {
        if (newRequest.createdOn.isAfter(_requests[idx].createdOn)) {
          break;
        }

        idx++;
      }
      _requests.insert(idx, newRequest);
    } else if (type == DocumentChangeType.modified) {
      _requests.removeWhere((request) => request.id == newRequest.id);
      _requests.insert(0, newRequest);
    } else if (type == DocumentChangeType.removed) {
      _requests.removeWhere((request) => request.id == newRequest.id);
    }
  }
}
