import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:asset_app/theme/app_theme.dart';
import 'package:asset_app/touchable_opacity.dart';

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
    debugPrint(asset.keys.toString());
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final extraColors = Theme.of(context).extension<AppExtraColors>()!;
    final trendColor = isGain ? extraColors.gain : colors.error;
    final assetColor = asset['Color'] as Color;

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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          asset['name'] as String,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.more_horiz), onPressed: () {}),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Row(
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: assetColor.withValues(alpha: 0.25),
                    child: Icon(
                      asset['icon'] as IconData,
                      size: 16,
                      color: assetColor,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${asset['category'] ?? 'Asset'}, ${asset['ticker'] ?? ''}',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                '\$${asset['value']}',
                style: textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: colors.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: trendColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isGain ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                          size: 20,
                          color: trendColor,
                        ),
                        Text(
                          '${asset['percent']}%',
                          style: TextStyle(
                            color: trendColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '\$${asset['gainAmount'] ?? '0.00'} ${isGain ? 'gain' : 'loss'} since purchase',
                    style: TextStyle(
                      color: colors.onSurfaceVariant,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(height: 160, child: _chart(trendColor)),
              const SizedBox(height: 16),
              _rangeSelector(colors),
              const SizedBox(height: 16),
              for (int i = 0; i < details.length; i++) ...[
                _detailRow(details[i].key, details[i].value, colors),
                if (i != details.length - 1)
                  Divider(height: 1, color: colors.outlineVariant),
              ],
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  label: const Text('Edit asset'),
                  style: FilledButton.styleFrom(
                    backgroundColor: colors.primary,
                    foregroundColor: colors.onPrimary,
                    minimumSize: const Size.fromHeight(54),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colors.error,
                    side: BorderSide(color: colors.error),
                    minimumSize: const Size.fromHeight(54),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Delete asset'),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
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
        lineBarsData: [
          LineChartBarData(
            spots: points,
            isCurved: false,
            color: lineColor,
            barWidth: 2,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: lineColor.withValues(alpha: 0.15),
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
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: selected ? colors.surfaceContainerHighest : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              ranges[i],
              style: TextStyle(
                color: selected ? colors.onSurface : colors.onSurfaceVariant,
                fontWeight: selected ? FontWeight.w700 : FontWeight.normal,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _detailRow(String label, String value, ColorScheme colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: colors.onSurfaceVariant)),
          Text(
            value,
            style: TextStyle(
              color: colors.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}