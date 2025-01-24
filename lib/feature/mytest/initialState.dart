// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:todo/core/services/api/api_service.dart';
// import 'package:todo/feature/auth/models/user_model.dart';

// class AuthViewModel extends ChangeNotifier {
//   final ApiService _apiService;
//   final SharedPreferences _sharedPreferencesService;
//   UserModel? _user;
//   String? _fullName;

//   UserModel? get user => _user;
//   set settingFullname(String name) => _fullName = name;

//   AuthViewModel(
//       {required ApiService apiService,
//       required SharedPreferences sharedPreferencesService})
//       : _apiService = apiService,
//         _sharedPreferencesService = sharedPreferencesService;

//   Future<void> login(
//       String abbreviation, String fullName, String password) async {
//     final getLoginData =
//         await _apiService.authService.login(abbreviation, fullName, password);
//     _user = getLoginData;
//   }

// }
enum ApiCalltype { GET, POST, PUT, DELETE }

class ApiManager {
  static final ApiManager _instance = ApiManager._internal();

  static ApiManager get instance => _instance;

  ApiManager._internal();

  Map<String, String> defaultHeaders({String? token, String contextType='application/json'}) {
    return {'contextType': contextType,
    if(token != null) 'Authorizaton': 'Bearer$token'};
  }
}
