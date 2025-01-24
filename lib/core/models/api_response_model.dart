// lib/core/models/api_response.dart

class ApiResponse<T> {
  final String message;
  final int status;
  final T data;

  ApiResponse({
    required this.message,
    required this.status,
    required this.data,
  });

  factory ApiResponse.fromJson(
      Map<String, dynamic> json,
      T Function(dynamic json) dataParser,
      ) {
    return ApiResponse<T>(
      message: json['message'] as String,
      status: json['status'] as int,
      data: dataParser(json['data']),
    );
  }
}
