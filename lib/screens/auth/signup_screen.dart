import 'package:flutter/material.dart';
import 'package:asset_app/touchable_opacity.dart';
import 'package:asset_app/theme/app_theme.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:email_validator/email_validator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool visibility = false;
  bool terms = false;
  bool isEmailValid(String email) {
    return EmailValidator.validate(email);
  }

  String password = '';
  int passwordStrength = 0; // 0 = none, 1 = weak, 2 = medium, 3 = strong
  int calculateStrength(String password) {
    int strength = 0;
    if (password.length >= 8) strength++;
    if (password.contains(RegExp(r'[A-Z]'))) strength++;
    if (password.contains(RegExp(r'[0-9]'))) strength++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength++;
    return strength; // 0-4
  }

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    // ignore: avoid_print
    print('Dispose used');
    super.dispose();
  }
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    
    final response = await http.post(
      Uri.parse('http://localhost:3000/api/auth/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      // navigate or show success
      print('Signup successful: ${response.body}');
    } else {
      // show error
      print('Signup failed: ${response.body}');
    }
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

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TouchableOpacity(
                      child: Container(
                        width: 56,
                        height: 56,
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.chevron_left,
                          size: 48,

                          //color: colors.onPrimary,
                        ),
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, '/login');
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Text(
                  'Create your account',
                  style: textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                    color: colors.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Track every asset in one place.',
                  style: TextStyle(
                    color: colors.onSurfaceVariant,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Full name',
                  style: TextStyle(
                    color: colors.onSurfaceVariant,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person_outline),
                    filled: true,
                    fillColor: colors.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: colors.outline),
                    ),

                    hintText: 'Enter your full name',
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
                const SizedBox(height: 16),
                Row(
                  children: [
                    SizedBox(
                      height: 20,
                      width: 20,
                      child: Checkbox(
                        value: terms,
                        activeColor: colors.secondary,
                        onChanged: (value) {
                          setState(() => terms = value ?? false);
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "I agree to the Terms and Conditions",
                      style: TextStyle(
                        fontSize: 13,
                        color: colors.onSurfaceVariant,
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
                      'Create account',
                      style: textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colors.onPrimary,
                      ),
                    ),
                  ),
                  onTap: () async { {
                    if (nameController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter your full name.'),
                        ),
                      );
                      return;
                    } else if (!isEmailValid(emailController.text)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please enter a valid email address.'),
                        ),
                      );
                      return;
                    } else if (passwordStrength < 4) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Password is too weak. Please make it stronger.',
                          ),
                        ),
                      );
                      return;
                    } else if (!terms) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'You must agree to the Terms and Conditions.',
                          ),
                        ),
                      );
                      return;
                    } else {
                      final name = nameController.text;
                      final email = emailController.text;
                      final pass = passwordController.text;
                        showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
                       await signUp(name: name, email: email, password: pass);
                    }

                    /* */
                  }},
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    Text(
                      "Already have an account?",
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
