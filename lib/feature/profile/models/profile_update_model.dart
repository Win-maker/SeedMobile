class UserProfileRequest {
  final int id;
  final String gender;
  final String email;
  final Map<String, String> profilePic; 
  final String prefix;
  final String firstName;
  final String lastName;

  UserProfileRequest({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.gender,
    required this.prefix,
    required this.profilePic,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'gender': gender,
       'email': email,
       'profilePic': {
        'base64': profilePic['base64'] ?? '',
        'fileName': profilePic['fileName'] ?? '',
      },
          'prefix': prefix,
      'firstName': firstName,
      'lastName': lastName,
   
    };
  }

  factory UserProfileRequest.fromJson(Map<String, dynamic> json) {
    return UserProfileRequest(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      gender: json['gender'],
      prefix: json['prefix'],
      profilePic: Map<String, String>.from(json['profilePic'] ?? {}),
    );
  }
}
