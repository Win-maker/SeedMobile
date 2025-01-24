import 'dart:io';
import 'package:flutter/material.dart';
import 'package:todo/core/services/api/api_service.dart';
import 'package:todo/feature/home/models/banner_model.dart';
import 'package:todo/feature/home/models/home_content.dart';

class HomeViewModel extends ChangeNotifier {
  final ApiService _apiService;

  bool _isLoading = false;
  bool _isAuthenticated = false;
  List<Contents>? _contents;
  List<BannerType>? _banners;

  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  List<Contents>? get contents => _contents;
  List<BannerType>? get banners => _banners;

  HomeViewModel({required ApiService apiService}) : _apiService = apiService;

  Future<void> getHomeContents(
      int userID, String companyId, BuildContext context) async {
    _isLoading = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });

    try {
      final getHomeContents =
          await _apiService.authService.homeContents(userID, companyId);
      _isAuthenticated = true;
      _contents = getHomeContents;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    } catch (e) {
      String errorMessage = e is SocketException
          ? "Network error, please check your internet connection."
          : "Invalid credentials, please check and try again.";
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } finally {
      _isLoading = false;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  Future<void> getBannerPics(String companyId, BuildContext context) async {
    _isLoading = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
    try {
      final getAllBannersPics = await _apiService.authService.getBanner(companyId);
      _isAuthenticated = true;
      _banners = getAllBannersPics;
      print("this is from home view model");
      print(_banners);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    } catch (e) {
      String errorMessage = e is SocketException
          ? "Network error, please check your internet connection."
          : "Invalid credentials, please check and try again.";
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } finally {
      _isLoading = false;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }
}
