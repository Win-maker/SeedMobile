import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/app/app_providers.dart';
import 'package:todo/core/resources/styles/theme.dart';
import 'package:todo/core/resources/localization/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:todo/app/app_routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: appProviders,
      child: Builder(
        builder: (context) {
          // Create GoRouter instance
          final router = AppRoutes.createRouter(context);

          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Todo App',
            theme: AppTheme.lightTheme, // Use light theme
            darkTheme: AppTheme.darkTheme, // Use dark theme
            themeMode: ThemeMode.system, // Follow system theme
            routerConfig: router, // Use GoRouter for navigation
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''), // English
              Locale('th', ''), // Thai
            ],
            locale: const Locale('en', ''), // Default locale
          );
        },
      ),
    );
  }
}
