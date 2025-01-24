import 'package:flutter/material.dart';

class AuthAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String logoPath;

  const AuthAppBar({super.key, required this.logoPath});

  @override
  Size get preferredSize => const Size.fromHeight(360.0);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(24.0), // Adjust the radius as needed
        bottomRight: Radius.circular(24.0), // Adjust the radius as needed
      ),
      child: Container(
        height: preferredSize.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF006B3F), // Dark green
              Color(0xFF77C556), // Light green
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Image.asset(
            logoPath, // Path to your logo
            height: 200,
          ),
        ),
      ),
    );
  }
}
