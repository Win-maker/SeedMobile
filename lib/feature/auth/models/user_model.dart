// lib/features/auth/models/user_model.dart

//This model is only for sample
class UserModel {
  final String fullName;
  final String profilePic;
  final String token;
  final int id;
  final String companyId;

  UserModel(
      {required this.fullName, required this.profilePic, required this.token, required this.id, required this.companyId});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      fullName: json['fullName'] as String,
      profilePic: json['profilePic'] as String,
      token: json['token'] as String,
      id: json['id'] as int,
      companyId: json['companyId'] as String

    );
  }
}
