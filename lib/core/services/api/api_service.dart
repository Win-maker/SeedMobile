import 'dart:convert';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/core/utils/shared_preferences.dart';
import 'package:todo/core/services/api/api_manager.dart';
import 'package:todo/feature/auth/models/user_model.dart';
import 'package:todo/feature/home/models/banner_model.dart';
import 'package:todo/feature/home/models/home_content.dart';
import 'package:todo/feature/profile/models/profile_update_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final AuthService authService;
  final ProfileService profileService;

  ApiService(
      ApiManager apiManager, SharedPreferencesService sharedPreferencesService)
      : authService = AuthService(apiManager, sharedPreferencesService),
        profileService = ProfileService(apiManager);
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

class ProfileService {
  final ApiManager _apiManager;

  ProfileService(this._apiManager);

  Future<void> editUserProfile(UserProfileRequest payload) async {
    final response = await _apiManager.makeApiCall(
        endpoint: 'User/UpdatedUserFromMobile',
        callType: ApiCallType.POST,
        requiresAuth: true,
        apiVersion: 'v1',
        body: payload.toJson());
    if (response['status'] == 0) {
      print("You successfully update profile");
    } else {
      throw Exception("Profile Fetching Failed: ${response['message']}");
    }
  }

  // if (response['status'] == 0) {
  //   // GoRouter.of(context as BuildContext).go("/audio");
  //   print("You got it now");
  //   print(response);
  // } else {
  //     print("There is error in fetching update profile api");
  //    throw Exception("Update Fetching Failed: ${response['message']}");

  // }

  Future<String> uploadNewProfile(File imageFile) async {
    // Prepare the API endpoint URL
    String apiUrl =
        'https://devseedmobileapi.azurewebsites.net/api/v1/File/UploadFile';

    // Prepare the authorization token (use actual token)

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    // Create a MultipartRequest to handle the file upload
    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

    // Add the authorization header
    if (token != null) {
      request.headers['Authorization'] = token;
    }

    // Determine MIME type based on file extension
    String mimeType = 'image/jpeg'; // Default to JPEG if unknown
    String fileExtension =
        imageFile.path.split('.').last.toLowerCase(); // Get the file extension

    if (fileExtension == 'jpg' || fileExtension == 'jpeg') {
      mimeType = 'image/jpeg';
    } else if (fileExtension == 'png') {
      mimeType = 'image/png';
    }

    // Add the file to the request with dynamically determined MIME type
    var fileStream = await http.MultipartFile.fromPath(
      'file', // The key that the server expects for the file field
      imageFile.path, // Path to the file you want to upload
      contentType: MediaType.parse(mimeType), // Dynamically set the MIME type
    );
    request.files.add(fileStream);

    try {
      // Send the request
      var response = await request.send();

      // Wait for the response and parse it
      if (response.statusCode == 200) {
        // Handle success response
        final responseBody = await response.stream.bytesToString();
        final jsonData = json.decode(responseBody);
        return jsonData['data'];
      } else {
        // Handle failure response
        return 'Failed to upload file: ${response.statusCode}';
      }
    } catch (e) {
      // Handle any errors
      return 'Error: $e';
    }
  }

  Future<String> getUserProfile(int userID) async {
    final response = await _apiManager.makeApiCall(
      endpoint: '/User/GetUserProfilePic',
      callType: ApiCallType.GET,
      requiresAuth: true,
      apiVersion: 'v1',
      params: {'UserID': userID.toString()},
    );
    if (response['status'] == 0) {
      return response['data'];
    } else {
      throw Exception("Contents Fetching Failed: ${response['message']}");
    }
  }
}
