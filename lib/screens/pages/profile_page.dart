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
  static const bool showIcons = false;
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
    final textTheme = Theme.of(context).textTheme;
    // Kept so your theme extension stays available on this screen
    // ignore: unused_local_variable
    final extraColors = Theme.of(context).extension<AppExtraColors>()!;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Profile'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),

                // Header
                Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: colors.primary,
                      child: Text(
                        _initials(fullName, username),
                        style: textTheme.headlineMedium?.copyWith(
                          color: colors.onPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            fullName,
                            style: textTheme.headlineSmall?.copyWith(
                              color: colors.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            email,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.bodyMedium?.copyWith(
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
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: colors.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          'Edit',
                          style: textTheme.labelLarge?.copyWith(
                            color: colors.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Stat cards
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _statCard(colors, textTheme, '11', 'Assets'),
                      const SizedBox(width: 8),
                      _statCard(colors, textTheme, '4', 'Categories'),
                      const SizedBox(width: 8),
                      _statCard(colors, textTheme, 'Jan 2025', 'Member since'),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Account
                _sectionLabel('Account', textTheme, colors),
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

                const SizedBox(height: 24),

                // Preferences
                _sectionLabel('Preferences', textTheme, colors),
                _settingsRow(
                  icon: Icons.language,
                  title: 'Currency',
                  value: 'USD',
                  colors: colors,
                  onTap: () {},
                ),

                const SizedBox(height: 24),

                // Appearance
                _sectionLabel('Appearance', textTheme, colors),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: colors.surfaceContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: List.generate(themeOptions.length, (i) {
                      final selected = themeIndex == i;
                      return Expanded(
                        child: TouchableOpacity(
                          onTap: () => setState(() => themeIndex = i),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: selected
                                  ? colors.primary
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              themeOptions[i],
                              style: TextStyle(
                                color: selected
                                    ? colors.onPrimary
                                    : colors.onSurfaceVariant,
                                fontWeight: selected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),

                const SizedBox(height: 24),

                // Data
                _sectionLabel('Data', textTheme, colors),
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

  Widget _statCard(
    ColorScheme colors,
    TextTheme textTheme,
    String top,
    String bottom,
  ) {
    return Expanded(
      child: Card(
        color: colors.surfaceContainer,
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                top,
                textAlign: TextAlign.center,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colors.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                bottom,
                textAlign: TextAlign.center,
                style: textTheme.bodySmall?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(String text, TextTheme textTheme, ColorScheme colors) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
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
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            if (showIcons) ...[
              Icon(icon, color: color ?? colors.onSurfaceVariant),
              const SizedBox(width: 16),
            ],
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: contentColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (value != null)
              Text(
                value,
                style: TextStyle(color: colors.onSurfaceVariant, fontSize: 15),
              ),
            if (showChevrons && showChevron) ...[
              const SizedBox(width: 4),
              Icon(Icons.chevron_right, color: colors.onSurfaceVariant),
            ],
          ],
        ),
      ),
    );
  }
}