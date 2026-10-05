import 'screens/auth/forgetpass_screen.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/auth/otp_screen.dart';
import 'theme/app_theme.dart';
import 'screens/auth/updatepass.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<void> main() async {
WidgetsFlutterBinding.ensureInitialized();
await GoogleSignIn.instance.initialize(  clientId: kIsWeb
        ? '713177752762-hg265s283k4kjjihtn2p691onopjpg7k.apps.googleusercontent.com'
        : null,
    // Android/iOS only: the Web-type client ID your backend verifies against
    serverClientId: kIsWeb
        ? null
        : '713177752762-g3t2glmtbvveref1q0m8jhl8o5utg1q5.apps.googleusercontent.com',
  );
  runApp(const MyApp());
} 

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Asset App',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: LoginScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/otp': (context) => const OTPScreen(),
        '/forgetPass': (context) => const ForgetPassScreen(),
        '/updatePass': (context) => const UpdatePassScreen(),
      },
    );
  }
}
