// lib/core/models/base_model.dart

class BaseModel {
  final DateTime createdAt;
  final DateTime updatedAt;

  BaseModel({
    required this.createdAt,
    required this.updatedAt,
  });

  factory BaseModel.fromJson(Map<String, dynamic> json) {
    return BaseModel(
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
