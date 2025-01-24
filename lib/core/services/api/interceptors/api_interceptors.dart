// lib/core/services/api_interceptors.dart

import 'dart:async';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiInterceptor implements InterceptorContract {

  @override
  Future<BaseRequest> interceptRequest({required BaseRequest request}) async {
    // Fetch the token from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (token != null) {
      // Add the token to the request headers
      request.headers['Authorization'] = 'Bearer $token';
    }

    return request; // Return the modified request
  }

  @override
  FutureOr<BaseResponse> interceptResponse({required BaseResponse response}) async {
    // Check if the response status is successful (200 OK)
    if (response.statusCode != 200) {
      // If status code is not 200, throw an exception
      throw Exception('Failed to load data: ${response.statusCode}');
    }
    return response;
  }

  @override
  FutureOr<bool> shouldInterceptRequest() {
    return true;
  }

  @override
  FutureOr<bool> shouldInterceptResponse() {
    return true;
  }
}
