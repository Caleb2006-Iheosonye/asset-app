// Put this file at lib/services/google_sign_in_flow.dart
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:asset_app/services/auth_service.dart';

/// The Google sign in flow from the login page, shared so login and signup
/// both use exactly the same code.
Future<void> googleSignInFlow(BuildContext context) async {
  void snack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  String? idToken;

  // 1. Open Google's account picker and get the ID token
  try {
    final account = await GoogleSignIn.instance.authenticate();
    idToken = account.authentication.idToken;
  } on GoogleSignInException catch (e) {
    if (e.code == GoogleSignInExceptionCode.canceled) return; // user closed the picker
    if (!context.mounted) return;
    snack('Google sign-in failed');
    return;
  } catch (_) {
    if (!context.mounted) return;
    snack('Google sign-in failed');
    return;
  }

  // 2. Make sure we actually got a token
  if (idToken == null || idToken.isEmpty) {
    if (!context.mounted) return;
    snack('Failed to authenticate user.');
    return;
  }

  // 3. Spinner only for the backend call
  if (!context.mounted) return;
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const Center(child: CircularProgressIndicator()),
  );

  Map<String, dynamic> result;
  try {
    result = await AuthService.googleSignIn(idToken: idToken);
  } catch (_) {
    result = {
      'success': false,
      'data': {'error': 'Could not reach the server. Try again.'},
    };
  }

  if (!context.mounted) return;
  Navigator.pop(context); // close spinner

  // 4. Same handling as the password login
  if (result['success'] == true) {
    Navigator.pushNamed(context, '/home_page');
  } else {
    final errorMessage = result['data']?['error'] ?? 'Something went wrong';
    snack(errorMessage.toString());
  }
}
