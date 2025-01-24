// lib/core/app_providers.dart

import 'package:provider/provider.dart';
import 'package:todo/core/services/api/api_manager.dart';
import 'package:todo/core/services/api/api_service.dart';
import 'package:todo/core/utils/shared_preferences.dart';
import 'package:todo/feature/auth/view_models/auth_viewmodel.dart';
import 'package:provider/single_child_widget.dart';
import 'package:todo/feature/home/view_models/home_viewmodel.dart';

// List of providers for the application
final List<SingleChildWidget> appProviders = [
  ChangeNotifierProvider(
      create: (_) => AuthViewModel(
          apiService:
              ApiService(ApiManager.instance, SharedPreferencesService()),
          sharedPreferencesService: SharedPreferencesService())),

           ChangeNotifierProvider(
    create: (_) => HomeViewModel(
      apiService: ApiService(ApiManager.instance, SharedPreferencesService()),
    ),
  ),
  // Add more providers as needed
];
