import 'package:asset_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:asset_app/touchable_opacity.dart';
import 'package:asset_app/theme/app_theme.dart';
import 'package:asset_app/components/app_widgets.dart';
import 'package:email_validator/email_validator.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:asset_app/services/google_sign_in_flow.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool visibility = false;
  bool isEmailValid(String email) => EmailValidator.validate(email);

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _snack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _login() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
    final result = await AuthService.login(
      email: emailController.text,
      password: passwordController.text,
    );

    if (!mounted) return;
    Navigator.pop(context); // close loading dialog
    if (result['success'] == true) {
      Navigator.pushNamed(context, '/home_page');
    } else {
      _snack((result['data']?['error'] ?? 'Something went wrong').toString());
    }
  }

  Future<void> _googleLogin() => googleSignInFlow(context);

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final extraColors = Theme.of(context).extension<AppExtraColors>()!;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 32),
                Container(
                  width: 48,
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: colors.primary,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.work_outline,
                    size: 24,
                    color: colors.onPrimary,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Welcome back',
                  style: textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Log in to see your assets.',
                  style: TextStyle(color: colors.onSurfaceVariant, fontSize: 14),
                ),
                const SizedBox(height: 16),
                const FieldLabel('Email'),
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.mail_outline, size: 18),
                    hintText: 'Enter your email',
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email cannot be empty';
                    } else if (!isEmailValid(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const FieldLabel('Password'),
                TextField(
                  controller: passwordController,
                  obscureText: !visibility,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock_outline, size: 18),
                    suffixIcon: IconButton(
                      icon: Icon(
                        visibility
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        size: 18,
                      ),
                      onPressed: () => setState(() => visibility = !visibility),
                    ),
                    hintText: 'Enter your password',
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: TouchableOpacity(
                    onTap: () => Navigator.pushNamed(context, '/forgetPass'),
                    child: Text(
                      'Forgot password?',
                      style: TextStyle(
                        color: extraColors.accentText,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                AppButton(label: 'Log in', onTap: _login),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(child: Divider(color: colors.outline)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'or',
                        style: TextStyle(
                          fontSize: 12,
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: colors.outline)),
                  ],
                ),
                const SizedBox(height: 6),
                const SizedBox(height: 12),
                SizedBox(
                  height: 48,
                  width: double.infinity,
                  child: SignInButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    Buttons.google,
                    onPressed: _googleLogin,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 48,
                  width: double.infinity,
                  child: SignInButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    Buttons.apple,
                    onPressed: () {},
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'New here? ',
                      style: TextStyle(
                        fontSize: 13,
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                    TouchableOpacity(
                      onTap: () => Navigator.pushNamed(context, '/signup'),
                      child: Text(
                        'Create account',
                        style: TextStyle(
                          color: extraColors.accentText,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
