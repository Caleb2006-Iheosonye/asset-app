import 'package:flutter/material.dart';
import 'package:asset_app/theme/app_theme.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:asset_app/touchable_opacity.dart';
import 'package:asset_app/services/export_service.dart';
class ReportsScreen extends StatefulWidget {
  const ReportsScreen({Key? key}) : super(key: key);

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  final List<String> listCategories = ['Month', 'Quarter', 'Year', 'All time'];
  final List<Map<String, dynamic>> data = [
    {
      'name': 'Stock',
      'GainLoss': Icons.arrow_drop_up,
      'value': '3,650.00',
      'percent': 21.3,
      'Color': const Color(0xFF7F77DD),
    },
    {
      'name': 'Crypto',
      'GainLoss': Icons.arrow_drop_up,
      'value': '1,600.00',
      'percent': 14.6,
      'Color': const Color(0xFFF7931A),
    },
    {
      'name': 'Bonds',
      'GainLoss': Icons.arrow_drop_up,
      'value': '720.00',
      'percent': 9.9,
      'Color': const Color(0xFF0ECB81),
    },
    {
      'name': 'Apple Inc',
      'GainLoss': Icons.arrow_drop_up,
      'value': '450.00',
      'percent': 6.9,
      'Color': const Color(0xFF848E9C),
    },
  ];
  final List<Map<String, dynamic>> dataChip = [
    {
      'name': 'Stock',
      'value': '20,750',
      'percent': 43,
      'Color': const Color(0xFF7F77DD),
    },
    {
      'name': 'Crypto',
      'value': '12,550',
      'percent': 26,
      'Color': const Color(0xFFF7931A),
    },
    {
      'name': 'Bonds',
      'value': '8,000',
      'percent': 17,
      'Color': const Color(0xFF0ECB81),
    },
    {
      'name': 'Apple Inc',
      'value': '6,950',
      'percent': 14,
      'Color': const Color(0xFF848E9C),
    },
  ];
  int selectedIndex = 0;
  Future<void> _export() async {
  try {
    await ExportService.exportReport(
      period: listCategories[selectedIndex],
      allocation: dataChip,
      gains: data,
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
    final textTheme = Theme.of(context).textTheme;
    final extraColors = Theme.of(context).extension<AppExtraColors>()!;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Reports'),
        actions: [
          IconButton(
            icon: Icon(Icons.download),
            onPressed: () {
              // handle the press
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),

                      SizedBox(
                        height: 50,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: listCategories.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(width: 8),
                          itemBuilder: (context, index) {
                            final isSelected = selectedIndex == index;

                            return ChoiceChip(
                              label: Text(listCategories[index]),
                              selected: isSelected,
                              showCheckmark: false,
                              backgroundColor: Colors.transparent,
                              selectedColor: Colors.transparent,
                              surfaceTintColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                                side: BorderSide(
                                  color: isSelected
                                      ? colors.primary
                                      : colors.outline,
                                  width: isSelected ? 2 : 1.5,
                                ),
                              ),
                              labelStyle: TextStyle(
                                color: isSelected
                                    ? colors.onSurface
                                    : colors.onSurfaceVariant,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                              onSelected: (_) {
                                setState(() => selectedIndex = index);
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: Card(
                          color: colors.surfaceContainer,
                          //borderOnForeground: true,
                          //semanticContainer: true,
                          child: Padding(
                            padding: EdgeInsets.all(
                              16.0,
                            ), // Padding inside the card
                            child: Column(
                              //mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 200,
                                  width: 200,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      PieChart(
                                        PieChartData(
                                          centerSpaceRadius: 70,
                                          sectionsSpace: 2,
                                          sections: dataChip.map((item) {
                                            return PieChartSectionData(
                                              value: (item['percent'] as num)
                                                  .toDouble(),
                                              color: item['Color'] as Color,
                                              radius: 24,
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
                                              style: textTheme.bodySmall
                                                  ?.copyWith(
                                                    color:
                                                        colors.onSurfaceVariant,
                                                  ),
                                            ),
                                            Text(
                                              '\$48,250',
                                              style: textTheme.titleLarge
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: const EdgeInsets.all(8),
                                  itemCount: dataChip.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                width: 16,
                                                height: 16,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  color:
                                                      dataChip[index]['Color'],
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  dataChip[index]['name'],
                                                  style: TextStyle(
                                                    color: colors.onSurface,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      '${dataChip[index]['percent']}%',
                                                      style: TextStyle(
                                                        color: colors
                                                            .onSurfaceVariant,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                    Text(
                                                      '\$${dataChip[index]['value']}',
                                                      style: TextStyle(
                                                        color: colors.onSurface,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text('Gain by Category', style: textTheme.titleMedium),
                      const SizedBox(height: 16),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(8),
                        itemCount: data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        data[index]['name'],
                                        style: TextStyle(
                                          color: colors.onSurface,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '\$${data[index]['value']}',
                                      style: TextStyle(
                                        color: colors.onSurface,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Icon(
                                      data[index]['GainLoss'],
                                      color:
                                          data[index]['GainLoss'] ==
                                              Icons.arrow_drop_up
                                          ? extraColors.gain
                                          : colors.error,
                                    ),
                                    Text(
                                      '${data[index]['percent']}%',
                                      style: TextStyle(
                                        color: colors.onSurfaceVariant,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                LinearProgressIndicator(
                                  value: (data[index]['percent'] / 100).clamp(
                                    0.0,
                                    1.0,
                                  ),
                                  minHeight: 6,
                                  borderRadius: BorderRadius.circular(4),
                                  backgroundColor:
                                      colors.surfaceContainerHighest,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    data[index]['Color'],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: TouchableOpacity(
                onTap: () {
                  _export();
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: colors.outline,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    'Export report',
                    style: textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colors.onPrimary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
