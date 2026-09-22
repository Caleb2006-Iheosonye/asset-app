import 'package:flutter/material.dart';
import 'app_colors.dart';

// Holds the colors that ColorScheme has no slot for (gain, accentText).
class AppExtraColors extends ThemeExtension<AppExtraColors> {
  const AppExtraColors({required this.gain, required this.accentText});

  final Color gain;
  final Color accentText;

  // Flutter requires these two methods. Copy them as they are.
  @override
  AppExtraColors copyWith({Color? gain, Color? accentText}) {
    return AppExtraColors(
      gain: gain ?? this.gain,
      accentText: accentText ?? this.accentText,
    );
  }

  @override
  AppExtraColors lerp(ThemeExtension<AppExtraColors>? other, double t) {
    if (other is! AppExtraColors) return this;
    return AppExtraColors(
      gain: Color.lerp(gain, other.gain, t)!,
      accentText: Color.lerp(accentText, other.accentText, t)!,
    );
  }
}

class AppTheme {
  static final ThemeData dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: DarkColors.background,
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: DarkColors.accent,          // yellow button/tile
      onPrimary: DarkColors.background,    // dark text/icon ON the yellow
      secondary: DarkColors.accent,
      onSecondary: DarkColors.background,
      error: DarkColors.loss,
      onError: Colors.white,
      surface: DarkColors.background,
      onSurface: DarkColors.text,          // normal text
      onSurfaceVariant: DarkColors.mutedText,  // muted text
      outline: DarkColors.border,
    ),
    extensions: const [
      AppExtraColors(
        gain: DarkColors.gain,
        accentText: DarkColors.accentText,
      ),
    ],
  );

  // Copy the whole `dark` block, rename it `light`, and swap every
  // DarkColors to LightColors and Brightness.dark to Brightness.light.
  static final ThemeData light = ThemeData(
    // ...same as dark, with LightColors
     useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: LightColors.background,
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: LightColors.accent,          // yellow button/tile
      onPrimary: LightColors.background,    // dark text/icon ON the yellow
      secondary: LightColors.accent,
      onSecondary: LightColors.background,
      error: LightColors.loss,
      onError: Colors.white,
      surface: LightColors.background,
      onSurface: LightColors.text,          // normal text
      onSurfaceVariant: LightColors.mutedText,  // muted text
      outline: LightColors.border,
    ),
    extensions: const [
      AppExtraColors(
        gain: LightColors.gain,
        accentText: LightColors.accentText,
      ),
    ],
  );
}