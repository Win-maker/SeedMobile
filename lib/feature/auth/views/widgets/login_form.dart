import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/feature/auth/view_models/auth_viewmodel.dart';
import 'package:todo/core/utils/form_validators.dart';
import 'custom_text_field.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  // Controllers for each input field
  final TextEditingController abbreviationController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // FocusNodes for each input field
  final FocusNode abbreviationFocusNode = FocusNode();
  final FocusNode fullNameFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

  // Global key for form state
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return GestureDetector(
      onTap: () {
       FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(40, 20, 40, 15),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center, 
            children: [
              // Centered title
              const Center(
                child: Text(
                  'Welcome Back!',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              // Company Code input
              CustomTextField(
                hintText: 'Company Code',
                controller: abbreviationController,
                focusNode: abbreviationFocusNode,
                validator: (value) => FormValidators.required(value, fieldName: 'Company Code'),
                leadingIcon: Icon(Icons.cases_outlined),
              ),
              const SizedBox(height: 16),
              // Full Name input
              CustomTextField(
                hintText: 'Full Name',
                controller: fullNameController,
                focusNode: fullNameFocusNode,
                validator: (value) => FormValidators.required(value, fieldName: 'Full Name'),
                leadingIcon: const Icon(Icons.person),
              ),
              const SizedBox(height: 16),
              // Password input
              CustomTextField(
                hintText: 'Password',
                controller: passwordController,
                focusNode: passwordFocusNode,
                validator: (value) => FormValidators.required(value, fieldName: 'Password'),
                obscureText: true,
                leadingIcon: const Icon(Icons.lock),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: authViewModel.rememberMe,
                        onChanged: (value) {
                          authViewModel.setRememberMe(value!);
                        },
                      ),
                      Text('Remember me')
                    ],
                  ),
                  Text('Forgot Password?')
                ],
              ),
              const SizedBox(height: 20),
              // Centered and wider Login button
              Center(
                child: SizedBox(
                  width: 200, // Full width of the parent
                  child: ElevatedButton(
                    onPressed: authViewModel.isLoading
                        ? null
                        : () {
                      if (_formKey.currentState?.validate() ?? false) {
                        final abbreviation = abbreviationController.text;
                        final fullName = fullNameController.text;
                        final password = passwordController.text;

                        authViewModel.login(abbreviation, fullName, password,context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please fill in all fields correctly')),
                        );
                      }
                    },
                    child: authViewModel.isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Login'),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text("Don't have a company account?"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose the controllers and focus nodes when the widget is removed from the tree
    abbreviationController.dispose();
    fullNameController.dispose();
    passwordController.dispose();
    abbreviationFocusNode.dispose();
    fullNameFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }
}
