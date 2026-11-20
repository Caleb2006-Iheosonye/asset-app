import 'package:flutter/material.dart';
import 'package:asset_app/theme/app_theme.dart';
import 'package:asset_app/touchable_opacity.dart';
import 'package:asset_app/screens/pages/detailPage.dart';
import 'package:flutter/cupertino.dart';

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
      'quantity': '50 Units',
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

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    /*  // 1. Master list (never modified)
  final List<Map<String, dynamic>> _allItems = [
    {'code': 'USD', 'name': 'US Dollar', 'icon': Icons.attach_money},
    {'code': 'NGN', 'name': 'Nigerian Naira', 'icon': Icons.payments_outlined},
    {'code': 'EUR', 'name': 'Euro', 'icon': Icons.euro},
    {'code': 'GBP', 'name': 'British Pound', 'icon': Icons.currency_pound},
    {'code': 'JPY', 'name': 'Japanese Yen', 'icon': Icons.currency_yen},
    {'code': 'CASH', 'name': 'Cash Payment', 'icon': Icons.money},
  ]; */

    final extraColors = Theme.of(context).extension<AppExtraColors>()!;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Assets'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // handle the press
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // update  so it can be used to search for assets in the list

                Row(
                  children: [
                    Expanded(
                      child: SearchAnchor(
                        builder:
                            (
                              BuildContext context,
                              SearchController controller,
                            ) {
                              return SearchBar(
                                controller: controller,
                                padding:
                                    const WidgetStatePropertyAll<EdgeInsets>(
                                      EdgeInsets.symmetric(horizontal: 16.0),
                                    ),
                                onTap: () {
                                  controller.openView();
                                },
                                onChanged: (_) {
                                  controller.openView();
                                },
                                leading: const Icon(Icons.search),
                              );
                            },
                        suggestionsBuilder:
                            (
                              BuildContext context,
                              SearchController controller,
                            ) {
                              final query = controller.text.toLowerCase();
                              final filtered = data.where(
                                (item) =>
                                    item['name'].toLowerCase().contains(query),
                              );

                              return filtered.map((data) {
                                return ListTile(
                                  title: Text(data['name'] as String),
                                  onTap: () {
                                    setState(() {
                                      controller.closeView(
                                        data['name'] as String,
                                      );
                                    });
                                  },
                                );
                              });
                            },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 50,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: listCategories.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 16),
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
                            color: isSelected ? colors.primary : colors.outline,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '11 Assets',
                      style: TextStyle(
                        color: colors.onSurfaceVariant,
                        fontSize: 14,
                      ),
                    ),
                    Spacer(),
                    Icon(Icons.swap_vert),
                    Text('Value,high to low'),
                  ],
                ),
                const SizedBox(height: 16),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(8),
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                detailPage(asset: data[index]),
                          ),
                        );
                      },
                      leading: Container(
                        width: 56,
                        height: 56,

                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: data[index]['Color'].withOpacity(0.5) as Color,

                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          data[index]['icon'] as IconData,
                          size: 32,
                          color: data[index]['Color'] as Color,
                        ),
                      ),

                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data[index]['name'] as String,
                            style: TextStyle(
                              color: colors.onSurface,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            data[index]['quantity'] as String,
                            style: TextStyle(
                              color: colors.onSurfaceVariant,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '\$${data[index]['value'] as String}',
                            style: TextStyle(
                              color: colors.onSurface,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                data[index]['GainLoss'] as IconData,
                                color:
                                    data[index]['GainLoss'] ==
                                        Icons.arrow_drop_up
                                    ? extraColors.gain
                                    : colors.error,
                              ),
                              Text(
                                '${data[index]['percent'] as String}%',
                                style: TextStyle(
                                  color:
                                      data[index]['GainLoss'] ==
                                          Icons.arrow_drop_up
                                      ? extraColors.gain
                                      : colors.error,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, int index) {
                    return const SizedBox(
                      height: 1.0,
                      width: double.infinity,
                      child: ColoredBox(color: Color(0xFF000000)),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
