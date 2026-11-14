import 'package:flutter/material.dart';
import 'package:asset_app/theme/app_theme.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen ({Key? key}) : super(key: key); 

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();}

class _ReportsScreenState extends State<ReportsScreen> {
  final List<String> listCategories = ['Month', 'Quarter', 'Year', 'All time'];
    int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
        final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
        title: const Text('Reports'),
         actions: [IconButton(
            icon:  Icon(Icons.download),
            onPressed: () {
              // handle the press
            }
      )]
      ),
      body: SafeArea(
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
                        
       ],
            )
       )
      ),
       )
    );
  }
}