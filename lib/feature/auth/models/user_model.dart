// lib/features/auth/models/user_model.dart

//This model is only for sample
class UserModel {
  final String fullName;
  final String profilePic;
  final String token;
  final int id;
  final String companyId;
  final String email;
  final String gender;
  final String prefix;
  final String firstName;
  final String lastName;

  UserModel(
      {required this.fullName,
      required this.profilePic,
      required this.token,
      required this.id,
      required this.companyId,
      required this.email,
      required this.gender,
      required this.prefix,
      required this.firstName,
      required this.lastName});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        fullName: json['fullName'] as String,
        profilePic: json['profilePic'] as String,
        token: json['token'] as String,
        id: json['id'] as int,
        companyId: json['companyId'] as String,
        email: json['email'] as String,
        gender: json['gender'] as String,
         prefix: json['prefix'] as String,
         firstName: json['firstName'] as String,
         lastName: json['lastName'] as String);
       
  }
}
