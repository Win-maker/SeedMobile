import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todo/core/services/api/api_service.dart';
import 'package:todo/feature/profile/models/profile_update_model.dart';

class ProfileViewModel extends ChangeNotifier {
  final ApiService _apiService;

  String? _profileLink;

  get profileLink => _profileLink;

  ProfileViewModel({
    required ApiService apiService,
  }) : _apiService = apiService;

  Future<dynamic> updateUserProfileWeb(
    UserProfileRequest payload, BuildContext context) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
    try {
      await _apiService.profileService.editUserProfile(payload);
      notifyListeners();
      GoRouter.of(context).push('/home');
    } catch (e) {
      print(e);
      print("you got error in profile view model fetching");
    }
  }

  Future<String> updateProfilePic(File imgFile, BuildContext context) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
    try {
      final imgPath =
          await _apiService.profileService.uploadNewProfile(imgFile);

      notifyListeners();
      return imgPath;
    } catch (e) {
      print(e);
      return '';
    }
  }

  Future<Map<String, String>> convertImagePathToBase64(String imgPath) async {
    try {
      // Read the image file as bytes
      File imageFile = File(imgPath);
      if (!imageFile.existsSync()) {
        print("File does not exist at path: $imgPath");
        return {};
      }

      Uint8List imageBytes = await imageFile.readAsBytes();

      String base64Image = base64Encode(imageBytes);

      String fileName = imgPath.split('/').last;

      Map<String, String> body = {
        "base64": base64Image,
        "fileName": fileName,
      };
      return body;
    } catch (e) {
      return {};
    }
  }

  Future<String> getProfilePic(int userId) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
    try {
      final res = await _apiService.profileService.getUserProfile(userId);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
      return res;
    } catch (e) {
      print(e);
      return '';
    } finally {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }
}
