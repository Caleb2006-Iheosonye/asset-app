import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:asset_app/theme/app_theme.dart';
import 'package:asset_app/touchable_opacity.dart';
import 'package:asset_app/components/app_widgets.dart';

class detailPage extends StatefulWidget {
  final Map<String, dynamic> asset;

  const detailPage({super.key, required this.asset});

  @override
  State<detailPage> createState() => _detailPageState();
}

class _detailPageState extends State<detailPage> {
  final List<String> ranges = ['1M', '3M', '6M', '1Y', 'All'];
  int selectedIndex = 3;

  final Map<String, List<double>> series = {
    '1M': [0.97, 0.96, 0.98, 0.97, 0.99, 0.985, 1.0],
    '3M': [0.92, 0.94, 0.93, 0.95, 0.97, 0.96, 0.98, 1.0],
    '6M': [0.88, 0.90, 0.89, 0.93, 0.92, 0.96, 0.98, 1.0],
    '1Y': [0.84, 0.85, 0.85, 0.88, 0.87, 0.90, 0.89, 0.93, 0.95, 0.94, 0.98, 1.0],
    'All': [0.70, 0.74, 0.72, 0.80, 0.78, 0.86, 0.90, 0.93, 0.97, 1.0],
  };

  // The design shows the singular form in the sub header ("Stock, AAPL").
  static const _singular = {'Stocks': 'Stock', 'Bonds': 'Bond'};

  Map<String, dynamic> get asset => widget.asset;
  bool get isGain => asset['GainLoss'] == Icons.arrow_drop_up;

  double get currentValue =>
      double.tryParse((asset['value'] as String).replaceAll(',', '')) ?? 0;

  List<FlSpot> get spots {
    final values = series[ranges[selectedIndex]]!;
    return [
      for (int i = 0; i < values.length; i++)
        FlSpot(
          i.toDouble(),
          currentValue * (isGain ? values[i] : 2 - values[i]),
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final extraColors = Theme.of(context).extension<AppExtraColors>()!;
    final trendColor = isGain ? extraColors.gain : colors.error;
    final assetColor = asset['Color'] as Color;
    final category = (asset['category'] as String?) ?? 'Asset';
    final categoryLabel = _singular[category] ?? category;

    final details = <MapEntry<String, String>>[
      MapEntry('Category', asset['category'] ?? 'N/A'),
      MapEntry('Quantity', asset['quantity'] ?? 'N/A'),
      MapEntry('Price paid', asset['pricePaid'] ?? 'N/A'),
      MapEntry('Total cost', asset['totalCost'] ?? 'N/A'),
      MapEntry('Date added', asset['dateAdded'] ?? 'N/A'),
      MapEntry('Notes', asset['notes'] ?? 'N/A'),
    ];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 52,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          asset['name'] as String,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz, size: 20),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          CategoryBadge(
                            color: assetColor,
                            icon: asset['icon'] as IconData,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '$categoryLabel, ${asset['ticker'] ?? ''}',
                            style: TextStyle(
                              fontSize: 13,
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '\$${asset['value']}',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                          fontFeatures: [FontFeature.tabularFigures()],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          GainPill(up: isGain, text: '${asset['percent']}%'),
                          const SizedBox(width: 10),
                          Flexible(
                            child: Text(
                              '\$${asset['gainAmount'] ?? '0.00'} ${isGain ? 'gain' : 'loss'} since purchase',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: colors.onSurfaceVariant,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      AspectRatio(
                        aspectRatio: 308 / 130,
                        child: _chart(trendColor),
                      ),
                      const SizedBox(height: 8),
                      _rangeSelector(colors),
                      const SizedBox(height: 14),
                      for (int i = 0; i < details.length; i++)
                        _detailRow(
                          details[i].key,
                          details[i].value,
                          colors,
                          last: i == details.length - 1,
                        ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
            // Buttons stay pinned to the bottom, as in the design.
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppButton(
                    label: 'Edit asset',
                    icon: Icons.edit_outlined,
                    onTap: () {},
                  ),
                  const SizedBox(height: 12),
                  AppButton(
                    label: 'Delete asset',
                    style: AppButtonStyle.danger,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chart(Color lineColor) {
    final points = spots;
    final ys = points.map((p) => p.y);
    final minY = ys.reduce((a, b) => a < b ? a : b);
    final maxY = ys.reduce((a, b) => a > b ? a : b);
    final pad = (maxY - minY) * 0.1;

    return LineChart(
      LineChartData(
        minY: minY - pad,
        maxY: maxY + pad,
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineTouchData: const LineTouchData(enabled: false),
        lineBarsData: [
          LineChartBarData(
            spots: points,
            isCurved: false,
            color: lineColor,
            barWidth: 2,
            // Only the last point gets a dot, like the design.
            dotData: FlDotData(
              show: true,
              checkToShowDot: (spot, barData) =>
                  spot.x == barData.spots.last.x,
              getDotPainter: (spot, percent, barData, index) =>
                  FlDotCirclePainter(
                    radius: 4,
                    color: lineColor,
                    strokeWidth: 0,
                  ),
            ),
            belowBarData: BarAreaData(
              show: true,
              color: lineColor.withValues(alpha: 0.12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _rangeSelector(ColorScheme colors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(ranges.length, (i) {
        final selected = selectedIndex == i;
        return TouchableOpacity(
          onTap: () => setState(() => selectedIndex = i),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: selected
                  ? colors.surfaceContainerHighest
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              ranges[i],
              style: TextStyle(
                fontSize: 13,
                color: selected ? colors.onSurface : colors.onSurfaceVariant,
                fontWeight: selected ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _detailRow(
    String label,
    String value,
    ColorScheme colors, {
    required bool last,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: last
          ? null
          : BoxDecoration(
              border: Border(bottom: BorderSide(color: colors.outlineVariant)),
            ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 14, color: colors.onSurfaceVariant),
          ),
          const SizedBox(width: 16),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
