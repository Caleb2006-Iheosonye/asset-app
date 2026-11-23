import 'package:flutter/material.dart';
import 'package:asset_app/touchable_opacity.dart';
import 'package:asset_app/theme/app_theme.dart';
import 'package:asset_app/components/app_widgets.dart';
import 'package:email_validator/email_validator.dart';
import 'package:asset_app/services/screen_arguments.dart';
import 'package:asset_app/services/auth_service.dart';

class ForgetPassScreen extends StatefulWidget {
  const ForgetPassScreen({super.key});

  @override
  State<ForgetPassScreen> createState() => _ForgetPassScreenState();
}

class _ForgetPassScreenState extends State<ForgetPassScreen> {
  bool isEmailValid(String email) => EmailValidator.validate(email);

  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<void> _sendCode() async {
    final email = emailController.text;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
    final result = await AuthService.forgetpass(email: email);
    if (!mounted) return;
    Navigator.pop(context); // close loading dialog

    if (result['success'] == true) {
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
      final errorMessage = result['data']?['error'] ?? 'Something went wrong';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage.toString())),
      );
    }
  }

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
                const AuthBackButton(),
                const SizedBox(height: 4),
                Text(
                  'Forgot password?',
                  style: textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Enter your account email and we'll send a 6 digit code to reset it.",
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
                const SizedBox(height: 22),
                AppButton(label: 'Send code', onTap: _sendCode),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Remember your password? ',
                      style: TextStyle(
                        fontSize: 13,
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                    TouchableOpacity(
                      onTap: () => Navigator.pushNamed(context, '/login'),
                      child: Text(
                        'Log in',
                        style: TextStyle(
                          color: extraColors.accentText,
                          fontSize: 13,
                        ),
                      ),
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
