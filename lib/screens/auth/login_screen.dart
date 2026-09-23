import 'package:flutter/material.dart';
import 'package:asset_app/touchable_opacity.dart';
import 'package:asset_app/theme/app_theme.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:email_validator/email_validator.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool visibility = false;
   bool isEmailValid(String email) {
      return EmailValidator.validate(email);
    }
  final emailController = TextEditingController();
final passwordController = TextEditingController();
@override
  void dispose() {
 
    emailController.dispose();
    passwordController.dispose();
    // ignore: avoid_print

    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    // Grab the theme's colors and text styles once, use them below.

    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final extraColors = Theme.of(context).extension<AppExtraColors>()!;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 48),
                // The yellow logo tile
                Container(
                  width: 56,
                  height: 56,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: colors.primary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(Icons.work_outline, color: colors.onPrimary),
                ),
                const SizedBox(height: 32),
                Text(
                  'Welcome back',
                  style: textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                    color: colors.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Log in to see your assets.',
                  style: TextStyle(
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
                Text(
                  'Password',
                  style: TextStyle(
                    color: colors.onSurfaceVariant,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  obscureText: visibility,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        visibility ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () => setState(() => visibility = !visibility),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TouchableOpacity(
                      child: Text(
                        //textAlign: TextAlign.end,
                        'Forgot password?',
                        style: TextStyle(
                          color: extraColors.accentText,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
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
                      'Log In',
                      style: textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colors.onPrimary,
                      ),
                    ),
                  ),
                  onTap: () {},
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: Divider(color: colors.outline)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        "Or",
                        style: TextStyle(
                          fontSize: 12,
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: colors.outline)),
                  ],
                ),

                const SizedBox(height: 16),
                SizedBox(
                  height: 48,
                  width: double.infinity,
                  child: SignInButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    Buttons.google,
                    onPressed: () {},
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
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    Text(
                      "New here?",
                      style: TextStyle(
                        fontSize: 14,
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                    TouchableOpacity(
                      child: Text(
                        //textAlign: TextAlign.end,
                        ' Create account',
                        style: TextStyle(
                          color: extraColors.accentText,
                          fontSize: 14,
                        ),
                      ),
                       onTap: () {Navigator.pushNamed(context, '/signup');},
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
