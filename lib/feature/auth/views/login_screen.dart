import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/feature/auth/view_models/auth_viewmodel.dart';
import 'package:todo/feature/auth/views/widgets/auth_app_bar.dart';
import 'package:todo/feature/auth/views/widgets/login_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    // Controllers for each input field
    final TextEditingController abbreviationController = TextEditingController();
    final TextEditingController fullNameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      appBar: AuthAppBar(logoPath: 'lib/core/resources/images/seed_logo.png'),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
        
            LoginForm(), 
          
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'App Version: 1.0.0', // Replace with your actual version
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
