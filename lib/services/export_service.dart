import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ExportService {
  // "20,750" -> "20750" so the comma doesn't split the CSV column.
  static String _plain(Object value) => value.toString().replaceAll(',', '');

  // Wraps a field in quotes if it contains a comma, quote or newline.
  static String _escape(String v) {
    if (v.contains(',') || v.contains('"') || v.contains('\n')) {
      return '"${v.replaceAll('"', '""')}"';
    }
    return v;
  }

  /// Joins [allocation] (dataChip) and [gains] (data) by category name
  /// and returns one CSV row per category plus a Total row.
  static String buildReportCsv({
    required String period,
    required List<Map<String, dynamic>> allocation,
    required List<Map<String, dynamic>> gains,
  }) {
    final rows = <List<String>>[
      [
        'period',
        'category',
        'current_value',
        'allocation_percent',
        'gain_amount',
        'gain_percent',
      ],
    ];

    double total = 0;

   for (final item in allocation) {
  final name = item['name'] as String;
  final value = double.tryParse(_plain(item['value'])) ?? 0;
  total += value;

  // Find the matching gain entry, if there is one.
  final gain = gains.firstWhere(
    (g) => g['name'] == name,
    orElse: () => <String, dynamic>{},
  );
  final hasGain = gain.isNotEmpty;

  final gainAmount = hasGain ? (gain['amount'] as num).toDouble() : 0.0;
  final gainPercent = hasGain
      ? _plain(gain['percent']).replaceAll('%', '')
      : '';

  rows.add([
    period,
    name,
    value.toStringAsFixed(2),
    _plain(item['percent']),
    hasGain ? gainAmount.toStringAsFixed(2) : '',
    gainPercent,
  ]);
}

    rows.add([period, 'Total', total.toStringAsFixed(2), '', '', '']);

    return rows.map((r) => r.map(_escape).join(',')).join('\n');
  }

  /// Builds the CSV, saves it to a temp file and opens the share sheet.
  static Future<void> exportReport({
    required String period,
    required List<Map<String, dynamic>> allocation,
    required List<Map<String, dynamic>> gains,
  }) async {
    final csv = buildReportCsv(
      period: period,
      allocation: allocation,
      gains: gains,
    );

    final dir = await getTemporaryDirectory();
    final date = DateTime.now().toIso8601String().substring(0, 10);
    final safePeriod = period.toLowerCase().replaceAll(' ', '_');
    final file = File('${dir.path}/kima_report_${safePeriod}_$date.csv');
    await file.writeAsString(csv);

    await SharePlus.instance.share(
      ShareParams(files: [XFile(file.path)], subject: 'Kima report'),
    );
  }
}
