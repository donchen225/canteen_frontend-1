import 'package:canteen_frontend/models/recommendation/recommendation.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/models/user/user_entity.dart';
import 'package:canteen_frontend/utils/cloud_functions.dart';
import 'package:canteen_frontend/utils/shared_preferences_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RecommendationRepository {
  final recommendationCollection =
      Firestore.instance.collection('recommendations');
  static const String profiles = 'profiles';
  static const String query = 'queries';

  RecommendationRepository();

  Future<void> getRecommendation() {
    final userId =
        CachedSharedPreferences.getString(PreferenceConstants.userId);
    return recommendationCollection.document(userId).get();
  }

  Future<void> declineRecommendation(String id) async {
    return CloudFunctionManager.declineRecommendation.call({
      "id": id,
    }).then((result) {
      print(result.data);
      return result.data;
    }, onError: (error) {
      print('Error declining recommendation: $error');
    });
  }

  Future<void> acceptRecommendation(String id) async {
    return CloudFunctionManager.acceptRecommendation.call({
      "id": id,
    }).then((result) {
      print(result.data);
      return result.data;
    }, onError: (error) {
      print('Error accepting recommendation: $error');
    });
  }

  Future<List<Recommendation>> getRecommendations() async {
    return CloudFunctionManager.getRecommendations.call().then((result) {
      print('GETTING RECOMMENDATIONS');
      print(result.data);
      return result.data
          .map<Recommendation>((rec) => Recommendation.fromJSON(rec))
          .toList();
    }, onError: (error) {
      print('ERROR GETTING RECOMMENDATIONS: $error');
    });
  }
}
