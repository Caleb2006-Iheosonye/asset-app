import 'package:flutter/material.dart';
import 'package:asset_app/touchable_opacity.dart';
import 'package:asset_app/theme/app_theme.dart';

import 'package:email_validator/email_validator.dart';
//import 'package:http/http.dart' as http;
import 'package:asset_app/screens/auth/screen_arguments.dart'; // adjust path to wherever ScreenArguments is defined

//import 'dart:convert';

import 'package:asset_app/services/auth_service.dart';

class ForgetPassScreen extends StatefulWidget {
  const ForgetPassScreen({super.key});

  @override
  State<ForgetPassScreen> createState() => _ForgetPassScreenState();
}

class _ForgetPassScreenState extends State<ForgetPassScreen> {
  bool isEmailValid(String email) {
    return EmailValidator.validate(email);
  }

  final emailController = TextEditingController();
  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Grab the theme's colors and text styles once, use them below.

    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme; //
    final extraColors = Theme.of(context).extension<AppExtraColors>()!;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                IconButton(
                  icon: const Icon(Icons.chevron_left, size: 48),
                  onPressed: () => Navigator.pushNamed(context, '/updatePass'),
                ),
                const SizedBox(height: 24),
                Text(
                  'Forgot password?',
                  style: textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                    color: colors.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Enter your account email and we'll send a 6-digit code to reset it.",
                  style: textTheme.headlineMedium?.copyWith(
                    color: colors.onSurfaceVariant,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Email',
                  style: TextStyle(
                    color: colors.onSurfaceVariant,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,

                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.mail_outline),
                    filled: true,
                    fillColor: colors.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: colors.outline),
                    ),

                    hintText: 'Enter your email',
                  ),
                  // Auto validate the email field when the user interacts with it
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email cannot be empty';
                    } else if (!isEmailValid(value)) {
                      return 'Please enter a valid email';
                    }
                    return null; // Return null if the email is valid
                  },
                ),
                const SizedBox(height: 16),
                TouchableOpacity(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: colors.primary,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'Send code',
                      style: textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colors.onPrimary,
                      ),
                    ),
                  ),
                  onTap: () async {
                    final email = emailController.text;
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) =>
                          const Center(child: CircularProgressIndicator()),
                    );
                    final result = await AuthService.forgetpass(email: email);
                    if (!context.mounted)
                      return; // guard #1 — right after the await

                    Navigator.pop(context); // close loading dialog

                    if (result['success'] == true) {
                      if (!context.mounted)
                        return; // guard #2 — right before this context use
                      Navigator.pushNamed(
                        context,
                        '/otp',
                        arguments: ScreenArguments(
                          type: 'recovery',
                          firstName: '',
                          lastName: '',
                          email: email,
                          password: '',
                        ),
                      );
                    } else {
                      if (!context.mounted)
                        return; // guard #3 — right before this context use
                      final errorMessage =
                          result['data']?['error'] ?? 'Something went wrong';
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(errorMessage.toString())),
                      );
                    }
                  },
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    Text(
                      "Remember your password?",
                      style: TextStyle(
                        fontSize: 14,
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                    TouchableOpacity(
                      child: Text(
                        //textAlign: TextAlign.end,
                        ' Log in',
                        style: TextStyle(
                          color: extraColors.accentText,
                          fontSize: 14,
                        ),
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, '/login');
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
