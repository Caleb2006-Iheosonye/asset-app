import 'package:flutter/material.dart';
import 'package:asset_app/theme/app_theme.dart';
import 'package:asset_app/touchable_opacity.dart';
import 'package:flutter/cupertino.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final extraColors = Theme.of(context).extension<AppExtraColors>()!;
    final List<String> entries = <String>[
      'Apple Inc',
      'Bitcoin',
      'Treasury bond fund',
    ];
    final List<IconData> iconVar = <IconData>[
      CupertinoIcons.briefcase,
      Icons.currency_bitcoin,
      Icons.account_balance_outlined,
    ];
    final List<IconData> gainLoss = <IconData>[
      Icons.arrow_drop_up,
      Icons.arrow_drop_down,
      Icons.arrow_drop_up,
    ];
    final List<String> addedDate = <String>[
      '12 Mar 2025',
      '2 Feb 2025',
      '20 Jan 2025',
    ];
    final List<String> entriesValue = <String>[
      '12,400.00',
      '9,850.00',
      '5,000.00',
    ];
    final List<String> entriesPercent = <String>['18.2', '4.1', '3.6'];
    final List<Color> containerColor = <Color>[
      const Color(0xFF7F77DD),
      const Color(0xFFF7931A),
      const Color(0xFF0ECB81),
      const Color(0xFF848E9C),
    ];
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: TouchableOpacity(
            onTap: () {
              // Handle avatar tap (e.g., open profile or drawer)
            },
            child: CircleAvatar(
              radius: 18,

              backgroundColor: colors.primary,
              child: Text('C'),
              // Or use AssetImage('assets/profile.jpg') for local images
            ),
          ),
        ),
        titleSpacing: 8,

        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back',
              style: TextStyle(color: colors.onSurfaceVariant, fontSize: 13),
            ),
            Text(
              'Caleb',
              style: TextStyle(
                color: colors.onSurface,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // handle the press
            },
          ),
          IconButton(
            icon: Icon(Icons.notifications_outlined),
            onPressed: () {
              // handle the press
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    color: colors.surfaceContainer,
                    //borderOnForeground: true,
                    //semanticContainer: true,
                    child: Padding(
                      padding: EdgeInsets.all(16.0), // Padding inside the card
                      child: Column(
                        //mainAxisSize: MainAxisSize.min,
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
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.visibility, size: 18),
                              ),
                              Spacer(),
                              Text(
                                'Updated 9:41 AM',
                                style: TextStyle(
                                  color: colors.onSurfaceVariant,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            "\$48,250.00",
                            style: TextStyle(
                              color: colors.onSurface,
                              fontSize: 32,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Row(
                            children: [
                              Card(
                                color: extraColors.gainBg,
                                child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.arrow_drop_up,
                                        color: extraColors.gain,
                                      ),
                                      Text("15.3% total gain"),
                                    ],
                                  ),
                                ),
                              ),
                              Spacer(),
                              Text(
                                "\$6,420 since purchase",
                                style: TextStyle(
                                  color: colors.onSurfaceVariant,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Text('Categories'),
                    Spacer(),
                    TouchableOpacity(
                      child: Text(
                        //textAlign: TextAlign.end,
                        ' Manage',
                        style: TextStyle(
                          color: extraColors.accentText,
                          fontSize: 14,
                        ),
                      ),
                      onTap: () {
                        //Navigator.pushNamed(context, '/');
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Card(
                        color: colors.surfaceContainer,
                        child: Padding(
                          padding: EdgeInsets.all(
                            16.0,
                          ), // Padding inside the card
                          child: Column(
                            //mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Stocks"),
                              Text("\$20,750"),
                              Row(
                                children: [
                                  Text("43% of total"),
                                  Spacer(),

                                  Text("4 assets"),
                                ],
                              ),
                              const SizedBox(height: 8),
                              LinearProgressIndicator(
                                value: 20750 / 48250,
                                backgroundColor: colors.surface,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  containerColor[0],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Card(
                        color: colors.surfaceContainer,
                        child: Padding(
                          padding: EdgeInsets.all(
                            16.0,
                          ), // Padding inside the card
                          child: Column(
                            //mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Crypto"),
                              Text("\$12,550"),
                              Row(
                                children: [
                                  Text("26% of total"),
                                  Spacer(),

                                  Text("3 assets"),
                                ],
                              ),
                              const SizedBox(height: 8),
                              LinearProgressIndicator(
                                value: 12550 / 48250,
                                backgroundColor: colors.surface,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  containerColor[1],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Card(
                        color: colors.surfaceContainer,
                        child: Padding(
                          padding: EdgeInsets.all(
                            16.0,
                          ), // Padding inside the card
                          child: Column(
                            //mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Bonds"),
                              Text("\$8,000"),
                              Row(
                                children: [
                                  Text("17% of total"),
                                  Spacer(),

                                  Text(" 2 assets"),
                                ],
                              ),
                              const SizedBox(height: 8),
                              LinearProgressIndicator(
                                value: 8000 / 48250,
                                backgroundColor: colors.surface,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  containerColor[2],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Card(
                        color: colors.surfaceContainer,
                        child: Padding(
                          padding: EdgeInsets.all(
                            16.0,
                          ), // Padding inside the card
                          child: Column(
                            //mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Cash"),
                              Text("\$6,950"),
                              Row(
                                children: [
                                  Text("14% of total"),
                                  Spacer(),

                                  Text(" 2 assets"),
                                ],
                              ),
                              const SizedBox(height: 8),
                              LinearProgressIndicator(
                                value: 6950 / 48250,
                                backgroundColor: colors.surface,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  containerColor[3],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text('Recently added'),
                    Spacer(),
                    TouchableOpacity(
                      child: Text(
                        //textAlign: TextAlign.end,
                        'View all',
                        style: TextStyle(
                          color: extraColors.accentText,
                          fontSize: 14,
                        ),
                      ),
                      onTap: () {
                        //Navigator.pushNamed(context, '/');
                      },
                    ),
                  ],
                ),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(8),
                  itemCount: entries.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: Container(
                        width: 56,
                        height: 56,

                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: (containerColor[index % containerColor.length])
                              .withOpacity(0.5),

                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          iconVar[index % iconVar.length],
                          size: 32,
                          color:
                              (containerColor[index % containerColor.length]),
                        ),
                      ),

                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entries[index],
                            style: TextStyle(
                              color: colors.onSurface,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Added ${addedDate[index]}',
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
                            '\$${entriesValue[index % entriesValue.length]}',
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
                                gainLoss[index % gainLoss.length],
                                color:
                                    gainLoss[index % gainLoss.length] ==
                                        Icons.arrow_drop_up
                                    ? extraColors.gain
                                    : colors.error,
                              ),
                              Text(
                                '${entriesPercent[index % entriesPercent.length]}%',
                                style: TextStyle(
                                  color:
                                      gainLoss[index % gainLoss.length] ==
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
