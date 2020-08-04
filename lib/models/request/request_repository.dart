import 'package:canteen_frontend/models/api_response/api_response.dart';
import 'package:canteen_frontend/models/request/create_request_payload.dart';
import 'package:canteen_frontend/models/request/request.dart';
import 'package:canteen_frontend/models/request/request_entity.dart';
import 'package:canteen_frontend/utils/cloud_functions.dart';
import 'package:canteen_frontend/utils/shared_preferences_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tuple/tuple.dart';

class RequestRepository {
  final requestCollection = Firestore.instance.collection('requests');
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
    _detailedRequests.removeWhere((r) => r.id == requestId);
    _detailedRequests.removeWhere((r) => r.id == requestId);

    return Firestore.instance.runTransaction((Transaction tx) async {
      await tx.update(requestCollection.document(requestId), {"status": 1});
    });
  }

  Future<void> declineRequest(String requestId) {
    _detailedRequests.removeWhere((r) => r.id == requestId);
    _detailedRequests.removeWhere((r) => r.id == requestId);

    return Firestore.instance.runTransaction((Transaction tx) async {
      await tx.update(requestCollection.document(requestId), {"status": 2});
    });
  }

  List<DetailedRequest> currentDetailedRequests() {
    return _detailedRequests;
  }

  Future<void> saveDetailedRequest(DetailedRequest request) async {
    _detailedRequests.add(request);
  }

  void clearRequests() {
    _detailedRequests = [];
  }

  Stream<List<Tuple2<DocumentChangeType, Request>>> getAllRequests() {
    final userId =
        CachedSharedPreferences.getString(PreferenceConstants.userId);

    return requestCollection
        .where('receiver_id', isEqualTo: userId)
        .where('status', isEqualTo: 0)
        .orderBy("created_on", descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.documentChanges
          .map((doc) => Tuple2<DocumentChangeType, Request>(doc.type,
              Request.fromEntity(RequestEntity.fromSnapshot(doc.document))))
          .toList();
    });
  }

  Stream<List<Tuple2<DocumentChangeType, Request>>> getAllReferralRequests() {
    final userId =
        CachedSharedPreferences.getString(PreferenceConstants.userId);

    return requestCollection
        .where('referral_id', isEqualTo: userId)
        .where('status', isEqualTo: 10)
        .orderBy("created_on", descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.documentChanges
          .map((doc) => Tuple2<DocumentChangeType, Request>(doc.type,
              Request.fromEntity(RequestEntity.fromSnapshot(doc.document))))
          .toList();
    });
  }

  void updateDetailedRequest(DocumentChangeType type, Request request) {
    if (type == DocumentChangeType.added) {
      var currentIdx = _detailedRequests.indexWhere((r) => r.id == request.id);

      if (currentIdx != -1) {
        _detailedRequests[currentIdx] = request;
      } else {
        var idx = 0;
        while (idx < _detailedRequests.length) {
          if (request.createdOn.isAfter(_detailedRequests[idx].createdOn)) {
            break;
          }

          idx++;
        }
        _detailedRequests.insert(idx, request);
      }
    } else if (type == DocumentChangeType.modified) {
      _detailedRequests.removeWhere((r) => r.id == request.id);
      _detailedRequests.insert(0, request);
    } else if (type == DocumentChangeType.removed) {
      _detailedRequests.removeWhere((r) => r.id == request.id);
    }
  }
}
