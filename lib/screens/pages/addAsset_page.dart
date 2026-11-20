import 'package:flutter/material.dart';
import 'package:asset_app/theme/app_theme.dart';
import 'package:asset_app/touchable_opacity.dart';

class AddAsset extends StatefulWidget {
  const AddAsset({Key? key}) : super(key: key);

  @override
  State<AddAsset> createState() => _AddAssetState();
}

class _AddAssetState extends State<AddAsset> {
  final List<String> listCategories = ['Stocks', 'Crypto', 'Bonds', 'Cash'];
  int selectedIndex = 0;
  final assetController = TextEditingController();
  final symbolController = TextEditingController();
  final quantityController = TextEditingController();
  final unitPriceController = TextEditingController();
  final dateController = TextEditingController();
  final noteController = TextEditingController();
  @override
  void dispose() {
    assetController.dispose();
    symbolController.dispose();
    unitPriceController.dispose();
    quantityController.dispose();
    dateController.dispose();
    noteController.dispose();
    // ignore: avoid_print
    //print('Dispose used');
    super.dispose();
  }

  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      dateController.text =
          '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
    }
  }

  void save() {
    if (!formKey.currentState!.validate()) return;
    // TODO: build the asset model and save it
    Navigator.pop(context);
  }

  String? required(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Required' : null;

  String? positiveNumber(String? v) {
    if (v == null || v.trim().isEmpty) return 'Required';
    final n = double.tryParse(v);
    if (n == null || n <= 0) return 'Enter a valid number';
    return null;
  }

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,

        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 32),

          onPressed: () {
            // handle the press
            Navigator.pop(context);
          },
        ),
        title: Text('Add asset'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Category',
                          style: TextStyle(color: colors.onSurfaceVariant),
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
                        Text(
                          'Asset name',
                          style: TextStyle(
                            color: colors.onSurfaceVariant,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: assetController,
                          keyboardType: TextInputType.text,

                          decoration: InputDecoration(
                            filled: true,
                            fillColor: colors.surface,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(color: colors.outline),
                            ),

                            hintText: 'Dangote Cement',
                          ),
                          // Auto validate the email field when the user interacts with it
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required'; // Return an error message if the email is empty
                            }
                            return null; // Return null if the email is valid
                          },
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Symbol (optional)',
                          style: TextStyle(
                            color: colors.onSurfaceVariant,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: symbolController,
                          keyboardType: TextInputType.text,

                          decoration: InputDecoration(
                            filled: true,
                            fillColor: colors.surface,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(color: colors.outline),
                            ),

                            hintText: '',
                          ),
                          // Auto validate the email field when the user interacts with it
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // label, gap, field go here
                                  Text(
                                    'Quantity',
                                    style: TextStyle(
                                      color: colors.onSurfaceVariant,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: quantityController,
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                          decimal: true,
                                        ),

                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: colors.surface,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide(
                                          color: colors.outline,
                                        ),
                                      ),

                                      hintText: '',
                                    ),
                                    // Auto validate the email field when the user interacts with it
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (value) {
                                      return positiveNumber(value);
                                    },
                                  ),
                                ],
                              ),
                            ),
                            // gap goes here
                            const SizedBox(width: 8),
                            // second Expanded goes here
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // label, gap, field go here
                                  Text(
                                    'Price per unit',
                                    style: TextStyle(
                                      color: colors.onSurfaceVariant,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: unitPriceController,
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                          decimal: true,
                                        ),

                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: colors.surface,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide(
                                          color: colors.outline,
                                        ),
                                      ),

                                      hintText: '',
                                    ),
                                    // Auto validate the email field when the user interacts with it
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (value) {
                                      return positiveNumber(
                                        value,
                                      ); // Return null if the email is valid
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Date added',
                          style: TextStyle(
                            color: colors.onSurfaceVariant,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: dateController,
                          keyboardType: TextInputType.text,

                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(Icons.calendar_today_outlined),
                              onPressed: () {
                                pickDate();
                              },
                            ),
                            filled: true,
                            fillColor: colors.surface,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(color: colors.outline),
                            ),

                            hintText: '',
                          ),
                          // Auto validate the email field when the user interacts with it
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            return required(
                              value,
                            ); // Return null if the email is valid
                          },
                        ),

                        Text(
                          'Note (optional)',
                          style: TextStyle(
                            color: colors.onSurfaceVariant,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: noteController,
                          keyboardType: TextInputType.text,

                          decoration: InputDecoration(
                            filled: true,
                            fillColor: colors.surface,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(color: colors.outline),
                            ),

                            hintText: '',
                          ),
                          // Auto validate the email field when the user interacts with it
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                        const SizedBox(height: 16),
                        ListenableBuilder(
                          listenable: Listenable.merge([
                            quantityController,
                            unitPriceController,
                          ]),
                          builder: (context, _) {
                            final qty =
                                double.tryParse(quantityController.text) ?? 0;
                            final price =
                                double.tryParse(unitPriceController.text) ?? 0;
                            final total = qty * price;

                            return Row(
                              children: [
                                Text(
                                  'Total value',
                                  style: TextStyle(
                                    color: colors.onSurfaceVariant,
                                    fontSize: 14,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  '\$${total.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color: colors.onSurface,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: TouchableOpacity(
                  onTap: () {
                    save();
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: colors.primary,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'Save asset',
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
      ),
    );
  }
}
