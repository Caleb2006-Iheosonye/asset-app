import 'package:flutter/material.dart';
import 'package:asset_app/touchable_opacity.dart';
import 'package:asset_app/theme/app_theme.dart';

//import 'package:email_validator/email_validator.dart';
//import 'package:http/http.dart' as http;
import 'package:asset_app/screens/auth/screen_arguments.dart'; // adjust path to wherever ScreenArguments is defined

//import 'dart:convert';

import 'package:asset_app/services/auth_service.dart';

class UpdatePassScreen extends StatefulWidget {
  const UpdatePassScreen({super.key});

  @override
  State<UpdatePassScreen> createState() => _UpdatePassScreenState();
}

class _UpdatePassScreenState extends State<UpdatePassScreen> {
  final formKey = GlobalKey<FormState>();
  bool visibility = false;
  bool conVisibilty = false;
  String password = '';
  String updatePass = '';
  int passwordStrength = 0; // 0 = none, 1 = weak, 2 = medium, 3 = strong
  int calculateStrength(String password) {
    int strength = 0;
    if (password.length >= 8) strength++;
    if (password.contains(RegExp(r'[A-Z]'))) strength++;
    if (password.contains(RegExp(r'[0-9]'))) strength++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength++;
    return strength; // 0-4
  }

  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Grab the theme's colors and text styles once, use them below.
    

    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme; //
    final rawArgs = ModalRoute.of(context)!.settings.arguments;
    if (rawArgs is! ScreenArguments) {
      return const Scaffold(
        body: Center(child: Text('Reset session missing. Please start again.')),
      );
    }
    final accessToken = rawArgs.accessToken;
    final refreshToken = rawArgs.refreshToken;
    if (accessToken == null || refreshToken == null) {
      return const Scaffold(
        body: Center(child: Text('Reset session missing. Please start again.')),
      );
    }
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  IconButton(
                    icon: const Icon(Icons.chevron_left, size: 48),
                    onPressed: () => Navigator.pushNamed(context, '/login'),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Set new password',
                    style: textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                      color: colors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Choose a new password for your account.",
                    style: textTheme.headlineMedium?.copyWith(
                      color: colors.onSurfaceVariant,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'New password',
                    style: TextStyle(
                      color: colors.onSurfaceVariant,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: passwordController,
                    obscureText: !visibility,
                    onChanged: (value) {
                      setState(() {
                        password = value;
                        passwordStrength = calculateStrength(value);
                      });
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          visibility ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () =>
                            setState(() => visibility = !visibility),
                      ),

                      filled: true,
                      fillColor: colors.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: colors.outline),
                      ),
                      hintText: 'Enter your password',
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (password.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: passwordStrength / 4,
                      backgroundColor: colors.surface,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        passwordStrength <= 1
                            ? Colors.red
                            : passwordStrength == 2
                            ? Colors.orange
                            : passwordStrength == 3
                            ? Colors.yellow
                            : Colors.green,
                      ),
                    ),
                  ],
                  Text(
                    'Use 8 or more characters with a number.',
                    style: TextStyle(
                      color: colors.onSurfaceVariant,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 16),
                  Text(
                    'Confirm password',
                    style: TextStyle(
                      color: colors.onSurfaceVariant,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: confirmPasswordController,
                    obscureText: !conVisibilty,
                    onChanged: (value) {
                      setState(() {
                        updatePass = value;
                      });
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          conVisibilty
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () =>
                            setState(() => conVisibilty = !conVisibilty),
                      ),

                      filled: true,
                      fillColor: colors.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: colors.outline),
                      ),
                      hintText: 'Confirm password',
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Confirm your password';
                      }
                      if (value != passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
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
                        'Reset password',
                        style: textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colors.onPrimary,
                        ),
                      ),
                    ),
                    onTap: () async {
                      final pass = passwordController.text;
                      if (pass.length < 8 || !pass.contains(RegExp(r'[0-9]'))) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Use 8 or more characters with a number.',
                            ),
                          ),
                        );
                        return;
                      }
                      if (!formKey.currentState!.validate()) return;

                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) =>
                            const Center(child: CircularProgressIndicator()),
                      );

                      Map<String, dynamic>? result;
                      try {
                        result = await AuthService.updatePassword(
                          newPassword: pass,
                          accessToken: accessToken,
                          refreshToken: refreshToken,
                        );
                      } catch (e) {
                        result = null;
                      } finally {
                        if (context.mounted) Navigator.pop(context);
                      }

                      if (!context.mounted) return;
                      if (result == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Network error. Try again.'),
                          ),
                        );
                        return;
                      }

                      if (result['success'] == true) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Password updated. Please log in.'),
                          ),
                        );
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/login',
                          (route) => false,
                        );
                      } else {
                        final errorMessage =
                            result['data']?['error'] ?? 'Something went wrong';
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(errorMessage.toString())),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
