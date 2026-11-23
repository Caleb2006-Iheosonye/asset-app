import 'package:asset_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:asset_app/touchable_opacity.dart';
import 'package:asset_app/theme/app_theme.dart';
import 'package:asset_app/components/app_widgets.dart';
import 'package:asset_app/services/screen_arguments.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final pinController = TextEditingController();
  final focusNode = FocusNode();
  String? otpError;

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  void _snack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _showLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
  }

  Future<void> _verify(ScreenArguments args) async {
    if (pinController.text.length != 6) {
      setState(() => otpError = 'Enter the 6 digit code');
      return;
    }
    _showLoading();
    Map<String, dynamic>? result;
    try {
      result = await AuthService.verifyOtp(
        email: args.email,
        token: pinController.text,
        type: args.type,
      );
    } catch (e) {
      result = null;
    } finally {
      if (mounted) Navigator.pop(context); // close dialog
    }

    if (!mounted) return;
    if (result == null) {
      _snack('Network error. Try again.');
      return;
    }
    if (result['success'] == true && args.type == 'signup') {
      Navigator.pushNamed(context, '/login');
    } else if (result['success'] == true && args.type == 'recovery') {
      // recovery: pull the session tokens out of the response
      final session = result['data']?['data']?['session'];
      final accessToken = session?['access_token'];
      final refreshToken = session?['refresh_token'];

      if (accessToken == null || refreshToken == null) {
        _snack('Could not start a reset session.');
        return;
      }

      Navigator.pushReplacementNamed(
        context,
        '/updatePass',
        arguments: ScreenArguments(
          type: args.type,
          firstName: '',
          lastName: '',
          email: args.email,
          password: '',
          accessToken: accessToken,
          refreshToken: refreshToken,
        ),
      );
    } else {
      setState(() => otpError = 'That code did not work. Try again.');
      _snack((result['data']?['error'] ?? 'Something went wrong').toString());
    }
  }

  Future<void> _resend(ScreenArguments args) async {
    if (args.type != 'signup' && args.type != 'recovery') return;
    _showLoading();

    Map<String, dynamic> result;
    try {
      if (args.type == 'signup') {
        result = await AuthService.signUp(
          firstName: args.firstName,
          lastName: args.lastName,
          email: args.email,
          password: args.password,
        );
      } else {
        result = await AuthService.forgetpass(email: args.email);
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // close dialog
      _snack('Network error. Try again.');
      return;
    }

    if (!mounted) return;
    Navigator.pop(context); // close loading dialog
    if (result['success'] == true) {
      pinController.clear();
      setState(() => otpError = null);
      _snack('Code resent.');
    } else {
      _snack((result['data']?['error'] ?? 'Something went wrong').toString());
    }
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
    final isSignup = args.type == 'signup';

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AuthBackButton(),
              const SizedBox(height: 4),
              Text(
                isSignup ? 'Verify your email' : 'Enter reset code',
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'We sent a 6 digit code to\n${args.email}',
                style: TextStyle(color: colors.onSurfaceVariant, fontSize: 14),
              ),
              const SizedBox(height: 22),
              // Six square boxes that share the width, 8px apart.
              LayoutBuilder(
                builder: (context, constraints) {
                  final box = (constraints.maxWidth - 5 * 8) / 6;

                  final base = PinTheme(
                    width: box,
                    height: box,
                    textStyle: GoogleFonts.ibmPlexSans(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: colors.onSurface,
                    ),
                    decoration: BoxDecoration(
                      color: colors.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.transparent),
                    ),
                  );

                  return Directionality(
                    textDirection: TextDirection.ltr,
                    child: Pinput(
                      length: 6,
                      controller: pinController,
                      focusNode: focusNode,
                      defaultPinTheme: base,
                      forceErrorState: otpError != null,
                      hapticFeedbackType: HapticFeedbackType.lightImpact,
                      onChanged: (_) {
                        if (otpError != null) setState(() => otpError = null);
                      },
                      cursor: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 9),
                            width: 16,
                            height: 2,
                            color: colors.primary,
                          ),
                        ],
                      ),
                      focusedPinTheme: base.copyWith(
                        decoration: base.decoration!.copyWith(
                          border: Border.all(color: colors.primary),
                        ),
                      ),
                      errorPinTheme: base.copyWith(
                        decoration: base.decoration!.copyWith(
                          border: Border.all(color: colors.error),
                        ),
                      ),
                    ),
                  );
                },
              ),
              // Reserved 20px line so the layout does not jump on error.
              SizedBox(
                height: 20,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    otpError ?? '',
                    style: TextStyle(color: colors.error, fontSize: 12),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              AppButton(
                label: isSignup ? 'Verify' : 'Verify code',
                onTap: () => _verify(args),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Didn't get a code? ",
                    style: TextStyle(
                      fontSize: 13,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                  TouchableOpacity(
                    onTap: () => _resend(args),
                    child: Text(
                      'Resend',
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
    );
  }
}
