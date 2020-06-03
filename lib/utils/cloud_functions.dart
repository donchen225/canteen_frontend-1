import 'package:cloud_functions/cloud_functions.dart';

class CloudFunctionManager {
  static final HttpsCallable addRequest = CloudFunctions.instance
      .getHttpsCallable(functionName: 'addRequest')
        ..timeout = Duration(seconds: 30);

  static final HttpsCallable getRecommendations = CloudFunctions.instance
      .getHttpsCallable(functionName: 'getRecommendations')
        ..timeout = Duration(seconds: 30);

  static final HttpsCallable declineRecommendation = CloudFunctions.instance
      .getHttpsCallable(functionName: 'declineRecommendation')
        ..timeout = Duration(seconds: 30);

  static final HttpsCallable acceptRecommendation = CloudFunctions.instance
      .getHttpsCallable(functionName: 'acceptRecommendation')
        ..timeout = Duration(seconds: 30);

  static final HttpsCallable joinGroup = CloudFunctions.instance
      .getHttpsCallable(functionName: 'joinGroup')
        ..timeout = Duration(seconds: 30);
}
