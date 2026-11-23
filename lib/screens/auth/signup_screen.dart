import 'package:flutter/material.dart';
import 'package:asset_app/touchable_opacity.dart';
import 'package:asset_app/theme/app_theme.dart';
import 'package:asset_app/components/app_widgets.dart';
import 'package:email_validator/email_validator.dart';
import 'package:asset_app/services/screen_arguments.dart';
import 'package:asset_app/services/auth_service.dart';
import 'package:asset_app/services/google_sign_in_flow.dart';
import 'package:sign_in_button/sign_in_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool visibility = false;
  bool terms = false;
  bool isEmailValid(String email) => EmailValidator.validate(email);

  int passwordStrength = 0; // 0 to 4
  int calculateStrength(String password) {
    int strength = 0;
    if (password.length >= 8) strength++;
    if (password.contains(RegExp(r'[A-Z]'))) strength++;
    if (password.contains(RegExp(r'[0-9]'))) strength++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength++;
    return strength;
  }

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _snack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _submit() async {
    if (firstNameController.text.trim().isEmpty) {
      _snack('Please enter your first name.');
      return;
    } else if (lastNameController.text.trim().isEmpty) {
      _snack('Please enter your last name.');
      return;
    } else if (!isEmailValid(emailController.text)) {
      _snack('Please enter a valid email address.');
      return;
    } else if (passwordStrength < 4) {
      _snack('Password is too weak. Please make it stronger.');
      return;
    } else if (!terms) {
      _snack('You must agree to the Terms of Use and Privacy Policy.');
      return;
    }

    final firstName = firstNameController.text;
    final lastName = lastNameController.text;
    final email = emailController.text;
    final pass = passwordController.text;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    final result = await AuthService.signUp(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: pass,
    );

    if (!mounted) return;
    Navigator.pop(context); // close loading dialog

    if (result['success'] == true) {
      Navigator.pushNamed(
        context,
        '/otp',
        arguments: ScreenArguments(
          type: 'signup',
          firstName: firstName,
          lastName: lastName,
          email: email,
          password: pass,
        ),
      );
    } else {
      _snack((result['data']?['error'] ?? 'Something went wrong').toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final extraColors = Theme.of(context).extension<AppExtraColors>()!;
    final linkStyle = TextStyle(color: extraColors.accentText);

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
                  'Create your account',
                  style: textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Track every asset in one place.',
                  style: TextStyle(color: colors.onSurfaceVariant, fontSize: 14),
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const FieldLabel('First name'),
                          TextField(
                            controller: firstNameController,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.person_outline, size: 18),
                              hintText: 'First name',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const FieldLabel('Last name'),
                          TextField(
                            controller: lastNameController,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.person_outline, size: 18),
                              hintText: 'Last name',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const FieldLabel('Email'),
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.mail_outline, size: 18),
                    hintText: 'name@example.com',
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
                      onPressed: () => setState(() => visibility = !visibility),
                    ),
                    hintText: 'Enter your password',
                  ),
                ),
                StrengthBar(strength: passwordStrength),
                const SizedBox(height: 6),
                Text(
                  'Use 8 or more characters with a number.',
                  style: TextStyle(fontSize: 12, color: colors.onSurfaceVariant),
                ),
                const SizedBox(height: 18),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                      width: 20,
                      child: Checkbox(
                        value: terms,
                        visualDensity: VisualDensity.compact,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        onChanged: (v) => setState(() => terms = v ?? false),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          style: TextStyle(
                            fontSize: 13,
                            color: colors.onSurfaceVariant,
                          ),
                          children: [
                            const TextSpan(text: 'I agree to the '),
                            TextSpan(text: 'Terms of Use', style: linkStyle),
                            const TextSpan(text: ' and '),
                            TextSpan(text: 'Privacy Policy', style: linkStyle),
                            const TextSpan(text: '.'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                AppButton(label: 'Create account', onTap: _submit),
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
                const SizedBox(height: 18),
                SizedBox(
                  height: 48,
                  width: double.infinity,
                  child: SignInButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    Buttons.google,
                    onPressed: () => googleSignInFlow(context),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
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
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
