import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:todo/feature/audio/view/audio_player_view.dart';
import 'package:todo/feature/auth/view_models/auth_viewmodel.dart';
import 'package:todo/feature/auth/views/login_screen.dart';
import 'package:todo/feature/home/views/home_view.dart';
import 'package:todo/feature/error/error_page.dart';
import 'package:todo/feature/library/view/LibraryView.dart';

class AppRoutes {
  // Route names
  static const String login = '/login';
  static const String home = '/home';
  static const String audio = '/audio';
  static const String error = '/error';
  static const String library = '/library';

  // Create GoRouter instance
  static GoRouter createRouter(BuildContext context) {
    return GoRouter(
      initialLocation: login,
      redirect: (context, state) {
        final authViewModel =
            Provider.of<AuthViewModel>(context, listen: false);
        final isAuthenticated = authViewModel.isAuthenticated;
        final isLoggingIn = state.location == login;

        // Redirect to login if not authenticated and not already on login
        if (!isAuthenticated && state.location != login) {
          return login;
        }

        // Redirect to home if authenticated and trying to access login
        if (isAuthenticated && isLoggingIn) {
          return audio;
        }

        // No redirection needed
        //return login;
      },
      routes: [
        GoRoute(
          path: login,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: home,
          builder: (context, state) => const HomeView(),
        ),
        GoRoute(
            path: audio,
             builder: (context, state) => const AudioPlayerView()),       
        GoRoute(
          path: library,
           builder: (context, state) => const LibraryView()),
        GoRoute(
          path: error,
          builder: (context, state) => const ErrorPage(),
        ),
      ],
      errorBuilder: (context, state) => const ErrorPage(),
    );
  }
}
