import 'package:flutter/material.dart';
import 'app_colors.dart';

// Holds the colors that ColorScheme has no slot for.
class AppExtraColors extends ThemeExtension<AppExtraColors> {
  const AppExtraColors({
    required this.gain,
    required this.gainBg,
    required this.lossBg,
    required this.accentText,
    required this.navActive,
  });

  final Color gain;
  final Color gainBg;
  final Color lossBg;
  final Color accentText;
  final Color navActive;

  @override
  AppExtraColors copyWith({
    Color? gain,
    Color? gainBg,
    Color? lossBg,
    Color? accentText,
    Color? navActive,
  }) {
    return AppExtraColors(
      gain: gain ?? this.gain,
      gainBg: gainBg ?? this.gainBg,
      lossBg: lossBg ?? this.lossBg,
      accentText: accentText ?? this.accentText,
      navActive: navActive ?? this.navActive,
    );
  }

  @override
  AppExtraColors lerp(ThemeExtension<AppExtraColors>? other, double t) {
    if (other is! AppExtraColors) return this;
    return AppExtraColors(
      gain: Color.lerp(gain, other.gain, t)!,
      gainBg: Color.lerp(gainBg, other.gainBg, t)!,
      lossBg: Color.lerp(lossBg, other.lossBg, t)!,
      accentText: Color.lerp(accentText, other.accentText, t)!,
      navActive: Color.lerp(navActive, other.navActive, t)!,
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
      primary: DarkColors.accent, // yellow button/tile
      onPrimary: DarkColors.onAccent, // dark text/icon ON the yellow
      secondary: DarkColors.accent,
      onSecondary: DarkColors.onAccent,
      error: DarkColors.loss, // loss text/icons
      onError: Colors.white,
      surface: DarkColors.background, // page background
      onSurface: DarkColors.text, // normal text
      onSurfaceVariant: DarkColors.mutedText, // muted text
      surfaceContainer: DarkColors.surface, // cards, home tiles
      surfaceContainerHighest: DarkColors.field, // inputs, unselected chips
      secondaryContainer: DarkColors.field, // export button background
      onSecondaryContainer: DarkColors.text, // export button label
      outline: DarkColors.border,
      outlineVariant: DarkColors.border, // dividers
    ),
    extensions: const [
      AppExtraColors(
        gain: DarkColors.gain,
        gainBg: DarkColors.gainBg,
        lossBg: DarkColors.lossBg,
        accentText: DarkColors.accentText,
        navActive: DarkColors.navActive,
      ),
    ],
  );

  static final ThemeData light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: LightColors.background,
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: LightColors.accent, // yellow button/tile
      onPrimary: LightColors.onAccent, // dark text/icon ON the yellow
      secondary: LightColors.accent,
      onSecondary: LightColors.onAccent,
      error: LightColors.loss, // loss text/icons
      onError: Colors.white,
      surface: LightColors.background, // page background
      onSurface: LightColors.text, // normal text
      onSurfaceVariant: LightColors.mutedText, // muted text
      surfaceContainer: LightColors.surface, // cards, home tiles
      surfaceContainerHighest: LightColors.field, // inputs, unselected chips
      secondaryContainer: LightColors.field, // export button background
      onSecondaryContainer: LightColors.text, // export button label
      outline: LightColors.border,
      outlineVariant: LightColors.border, // dividers
    ),
    extensions: const [
      AppExtraColors(
        gain: LightColors.gain,
        gainBg: LightColors.gainBg,
        lossBg: LightColors.lossBg,
        accentText: LightColors.accentText,
        navActive: LightColors.navActive,
      ),
    ],
  );
}