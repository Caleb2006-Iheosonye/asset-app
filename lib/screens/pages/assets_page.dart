import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:asset_app/screens/pages/detailPage.dart';
import 'package:asset_app/components/app_widgets.dart';
class AssetsScreen extends StatefulWidget {
  const AssetsScreen({Key? key}) : super(key: key);

  @override
  State<AssetsScreen> createState() => _AssetsScreenState();
}

class _AssetsScreenState extends State<AssetsScreen> {
  final List<String> listCategories = [
    'All',
    'Stocks',
    'Crypto',
    'Bonds',
    'Cash',
  ];
  int selectedIndex = 0;
  String query = '';

  final List<Map<String, dynamic>> data = [
    {
      'name': 'Apple Inc',
      'icon': CupertinoIcons.briefcase,
      'GainLoss': Icons.arrow_drop_up,
      'value': '12,400.00',
      'percent': '18.2',
      'quantity': '60 shares',
      'Color': const Color(0xFF7F77DD),
      'category': 'Stocks',
      'ticker': 'AAPL',
      'gainAmount': '1,909.00',
      'pricePaid': '\$174.85 per share',
      'totalCost': '\$10,491.00',
      'dateAdded': '12 Mar 2025',
      'notes': 'Long term hold',
    },
    {
      'name': 'Bitcoin',
      'icon': Icons.currency_bitcoin,
      'GainLoss': Icons.arrow_drop_down,
      'value': '9,850.00',
      'percent': '4.1',
      'quantity': '0.1500 BTC',
      'Color': const Color(0xFFF7931A),
      'category': 'Crypto',
      'ticker': 'BTC',
      'gainAmount': '421.00',
      'pricePaid': '\$68,473.33 per BTC',
      'totalCost': '\$10,271.00',
      'dateAdded': '03 Jun 2025',
      'notes': 'Bought on a dip, waiting for recovery',
    },
    {
      'name': 'Treasury bond fund',
      'icon': Icons.account_balance_outlined,
      'GainLoss': Icons.arrow_drop_up,
      'value': '5,000.00',
      'percent': '3.6',
      'quantity': '50 units',
      'Color': const Color(0xFF0ECB81),
      'category': 'Bonds',
      'ticker': 'TBF',
      'gainAmount': '174.00',
      'pricePaid': '\$96.52 per unit',
      'totalCost': '\$4,826.00',
      'dateAdded': '20 Jan 2025',
      'notes': 'Low risk allocation',
    },
    {
      'name': 'Savings account',
      'icon': Icons.money_outlined,
      'GainLoss': Icons.arrow_drop_up,
      'value': '5,000.00',
      'percent': '1.2',
      'quantity': 'USD',
      'Color': const Color(0xFF848E9C),
      'category': 'Cash',
      'ticker': 'USD',
      'gainAmount': '59.00',
      'pricePaid': '\$4,941.00 deposited',
      'totalCost': '\$4,941.00',
      'dateAdded': '05 Jan 2025',
      'notes': 'Emergency fund',
    },
    {
      'name': 'Microsoft',
      'icon': CupertinoIcons.briefcase,
      'GainLoss': Icons.arrow_drop_up,
      'value': '4,200.00',
      'percent': '9.4',
      'quantity': '10 shares',
      'Color': const Color(0xFF7F77DD),
      'category': 'Stocks',
      'ticker': 'MSFT',
      'gainAmount': '361.00',
      'pricePaid': '\$383.90 per share',
      'totalCost': '\$3,839.00',
      'dateAdded': '28 Apr 2025',
      'notes': 'Add more on pullbacks',
    },
    {
      'name': 'Corporate bond',
      'icon': Icons.account_balance_outlined,
      'GainLoss': Icons.arrow_drop_up,
      'value': '3,000.00',
      'percent': '2.8',
      'quantity': '30 units',
      'Color': const Color(0xFF0ECB81),
      'category': 'Bonds',
      'ticker': 'CORP',
      'gainAmount': '81.90',
      'pricePaid': '\$97.27 per unit',
      'totalCost': '\$2,918.10',
      'dateAdded': '15 Feb 2025',
      'notes': 'Matures in 2029',
    },
    {
      'name': 'Nvidia',
      'icon': CupertinoIcons.briefcase,
      'GainLoss': Icons.arrow_drop_up,
      'value': '2,650.00',
      'percent': '31.5',
      'quantity': '20 shares',
      'Color': const Color(0xFF7F77DD),
      'category': 'Stocks',
      'ticker': 'NVDA',
      'gainAmount': '635.00',
      'pricePaid': '\$100.75 per share',
      'totalCost': '\$2,015.00',
      'dateAdded': '09 Sep 2024',
      'notes': 'High growth, review quarterly',
    },
  ];

  List<Map<String, dynamic>> get filtered {
    final category = listCategories[selectedIndex];
    final q = query.trim().toLowerCase();
    return data.where((item) {
      final matchesCategory = category == 'All' || item['category'] == category;
      final matchesQuery =
          q.isEmpty || (item['name'] as String).toLowerCase().contains(q);
      return matchesCategory && matchesQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final items = filtered;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 56,
        title: const Text('Assets'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, size: 22),
            onPressed: () {
              // TODO: open the Add asset screen
            },
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
                TextField(
                  onChanged: (value) => setState(() => query = value),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search, size: 18),
                    hintText: 'Search by name',
                  ),
                ),
                const SizedBox(height: 12),
                FilterChips(
                  labels: listCategories,
                  selected: selectedIndex,
                  onSelected: (i) => setState(() => selectedIndex = i),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      '${items.length} assets',
                      style: TextStyle(
                        color: colors.onSurfaceVariant,
                        fontSize: 13,
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.swap_vert, size: 16),
                    const SizedBox(width: 6),
                    const Text(
                      'Value, high to low',
                      style: TextStyle(fontSize: 13),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                for (int i = 0; i < items.length; i++)
                  AssetRow(
                    name: items[i]['name'] as String,
                    subtitle: items[i]['quantity'] as String,
                    value: '\$${items[i]['value']}',
                    up: items[i]['GainLoss'] == Icons.arrow_drop_up,
                    percent: '${items[i]['percent']}%',
                    color: items[i]['Color'] as Color,
                    icon: items[i]['icon'] as IconData,
                    showDivider: i != items.length - 1,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => detailPage(asset: items[i]),
                        ),
                      );
                    },
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
