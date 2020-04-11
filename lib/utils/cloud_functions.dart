import 'package:cloud_functions/cloud_functions.dart';

class CloudFunctionManager {
  static final HttpsCallable addRequest = CloudFunctions.instance
      .getHttpsCallable(functionName: 'addRequest')
        ..timeout = Duration(seconds: 30);
}
