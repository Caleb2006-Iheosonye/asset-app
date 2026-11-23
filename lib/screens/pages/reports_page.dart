import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:asset_app/components/app_widgets.dart';
import 'package:asset_app/services/export_service.dart';
class ReportsScreen extends StatefulWidget {
  const ReportsScreen({Key? key}) : super(key: key);

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  
  final List<String> listCategories = ['Month', 'Quarter', 'Year', 'All time'];
  int selectedIndex = 2; // Year, as in the design

  // Gain by category. 'amount' is used to scale the bars against the largest.
  final List<Map<String, dynamic>> gains = [
    {'name': 'Stocks', 'amount': 3650.0, 'percent': '21.3%', 'color': const Color(0xFF7F77DD)},
    {'name': 'Crypto', 'amount': 1600.0, 'percent': '14.6%', 'color': const Color(0xFFF7931A)},
    {'name': 'Bonds', 'amount': 720.0, 'percent': '9.9%', 'color': const Color(0xFF0ECB81)},
    {'name': 'Cash', 'amount': 450.0, 'percent': '6.9%', 'color': const Color(0xFF848E9C)},
  ];

  final List<Map<String, dynamic>> allocation = [
    {'name': 'Stocks', 'value': '20,750', 'percent': 43, 'color': const Color(0xFF7F77DD)},
    {'name': 'Crypto', 'value': '12,550', 'percent': 26, 'color': const Color(0xFFF7931A)},
    {'name': 'Bonds', 'value': '8,000', 'percent': 17, 'color': const Color(0xFF0ECB81)},
    {'name': 'Cash', 'value': '6,950', 'percent': 14, 'color': const Color(0xFF848E9C)},
  ];

  String _money(double v) {
    final s = v.toStringAsFixed(2);
    final parts = s.split('.');
    final whole = parts[0].replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (m) => ',',
    );
    return '\$$whole.${parts[1]}';
  }
 Future<void> _export() async {
  try {
    await ExportService.exportReport(
      period: listCategories[selectedIndex],
      allocation: allocation,
      gains: gains,
    );
  } catch (e) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Could not export the report')),
    );
  }
 }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final maxGain = gains
        .map((g) => g['amount'] as double)
        .reduce((a, b) => a > b ? a : b);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 56,
        title: const Text('Reports'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download, size: 22),
            onPressed: () => _export(),
          ),
          const SizedBox(width: 8),
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
                      FilterChips(
                        labels: listCategories,
                        selected: selectedIndex,
                        onSelected: (i) => setState(() => selectedIndex = i),
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 160,
                                  width: 160,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      PieChart(
                                        PieChartData(
                                          startDegreeOffset: -90,
                                          centerSpaceRadius: 51,
                                          sectionsSpace: 2,
                                          sections: allocation.map((item) {
                                            return PieChartSectionData(
                                              value: (item['percent'] as num)
                                                  .toDouble(),
                                              color: item['color'] as Color,
                                              radius: 18,
                                              showTitle: false,
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                      IgnorePointer(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              'Net worth',
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: colors.onSurfaceVariant,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            const Text(
                                              '\$48,250',
                                              style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                for (final item in allocation)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 9,
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 10,
                                          height: 10,
                                          decoration: BoxDecoration(
                                            color: item['color'] as Color,
                                            borderRadius:
                                                BorderRadius.circular(3),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            item['name'] as String,
                                            style: const TextStyle(fontSize: 14),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 40,
                                          child: Text(
                                            '${item['percent']}%',
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: colors.onSurfaceVariant,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 78,
                                          child: Text(
                                            '\$${item['value']}',
                                            textAlign: TextAlign.right,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontFeatures: [
                                                FontFeature.tabularFigures(),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SectionHeader('Gain by category'),
                      for (final g in gains)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    g['name'] as String,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        _money(g['amount'] as double),
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontFeatures: [
                                            FontFeature.tabularFigures(),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      GainText(
                                        up: true,
                                        text: g['percent'] as String,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              ThinBar(
                                value: (g['amount'] as double) / maxGain,
                                color: g['color'] as Color,
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: AppButton(
                label: 'Export report',
                icon: Icons.download_outlined,
                style: AppButtonStyle.secondary,
                onTap: () { _export();},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
