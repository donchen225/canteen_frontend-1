import 'package:cloud_functions/cloud_functions.dart';

class CloudFunctionManager {
  static final HttpsCallable addRequest = CloudFunctions.instance
      .getHttpsCallable(functionName: 'addRequest')
        ..timeout = Duration(seconds: 30);

  static final HttpsCallable getRecommendations = CloudFunctions.instance
      .getHttpsCallable(functionName: 'getRecommendations')
        ..timeout = Duration(seconds: 30);
}
