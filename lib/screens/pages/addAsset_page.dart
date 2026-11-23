import 'package:flutter/material.dart';
import 'package:asset_app/components/app_widgets.dart';
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
  final formKey = GlobalKey<FormState>();

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  @override
  void dispose() {
    assetController.dispose();
    symbolController.dispose();
    unitPriceController.dispose();
    quantityController.dispose();
    dateController.dispose();
    noteController.dispose();
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
      // Same display format as the rest of the app, for example 12 Mar 2025.
      dateController.text =
          '${picked.day.toString().padLeft(2, '0')} ${_months[picked.month - 1]} ${picked.year}';
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

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 52,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Add asset',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        ),
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
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        const FieldLabel('Category'),
                        FilterChips(
                          labels: listCategories,
                          selected: selectedIndex,
                          onSelected: (i) => setState(() => selectedIndex = i),
                        ),
                        const SizedBox(height: 16),
                        const FieldLabel('Asset name'),
                        TextFormField(
                          controller: assetController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            hintText: 'Dangote Cement',
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: required,
                        ),
                        const SizedBox(height: 16),
                        const FieldLabel('Symbol (optional)'),
                        TextFormField(
                          controller: symbolController,
                          keyboardType: TextInputType.text,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const FieldLabel('Quantity'),
                                  TextFormField(
                                    controller: quantityController,
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                          decimal: true,
                                        ),
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: positiveNumber,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const FieldLabel('Price per unit'),
                                  TextFormField(
                                    controller: unitPriceController,
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                          decimal: true,
                                        ),
                                    decoration: const InputDecoration(
                                      prefixText: '\$',
                                    ),
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: positiveNumber,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const FieldLabel('Date added'),
                        TextFormField(
                          controller: dateController,
                          readOnly: true,
                          onTap: pickDate,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.calendar_today_outlined, size: 18),
                              onPressed: pickDate,
                            ),
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: required,
                        ),
                        const SizedBox(height: 16),
                        const FieldLabel('Notes (optional)'),
                        TextFormField(
                          controller: noteController,
                          keyboardType: TextInputType.text,
                        ),
                        const SizedBox(height: 18),
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
                                  'Total cost',
                                  style: TextStyle(
                                    color: colors.onSurfaceVariant,
                                    fontSize: 14,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  '\$${total.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                child: AppButton(label: 'Save asset', onTap: save),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
