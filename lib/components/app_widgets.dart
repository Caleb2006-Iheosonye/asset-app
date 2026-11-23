// Put this file at lib/widgets/app_widgets.dart
import 'package:flutter/material.dart';
import 'package:asset_app/theme/app_theme.dart';
import 'package:asset_app/touchable_opacity.dart';

const _tabular = [FontFeature.tabularFigures()];

/// 12px muted label above a field, 6px gap.
class FieldLabel extends StatelessWidget {
  const FieldLabel(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

/// 52px header row holding a small back chevron (auth screens).
class AuthBackButton extends StatelessWidget {
  const AuthBackButton({super.key, this.onPressed});
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: Align(
        alignment: Alignment.centerLeft,
        child: IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints.tightFor(width: 36, height: 36),
          icon: const Icon(Icons.chevron_left, size: 28),
          onPressed: onPressed ?? () => Navigator.pop(context),
        ),
      ),
    );
  }
}

enum AppButtonStyle { primary, secondary, outline, danger }

/// 48px high, radius 10 button.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onTap,
    this.style = AppButtonStyle.primary,
    this.icon,
    this.leading,
  });

  final String label;
  final VoidCallback onTap;
  final AppButtonStyle style;
  final IconData? icon;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    late final Color bg;
    late final Color fg;
    Color? border;
    switch (style) {
      case AppButtonStyle.primary:
        bg = c.primary;
        fg = c.onPrimary;
      case AppButtonStyle.secondary:
        bg = c.secondaryContainer;
        fg = c.onSecondaryContainer;
      case AppButtonStyle.outline:
        bg = Colors.transparent;
        fg = c.onSurface;
        border = c.outline;
      case AppButtonStyle.danger:
        bg = Colors.transparent;
        fg = c.error;
        border = c.error;
    }

    return TouchableOpacity(
      onTap: onTap,
      child: Container(
        height: 48,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10),
          border: border == null ? null : Border.all(color: border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (leading != null) ...[leading!, const SizedBox(width: 8)],
            if (icon != null) ...[
              Icon(icon, size: 18, color: fg),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: fg,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Small round letter badge used on the Google and Apple buttons.
class LetterBadge extends StatelessWidget {
  const LetterBadge(this.letter, {super.key});
  final String letter;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return Container(
      width: 20,
      height: 20,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: c.surfaceContainerHighest,
        shape: BoxShape.circle,
      ),
      child: Text(letter, style: const TextStyle(fontSize: 12)),
    );
  }
}

/// Category color at 18% opacity behind a colored icon.
class CategoryBadge extends StatelessWidget {
  const CategoryBadge({
    super.key,
    required this.color,
    required this.icon,
    this.size = 36,
    this.square = false,
  });

  final Color color;
  final IconData icon;
  final double size;
  final bool square;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.18),
        shape: square ? BoxShape.rectangle : BoxShape.circle,
        borderRadius: square ? BorderRadius.circular(8) : null,
      ),
      child: Icon(icon, size: size / 2, color: color),
    );
  }
}

/// Small tinted pill, for example "▲ 15.3% total gain".
class GainPill extends StatelessWidget {
  const GainPill({super.key, required this.up, required this.text});
  final bool up;
  final String text;

  @override
  Widget build(BuildContext context) {
    final extra = Theme.of(context).extension<AppExtraColors>()!;
    final c = Theme.of(context).colorScheme;
    final color = up ? extra.gain : c.error;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: up ? extra.gainBg : extra.lossBg,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        '${up ? '▲' : '▼'} $text',
        style: TextStyle(fontSize: 12, color: color),
      ),
    );
  }
}

/// 12px colored "▲ 18.2%".
class GainText extends StatelessWidget {
  const GainText({super.key, required this.up, required this.text});
  final bool up;
  final String text;

  @override
  Widget build(BuildContext context) {
    final extra = Theme.of(context).extension<AppExtraColors>()!;
    final c = Theme.of(context).colorScheme;
    return Text(
      '${up ? '▲' : '▼'} $text',
      style: TextStyle(fontSize: 12, color: up ? extra.gain : c.error),
    );
  }
}

/// Horizontal filter chips: 32px high, radius 16, yellow border when selected.
class FilterChips extends StatelessWidget {
  const FilterChips({
    super.key,
    required this.labels,
    required this.selected,
    required this.onSelected,
  });

  final List<String> labels;
  final int selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return SizedBox(
      height: 32,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (int i = 0; i < labels.length; i++) ...[
              if (i > 0) const SizedBox(width: 8),
              TouchableOpacity(
                onTap: () => onSelected(i),
                child: Container(
                  height: 32,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: c.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: i == selected ? c.primary : Colors.transparent,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    labels[i],
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight:
                          i == selected ? FontWeight.w500 : FontWeight.normal,
                      color: i == selected ? c.onSurface : c.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Four 4px segments, all yellow when filled (yellow is the only accent).
class StrengthBar extends StatelessWidget {
  const StrengthBar({super.key, required this.strength});
  final int strength; // 0 to 4

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: List.generate(4, (i) {
          return Expanded(
            child: Container(
              height: 4,
              margin: EdgeInsets.only(right: i == 3 ? 0 : 6),
              decoration: BoxDecoration(
                color: i < strength ? c.primary : c.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }
}

/// 3px progress bar on a border colored track.
class ThinBar extends StatelessWidget {
  const ThinBar({super.key, required this.value, required this.color});
  final double value; // 0 to 1
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(2),
      child: LinearProgressIndicator(
        value: value.clamp(0.0, 1.0),
        minHeight: 3,
        backgroundColor: Theme.of(context).colorScheme.outlineVariant,
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }
}

/// Section heading: 16/600 with an optional accent action on the right.
class SectionHeader extends StatelessWidget {
  const SectionHeader(this.title, {super.key, this.action, this.onAction});
  final String title;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final extra = Theme.of(context).extension<AppExtraColors>()!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const Spacer(),
          if (action != null)
            TouchableOpacity(
              onTap: onAction ?? () {},
              child: Text(
                action!,
                style: TextStyle(fontSize: 13, color: extra.accentText),
              ),
            ),
        ],
      ),
    );
  }
}

/// One asset in a list: 36px badge, name, subtitle, value, gain.
class AssetRow extends StatelessWidget {
  const AssetRow({
    super.key,
    required this.name,
    required this.subtitle,
    required this.value,
    required this.up,
    required this.percent,
    required this.color,
    required this.icon,
    this.onTap,
    this.showDivider = true,
  });

  final String name;
  final String subtitle;
  final String value;
  final bool up;
  final String percent;
  final Color color;
  final IconData icon;
  final VoidCallback? onTap;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return TouchableOpacity(
      onTap: onTap ?? () {},
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: showDivider
            ? BoxDecoration(
                border: Border(bottom: BorderSide(color: c.outlineVariant)),
              )
            : null,
        child: Row(
          children: [
            CategoryBadge(color: color, icon: icon),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: c.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFeatures: _tabular,
                  ),
                ),
                GainText(up: up, text: percent),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
