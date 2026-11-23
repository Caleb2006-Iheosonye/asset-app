import 'package:flutter/material.dart';
import 'package:asset_app/theme/app_theme.dart';
import 'package:asset_app/components/app_widgets.dart';
import 'package:asset_app/services/screen_arguments.dart';
import 'package:asset_app/services/auth_service.dart';

class UpdatePassScreen extends StatefulWidget {
  const UpdatePassScreen({super.key});

  @override
  State<UpdatePassScreen> createState() => _UpdatePassScreenState();
}

class _UpdatePassScreenState extends State<UpdatePassScreen> {
  final formKey = GlobalKey<FormState>();
  bool visibility = false;
  int passwordStrength = 0; // 0 to 4

  int calculateStrength(String password) {
    int strength = 0;
    if (password.length >= 8) strength++;
    if (password.contains(RegExp(r'[A-Z]'))) strength++;
    if (password.contains(RegExp(r'[0-9]'))) strength++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength++;
    return strength;
  }

  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _snack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _reset(String accessToken, String refreshToken) async {
    final pass = passwordController.text;
    if (pass.length < 8 ||
        !pass.contains(RegExp(r'[0-9]')) ||
        !pass.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      _snack('Use 8 or more characters with a number and a special character.');
      return;
    }
    if (!formKey.currentState!.validate()) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
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
      if (mounted) Navigator.pop(context);
    }

    if (!mounted) return;
    if (result == null) {
      _snack('Network error. Try again.');
      return;
    }

    if (result['success'] == true) {
      _snack('Password updated. Please log in.');
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    } else {
      _snack((result['data']?['error'] ?? 'Something went wrong').toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
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
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AuthBackButton(
                    onPressed: () => Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/login',
                      (route) => false,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Set new password',
                    style: textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Choose a new password for your account.',
                    style: TextStyle(
                      color: colors.onSurfaceVariant,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const FieldLabel('New password'),
                  TextFormField(
                    controller: passwordController,
                    obscureText: !visibility,
                    onChanged: (value) {
                      setState(() => passwordStrength = calculateStrength(value));
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock_outline, size: 18),
                      suffixIcon: IconButton(
                        icon: Icon(
                          visibility
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          size: 18,
                        ),
                        onPressed: () =>
                            setState(() => visibility = !visibility),
                      ),
                      hintText: 'Enter your password',
                    ),
                  ),
                  StrengthBar(strength: passwordStrength),
                  const SizedBox(height: 6),
                  Text(
                    'Use 8 or more characters with a number.',
                    style: TextStyle(
                      fontSize: 12,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const FieldLabel('Confirm password'),
                  TextFormField(
                    controller: confirmPasswordController,
                    obscureText: !visibility,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.lock_outline, size: 18),
                      hintText: 'Confirm password',
                    ),
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
                  const SizedBox(height: 22),
                  AppButton(
                    label: 'Reset password',
                    onTap: () => _reset(accessToken, refreshToken),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
