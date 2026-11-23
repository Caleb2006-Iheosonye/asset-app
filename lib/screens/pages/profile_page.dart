import 'package:flutter/material.dart';
import 'package:asset_app/theme/app_theme.dart';
import 'package:asset_app/touchable_opacity.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  // Display switches
  static const bool showIcons = true; // the design shows leading icons
  static const bool showChevrons = true;
  static const bool showDividers = true;

  final String fullName = 'Caleb';
  final String username = 'caleb';
  final String email = 'caleb@example.com';

  int themeIndex = 0; // 0 System, 1 Light, 2 Dark
  final List<String> themeOptions = ['System', 'Light', 'Dark'];

  String _initials(String name, String username) {
    final source = name.trim().isNotEmpty ? name.trim() : username.trim();
    if (source.isEmpty) return '?';
    final parts = source
        .split(RegExp(r'[\s_.\-]+'))
        .where((p) => p.isNotEmpty)
        .toList();
    final first = parts.first.characters.first;
    final last = parts.length > 1 ? parts.last.characters.first : '';
    return (first + last).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 56,
        title: const Text('Profile'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none, size: 22),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 8),

                // Header
                Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: colors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        _initials(fullName, username),
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: colors.onPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            fullName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            email,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13,
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TouchableOpacity(
                      onTap: () {
                        // Handle edit profile action
                      },
                      child: Container(
                        height: 32,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: colors.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          'Edit',
                          style: TextStyle(
                            fontSize: 13,
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Stat cards
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _statCard(colors, '11', 'Assets'),
                      const SizedBox(width: 8),
                      _statCard(colors, '4', 'Categories'),
                      const SizedBox(width: 8),
                      _statCard(colors, 'Jan 2025', 'Member since'),
                    ],
                  ),
                ),

                // Account
                _sectionLabel('Account', colors),
                _settingsRow(
                  icon: Icons.person_outline,
                  title: 'Personal details',
                  colors: colors,
                  onTap: () {},
                ),
                _divider(colors),
                _settingsRow(
                  icon: Icons.shield_outlined,
                  title: 'Security',
                  value: 'Two factor on',
                  colors: colors,
                  onTap: () {},
                ),
                _divider(colors),
                _settingsRow(
                  icon: Icons.notifications_none,
                  title: 'Notifications',
                  colors: colors,
                  onTap: () {},
                ),

                // Preferences, with the appearance switch under Currency
                _sectionLabel('Preferences', colors),
                _settingsRow(
                  icon: Icons.language,
                  title: 'Currency',
                  value: 'USD',
                  colors: colors,
                  onTap: () {},
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(
                    'Appearance',
                    style: TextStyle(
                      fontSize: 12,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: colors.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: List.generate(themeOptions.length, (i) {
                      final selected = themeIndex == i;
                      return Expanded(
                        child: TouchableOpacity(
                          onTap: () => setState(() => themeIndex = i),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: selected
                                  ? colors.primary
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              themeOptions[i],
                              style: TextStyle(
                                fontSize: 13,
                                color: selected
                                    ? colors.onPrimary
                                    : colors.onSurfaceVariant,
                                fontWeight: selected
                                    ? FontWeight.w500
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),

                // Data
                _sectionLabel('Data', colors),
                _settingsRow(
                  icon: Icons.download_outlined,
                  title: 'Export assets as CSV',
                  colors: colors,
                  onTap: () {},
                ),
                _divider(colors),
                _settingsRow(
                  icon: Icons.logout,
                  title: 'Sign out',
                  colors: colors,
                  color: colors.error,
                  showChevron: false,
                  onTap: () {},
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _statCard(ColorScheme colors, String top, String bottom) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colors.surfaceContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              top,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            Text(
              bottom,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: colors.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String text, ColorScheme colors) {
    return Padding(
      padding: const EdgeInsets.only(top: 22, bottom: 4),
      child: Text(
        text,
        style: TextStyle(fontSize: 13, color: colors.onSurfaceVariant),
      ),
    );
  }

  Widget _divider(ColorScheme colors) {
    if (!showDividers) return const SizedBox.shrink();
    return Divider(height: 1, thickness: 1, color: colors.outlineVariant);
  }

  Widget _settingsRow({
    required IconData icon,
    required String title,
    required ColorScheme colors,
    required VoidCallback onTap,
    String? value,
    Color? color,
    bool showChevron = true,
  }) {
    final contentColor = color ?? colors.onSurface;

    return TouchableOpacity(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            if (showIcons) ...[
              Icon(icon, size: 20, color: color ?? colors.onSurfaceVariant),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontSize: 14, color: contentColor),
              ),
            ),
            if (value != null)
              Text(
                value,
                style: TextStyle(color: colors.onSurfaceVariant, fontSize: 14),
              ),
            if (showChevrons && showChevron) ...[
              const SizedBox(width: 4),
              Icon(Icons.chevron_right, size: 18, color: colors.onSurfaceVariant),
            ],
          ],
        ),
      ),
    );
  }
}
