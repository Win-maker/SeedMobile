import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/core/config/api_config.dart';

enum ApiCallType { GET, POST, PUT, DELETE }

class ApiManager {
  static final ApiManager _instance = ApiManager._internal();
  static ApiManager get instance => _instance;

  ApiManager._internal();

  /// Generates dynamic headers for API requests.
  Map<String, String> defaultHeaders({
    String? token,
    String contentType = 'application/json',
  }) {
    return {
      'Content-Type': contentType,
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  /// retrieving the authentication token.
  Future<String?> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    return token;
  }

  /// Reusable API request handler.
  Future<dynamic> makeApiCall({
    required String endpoint,
    ApiCallType callType = ApiCallType.GET,
    bool requiresAuth = true,
    String contentType = 'application/json',
    Map<String, dynamic>? params,
    Map<String, dynamic>? body,
    String apiVersion = '',
  }) async {
    final token = requiresAuth ? await _getAuthToken() : null;
    final headers = defaultHeaders(token: token, contentType: contentType);
    var uri = Uri.parse('${ApiConfig.baseUrl}$apiVersion/$endpoint');
    if (params != null) {
      uri = uri.replace(queryParameters: params);
    }

    http.Response response;

    try {
      switch (callType) {
        case ApiCallType.GET:
          response = await http.get(uri, headers: headers);
          break;
        case ApiCallType.POST:
          response =
              await http.post(uri, headers: headers, body: jsonEncode(body));
          break;
        case ApiCallType.PUT:
          response =
              await http.put(uri, headers: headers, body: jsonEncode(body));
          break;
        case ApiCallType.DELETE:
          response = await http.delete(uri, headers: headers);
          break;
      }
      if (response.statusCode >= 200 && response.statusCode < 300) {
        
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed API call: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error in API call: $e');
    }
  }
}
