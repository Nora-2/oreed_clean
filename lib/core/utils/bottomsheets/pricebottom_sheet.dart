// lib/view/screens/filterScreen/widgets/bottomSheets/range_sheet.dart
import 'package:flutter/material.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/core/utils/shared_widgets/custom_button.dart';

class _PriceInputsSheet extends StatefulWidget {
  final String title;
  final String hint1;
  final String hint2;
  final String lable1;
  final String lable2;
  final RangeValues initial;
  const _PriceInputsSheet(
      {required this.title,
      required this.hint1,
      required this.hint2,
      required this.lable1,
       required this.initial,
      required this.lable2});

  @override
  State<_PriceInputsSheet> createState() => _PriceInputsSheetState();
}

class _PriceInputsSheetState extends State<_PriceInputsSheet> {
  late final TextEditingController _fromCtrl;
  late final TextEditingController _toCtrl;

  // Colors extracted from your reference design
  final Color _designBlue = const Color(0xFF154DBB);
  final Color _borderColor = Colors.grey.shade300;

  @override
  void initState() {
    _fromCtrl = TextEditingController();
    _toCtrl = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _fromCtrl.dispose();
    _toCtrl.dispose();
    super.dispose();
  }

  RangeValues? _parseRange() {
     final fromText = _fromCtrl.text.replaceAll(',', '').trim();
    final toText = _toCtrl.text.replaceAll(',', '').trim();

    if (fromText.isEmpty && toText.isEmpty) return const RangeValues(0, 0);
   final from = int.tryParse(fromText) ?? 0;
    final to = int.tryParse(toText) ?? 0;
    double start = from.toDouble();
    double end = to.toDouble();
    if (end == 0 && start > 0) end = 1000000; 

    if (start > end) {
      final tmp = start;
      start = end;
      end = tmp;
    }
    return RangeValues(start, end);
  }

  // Matches the 'Search' input style from the reference
  InputDecoration _roundedDecoration(String hint1, String label2) {
    return InputDecoration(
      hintText: hint1,
      hintStyle: TextStyle(
        color: Colors.grey.shade400,
        fontSize: 14,
      ),
      labelText: label2,
      labelStyle: const TextStyle(
          color: Colors.black, fontWeight: FontWeight.w800, fontSize: 14),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 13, horizontal: 20),
      // Default Border
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: _borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: _borderColor),
      ),
      // Focused Border
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: _designBlue, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Adjust height based on content or fixed percentage
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom, // Handle keyboard
      ),
      child: Container(
        decoration:  BoxDecoration(
          color: Colors.white,
          // The specific top border from the reference
          border: Border(top: BorderSide(color: AppColors.secondary, width: 4)),
          borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // --- Drag Handle ---
              Center(
                child: Container(
                  width: 150,
                  height: 5,
                  margin: const EdgeInsets.only(top: 12, bottom: 15),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              // --- Title ---
              Text(
                widget.title.isEmpty ? (AppTranslations.of(context)!.text('filter.price') ) : widget.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),

              // --- Subtitle (Optional, similar to reference) ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  AppTranslations.of(context)!.text('range.subtitle') ,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

             

              const SizedBox(height: 20),

              // --- Inputs Row ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _fromCtrl,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: false),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0F172A),
                        ),
                        decoration:
                            _roundedDecoration(widget.hint1, widget.lable1),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: TextField(
                        controller: _toCtrl,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: false),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0F172A),
                        ),
                        decoration:
                            _roundedDecoration(widget.hint2, widget.lable2),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // --- Confirm Button ---
              Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: CustomButton(
                      onTap: () {
                        final r = _parseRange();
                        if (r == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                             SnackBar(
                              content: Text(AppTranslations.of(context)!.text('error.invalid_numbers') ),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                          return;
                        }
                        Navigator.pop<RangeValues>(context, r);
                      },
                      text: AppTranslations.of(context)?.text("common.confirm") ?? "تأكيد")),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

/// Public API (السعر)
Future<RangeValues?> showPriceBottomSheet(BuildContext context,
    {double min = 0,
    double max = 1000000,
    RangeValues? initial,
    String? title,
    String hint1 = '',
    String hint2 = '',
    String lable1 = '',
    String lable2 = ''}) {
   final start = initial ?? RangeValues(min, max);

  return showModalBottomSheet<RangeValues>(
    context: context,
    isScrollControlled: true, // Needed for dynamic height + keyboard
    backgroundColor: Colors.transparent, // Important for custom decoration
    builder: (_) => _PriceInputsSheet(
      hint1: hint1,
      title: title ?? (AppTranslations.of(context)!.text('filter.choose_price') ),
      hint2: hint2,
      lable1: lable1,
      initial: start,
      lable2: lable2,
    ),
  );
}
