import 'package:flutter/material.dart';

// Color(0xAARRGGBB): the first two digits are opacity (FF = fully opaque),
// the next six are the hex. Tint opacity: 14% = 0x24, 10% = 0x1A.

class DarkColors {
  static const background = Color(0xFF0B0E11);
  static const surface = Color(0xFF181A20); // cards, home tiles
  static const field = Color(0xFF1E2329); // inputs, chips, export button
  static const border = Color(0xFF2B3139);
  static const text = Color(0xFFEAECEF);
  static const mutedText = Color(0xFF848E9C);
  static const accent = Color(0xFFFCD535);
  static const onAccent = Color(0xFF181A20); // text/icon on the yellow
  static const accentText = Color(0xFFFCD535); // links, "Manage", "View all"
  static const navActive = Color(0xFFFCD535); // selected bottom-bar tab
  static const gain = Color(0xFF0ECB81);
  static const gainBg = Color(0x240ECB81); // 14%
  static const loss = Color(0xFFF6465D);
  static const lossBg = Color(0x24F6465D); // 14%
}

class LightColors {
  static const background = Color(0xFFFFFFFF);
  static const surface = Color(0xFFF5F5F5); // cards, home tiles
  static const field = Color(0xFFF5F5F5); // inputs, chips, export button
  static const border = Color(0xFFEAECEF);
  static const text = Color(0xFF1E2329);
  static const mutedText = Color(0xFF707A8A);
  static const accent = Color(0xFFFCD535);
  static const onAccent = Color(0xFF181A20); // text/icon on the yellow
  static const accentText = Color(0xFF8A6A00); // links, "Manage", "View all"
  static const navActive = Color(0xFF1E2329); // selected bottom-bar tab
  static const gain = Color(0xFF078A55);
  static const gainBg = Color(0x1A078A55); // 10%
  static const loss = Color(0xFFD9304A);
  static const lossBg = Color(0x1AD9304A); // 10%
}

// Same in dark and light, so they live outside the themes.
class CategoryColors {
  static const stocks = Color(0xFF7F77DD);
  static const crypto = Color(0xFFF7931A);
  static const bonds = Color(0xFF0ECB81);
  static const cash = Color(0xFF848E9C);

  // Badge background = the category color at 18% opacity.
  static const badgeAlpha = 0.18;
  static Color badgeBg(Color c) => c.withValues(alpha: badgeAlpha);
}