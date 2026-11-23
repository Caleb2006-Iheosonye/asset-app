import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:asset_app/theme/app_colors.dart';
import 'package:asset_app/touchable_opacity.dart';
import 'package:asset_app/components/app_widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const _tabular = [FontFeature.tabularFigures()];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 56,
        leadingWidth: 52,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Center(
            child: TouchableOpacity(
              onTap: () {
                // Handle avatar tap (e.g. open profile)
              },
              child: Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colors.primary,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  'C',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: colors.onPrimary,
                  ),
                ),
              ),
            ),
          ),
        ),
        titleSpacing: 10,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back',
              style: TextStyle(
                color: colors.onSurfaceVariant,
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
            const Text(
              'Caleb',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, size: 20),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none, size: 20),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                // Net worth card
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Net worth',
                                style: TextStyle(
                                  color: colors.onSurfaceVariant,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Icon(
                                Icons.visibility_outlined,
                                size: 16,
                                color: colors.onSurfaceVariant,
                              ),
                              const Spacer(),
                              Text(
                                'Updated 9:41 AM',
                                style: TextStyle(
                                  color: colors.onSurfaceVariant,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            '\$48,250.00',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w600,
                              fontFeatures: _tabular,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const GainPill(up: true, text: '15.3% total gain'),
                              const SizedBox(width: 10),
                              Flexible(
                                child: Text(
                                  '\$6,420.00 since purchase',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: colors.onSurfaceVariant,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SectionHeader('Categories', action: 'Manage'),
                Row(
                  children: [
                    Expanded(
                      child: _CategoryTile(
                        name: 'Stocks',
                        icon: CupertinoIcons.briefcase,
                        color: CategoryColors.stocks,
                        value: '\$20,750',
                        percent: 43,
                        count: 4,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _CategoryTile(
                        name: 'Crypto',
                        icon: Icons.currency_bitcoin,
                        color: CategoryColors.crypto,
                        value: '\$12,550',
                        percent: 26,
                        count: 3,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _CategoryTile(
                        name: 'Bonds',
                        icon: Icons.account_balance_outlined,
                        color: CategoryColors.bonds,
                        value: '\$8,000',
                        percent: 17,
                        count: 2,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _CategoryTile(
                        name: 'Cash',
                        icon: Icons.money_outlined,
                        color: CategoryColors.cash,
                        value: '\$6,950',
                        percent: 14,
                        count: 2,
                      ),
                    ),
                  ],
                ),

                const SectionHeader('Recently added', action: 'View all'),
                // Plain rows, no list builder: the last one has no divider.
                const AssetRow(
                  name: 'Apple Inc',
                  subtitle: 'Added 12 Mar 2025',
                  value: '\$12,400.00',
                  up: true,
                  percent: '18.2%',
                  color: CategoryColors.stocks,
                  icon: CupertinoIcons.briefcase,
                ),
                const AssetRow(
                  name: 'Bitcoin',
                  subtitle: 'Added 2 Feb 2025',
                  value: '\$9,850.00',
                  up: false,
                  percent: '4.1%',
                  color: CategoryColors.crypto,
                  icon: Icons.currency_bitcoin,
                ),
                const AssetRow(
                  name: 'Treasury bond fund',
                  subtitle: 'Added 20 Jan 2025',
                  value: '\$5,000.00',
                  up: true,
                  percent: '3.6%',
                  color: CategoryColors.bonds,
                  icon: Icons.account_balance_outlined,
                  showDivider: false,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({
    required this.name,
    required this.icon,
    required this.color,
    required this.value,
    required this.percent,
    required this.count,
  });

  final String name;
  final IconData icon;
  final Color color;
  final String value;
  final int percent;
  final int count;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final muted12 = TextStyle(color: colors.onSurfaceVariant, fontSize: 12);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CategoryBadge(color: color, icon: icon, size: 30, square: true),
              const SizedBox(width: 8),
              Text(
                name,
                style: TextStyle(color: colors.onSurfaceVariant, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Flexible(
                child: Text(
                  '$percent% of total',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: muted12,
                ),
              ),
              const SizedBox(width: 6),
              Text('$count assets', maxLines: 1, style: muted12),
            ],
          ),
          const SizedBox(height: 8),
          ThinBar(value: percent / 100, color: color),
        ],
      ),
    );
  }
}
