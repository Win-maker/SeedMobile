import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:todo/feature/audio/view/audio_player_view.dart';
import 'package:todo/feature/auth/view_models/auth_viewmodel.dart';
import 'package:todo/feature/auth/views/login_screen.dart';
import 'package:todo/feature/home/views/home_view.dart';

final GoRouter routers = GoRouter(
  initialLocation: "/",
  redirect: (context, state) {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final isAuthenticated = authViewModel.isAuthenticated;
    if (!isAuthenticated) {
      return "/";
    }
    if (isAuthenticated) {
      return "home";
    } else {
      return null;
    }
  },
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(path: "home", builder: (context, state) => HomeView()),
    GoRoute(
      path: "audio",
      builder: (context, state) => AudioPlayerView(),
    )
  ],
);
