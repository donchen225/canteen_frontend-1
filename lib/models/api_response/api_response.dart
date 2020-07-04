import 'package:canteen_frontend/models/api_response/api_response_status.dart';
import 'package:cloud_functions/cloud_functions.dart';

import 'package:meta/meta.dart';

class ApiResponse {
  final ApiResponseStatus status;
  final Map<dynamic, dynamic> data;
  final String message;

  ApiResponse({@required this.status, this.data, this.message});

  static ApiResponse fromHttpResult(HttpsCallableResult result) {
    final response = result.data;
    final status = response['status'];

    if (status == null) {
      throw Exception(
          "Invalid response received from server. Status does not exist.");
    }

    ApiResponseStatus serializedStatus = ApiResponseStatus.values
        .firstWhere((e) => e.toString() == 'ApiResponseStatus.' + status);

    return ApiResponse(
        status: serializedStatus,
        data: response['data'],
        message: response['message']);
  }
}
