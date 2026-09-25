//import 'dart:nativewrappers/_internal/vm/lib/ffi_native_type_patch.dart';
import 'package:asset_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:asset_app/touchable_opacity.dart';
import 'package:asset_app/theme/app_theme.dart';
import 'package:asset_app/screens/auth/screen_arguments.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key});

  @override
  _OTPScreenState createState() => _OTPScreenState();

  @override
  String toStringShort() => 'OTP Screen';
}

class _OTPScreenState extends State<OTPScreen> {
  final pinController = TextEditingController();
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final extraColors = Theme.of(context).extension<AppExtraColors>()!;
    final rawArgs = ModalRoute.of(context)!.settings.arguments;

    if (rawArgs is! ScreenArguments) {
      return const Scaffold(
        body: Center(child: Text('Missing signup arguments')),
      );
    }

    final args = rawArgs;
    final name = args.name;
    final email = args.email;
    final password = args.password;
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: GoogleFonts.poppins(
        fontSize: 22,
        color: const Color.fromRGBO(30, 60, 87, 1),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: colors.primary),
      ),
    );

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                const SizedBox(height: 48),
                IconButton(
                  icon: const Icon(Icons.chevron_left, size: 48),
                  onPressed: () => Navigator.pushNamed(context, '/signup'),
                ),
                const SizedBox(height: 32),
                Text(
                  'Verify your email',
                  style: textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                    color: colors.onSurface,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'We sent a 6-digit code to',
                  style: TextStyle(
                    color: colors.onSurfaceVariant,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  email,
                  style: TextStyle(
                    color: colors.onSurfaceVariant,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                Directionality(
                  // Specify direction if desired
                  textDirection: TextDirection.ltr,
                  child: Pinput(
                    length: 6,
                    controller: pinController,
                    focusNode: focusNode,
                    defaultPinTheme: defaultPinTheme,
                    //change this validator to your own logic
                    validator: (value) {
                      if (value == null || value.length != 6) {
                        return 'Enter the 6-digit code';
                      }
                      return null;
                    },
                    hapticFeedbackType: HapticFeedbackType.lightImpact,
                    onCompleted: (pin) {
                      debugPrint('onCompleted: $pin');
                    },
                    onChanged: (value) {
                      debugPrint('onChanged: $value');
                    },
                    cursor: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 9),
                          width: 22,
                          height: 1,
                          color: colors.primary,
                        ),
                      ],
                    ),
                    focusedPinTheme: defaultPinTheme.copyWith(
                      decoration: defaultPinTheme.decoration!.copyWith(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: colors.primary),
                      ),
                    ),
                    submittedPinTheme: defaultPinTheme.copyWith(
                      decoration: defaultPinTheme.decoration!.copyWith(
                        color: colors.surface,
                        borderRadius: BorderRadius.circular(19),
                        border: Border.all(color: colors.primary),
                      ),
                    ),
                    errorPinTheme: defaultPinTheme.copyBorderWith(
                      border: Border.all(color: Colors.redAccent),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
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
                      'Verify',
                      style: textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colors.onPrimary,
                      ),
                    ),
                  ),
                  //change this onTap to your own logic to verify the otp
                  onTap: () async {
                    if (formKey.currentState?.validate() ?? false) {
                      // If the form is valid, navigate to the next screen
                      final result = await AuthService.verifyOtp(
                        email: email,
                        token: pinController.text,
                      );
                      if (!context.mounted) return;
                      if (result['success'] == true) {
                        Navigator.pushNamed(context, '/login');
                      } else {
                        final errorMessage =
                            result['data']?['error'] ?? 'Something went wrong';
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(errorMessage.toString())),
                        );
                      }
                    } else {
                      // If the form is invalid, display a snackbar or some feedback
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Invalid OTP')),
                      );
                    }
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    Text(
                      "Didn't get a code?",
                      style: TextStyle(
                        fontSize: 14,
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                    TouchableOpacity(
                      child: Text(
                        //textAlign: TextAlign.end,
                        ' Resend',
                        style: TextStyle(
                          color: extraColors.accentText,
                          fontSize: 14,
                        ),
                      ),
                      onTap: () async {
                        final result = await AuthService.signUp(
                          name: name,
                          email: email,
                          password: password,
                        );

                        if (!context.mounted) return;

                        if (result['success'] == true) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Code resent.')),
                          );
                        } else {
                          final errorMessage =
                              result['data']?['error'] ??
                              'Something went wrong';
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(errorMessage.toString())),
                          );
                        }
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
