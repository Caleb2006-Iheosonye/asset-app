import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  // Shared shape of both themes: IBM Plex Sans, radius 10 fields and buttons,
  // radius 16 flat cards, filled borderless inputs with a yellow focus border.
  static ThemeData _build({
    required Brightness brightness,
    required ColorScheme scheme,
    required AppExtraColors extra,
    required Color background,
    required Color surface,
    required Color field,
    required Color border,
    required Color text,
    required Color mutedText,
    required Color accent,
    required Color onAccent,
  }) {
    final base = ThemeData(brightness: brightness);
    final textTheme = GoogleFonts.ibmPlexSansTextTheme(
      base.textTheme,
    ).apply(bodyColor: text, displayColor: text);

    OutlineInputBorder inputBorder(Color c, double w) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: w == 0 ? BorderSide.none : BorderSide(color: c, width: w),
    );

    final buttonShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    );
    final buttonText = GoogleFonts.ibmPlexSans(
      fontSize: 15,
      fontWeight: FontWeight.w500,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: background,
      colorScheme: scheme,
      textTheme: textTheme,
      extensions: [extra],
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleSpacing: 16,
        titleTextStyle: GoogleFonts.ibmPlexSans(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: text,
        ),
        iconTheme: IconThemeData(color: text),
        actionsIconTheme: IconThemeData(color: text),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: field,
        isDense: false,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        hintStyle: TextStyle(color: mutedText, fontSize: 14),
        prefixIconColor: mutedText,
        suffixIconColor: mutedText,
        border: inputBorder(border, 0),
        enabledBorder: inputBorder(border, 0),
        focusedBorder: inputBorder(accent, 1),
        errorBorder: inputBorder(scheme.error, 1),
        focusedErrorBorder: inputBorder(scheme.error, 1),
      ),
      dividerTheme: DividerThemeData(color: border, thickness: 1, space: 1),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: onAccent,
          minimumSize: const Size.fromHeight(48),
          shape: buttonShape,
          textStyle: buttonText,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          shape: buttonShape,
          textStyle: buttonText,
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        fillColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? accent : Colors.transparent,
        ),
        checkColor: WidgetStatePropertyAll(onAccent),
        side: BorderSide(color: border, width: 1.5),
      ),
    );
  }

  static final ThemeData dark = _build(
    brightness: Brightness.dark,
    background: DarkColors.background,
    surface: DarkColors.surface,
    field: DarkColors.field,
    border: DarkColors.border,
    text: DarkColors.text,
    mutedText: DarkColors.mutedText,
    accent: DarkColors.accent,
    onAccent: DarkColors.onAccent,
    scheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: DarkColors.accent,
      onPrimary: DarkColors.onAccent,
      secondary: DarkColors.accent,
      onSecondary: DarkColors.onAccent,
      error: DarkColors.loss,
      onError: Colors.white,
      surface: DarkColors.background,
      onSurface: DarkColors.text,
      onSurfaceVariant: DarkColors.mutedText,
      surfaceContainer: DarkColors.surface,
      surfaceContainerHighest: DarkColors.field,
      secondaryContainer: DarkColors.field,
      onSecondaryContainer: DarkColors.text,
      outline: DarkColors.border,
      outlineVariant: DarkColors.border,
    ),
    extra: const AppExtraColors(
      gain: DarkColors.gain,
      gainBg: DarkColors.gainBg,
      lossBg: DarkColors.lossBg,
      accentText: DarkColors.accentText,
      navActive: DarkColors.navActive,
    ),
  );

  static final ThemeData light = _build(
    brightness: Brightness.light,
    background: LightColors.background,
    surface: LightColors.surface,
    field: LightColors.field,
    border: LightColors.border,
    text: LightColors.text,
    mutedText: LightColors.mutedText,
    accent: LightColors.accent,
    onAccent: LightColors.onAccent,
    scheme: const ColorScheme(
      brightness: Brightness.light,
      primary: LightColors.accent,
      onPrimary: LightColors.onAccent,
      secondary: LightColors.accent,
      onSecondary: LightColors.onAccent,
      error: LightColors.loss,
      onError: Colors.white,
      surface: LightColors.background,
      onSurface: LightColors.text,
      onSurfaceVariant: LightColors.mutedText,
      surfaceContainer: LightColors.surface,
      surfaceContainerHighest: LightColors.field,
      secondaryContainer: LightColors.field,
      onSecondaryContainer: LightColors.text,
      outline: LightColors.border,
      outlineVariant: LightColors.border,
    ),
    extra: const AppExtraColors(
      gain: LightColors.gain,
      gainBg: LightColors.gainBg,
      lossBg: LightColors.lossBg,
      accentText: LightColors.accentText,
      navActive: LightColors.navActive,
    ),
  );
}
