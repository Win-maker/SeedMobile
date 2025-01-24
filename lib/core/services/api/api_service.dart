import 'package:todo/core/utils/shared_preferences.dart';
import 'package:todo/core/services/api/api_manager.dart';
import 'package:todo/feature/auth/models/user_model.dart';
import 'package:todo/feature/home/models/banner_model.dart';
import 'package:todo/feature/home/models/home_content.dart';

class ApiService {
  final AuthService authService;

  ApiService(
      ApiManager apiManager, SharedPreferencesService sharedPreferencesService)
      : authService = AuthService(apiManager, sharedPreferencesService);
}

class AuthService {
  final ApiManager _apiManager;
  final SharedPreferencesService _preferencesService;

  AuthService(this._apiManager, this._preferencesService);

  Future<UserModel> login(
      String abbreviation, String fullName, String password) async {
    final response = await _apiManager.makeApiCall(
      endpoint: 'Login/LoginCustomerMobile',
      callType: ApiCallType.POST,
      body: {
        'abbreviation': abbreviation,
        'fullName': fullName,
        'password': password,
      },
      requiresAuth: false,
      apiVersion: 'v2',
    );
    if (response['status'] == 0) {
      final token = response['data']['token'];
      final loginData = response['data'];
      await _preferencesService.saveString("jwt_token", token);
      return UserModel.fromJson(loginData);
    } else {
      throw Exception("Login failed: ${response['message']}");
    }
  }

  Future<List<Contents>> homeContents(int userID, String companyId) async {
    final response = await _apiManager.makeApiCall(
        endpoint: 'Contents/GetAllContents',
        callType: ApiCallType.GET,
        params: {'UserID': userID.toString(), 'CompanyId': companyId},
        requiresAuth: true,
        apiVersion: 'v5');

    if (response['status'] == 0) {
      final allContents = response['data'] as List;

      final contentsAsList =
          allContents.map((content) => Contents.fromJson(content)).toList();
      return contentsAsList;
    } else {
      throw Exception("Contents Fetching Failed: ${response['message']}");
    }
  }

  Future<List<BannerType>> getBanner(String companyId) async {
    final response = await _apiManager.makeApiCall(
        endpoint: 'Banner/GetBannerMobile',
        callType: ApiCallType.GET,
        params: {'CompanyID': companyId},
        requiresAuth: true,
        apiVersion: 'v1');
    if (response['status'] == 0) {
      final getBanners = response['data'] as List;

      final bannerAsList =
          getBanners.map((banner) => BannerType.fromJson(banner)).toList();
      print(bannerAsList);
      return bannerAsList;
    } else {
      throw Exception("Banner Fetching Failed: ${response['message']}");
    }
  }
}
