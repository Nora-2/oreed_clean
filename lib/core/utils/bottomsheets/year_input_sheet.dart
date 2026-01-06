import 'package:flutter/material.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/bottomsheets/sheet_scaffold.dart';

class _YearInputsSheet extends StatefulWidget {
  final int minYear;
  final int maxYear;
  final RangeValues initial; // years as double (start/end)
  final String title; // e.g. 'سنة الصنع'

  const _YearInputsSheet({
    required this.minYear,
    required this.maxYear,
    required this.initial,
    required this.title,
  });

  @override
  State<_YearInputsSheet> createState() => _YearInputsSheetState();
}

class _YearInputsSheetState extends State<_YearInputsSheet> {
  late final TextEditingController _fromCtrl;
  late final TextEditingController _toCtrl;

  @override
  void initState() {
    super.initState();
    _fromCtrl =
        TextEditingController(text: widget.initial.start.toInt().toString());
    _toCtrl =
        TextEditingController(text: widget.initial.end.toInt().toString());
  }

  @override
  void dispose() {
    _fromCtrl.dispose();
    _toCtrl.dispose();
    super.dispose();
  }

  void _reset() {
    _fromCtrl.text = widget.minYear.toString();
    _toCtrl.text = widget.maxYear.toString();
    setState(() {});
  }

  InputDecoration _capsuleDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      filled: true,
      fillColor: const Color(0xFFF7F8FA),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE6E8EC)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE6E8EC)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF2563EB)),
      ),
    );
  }

  RangeValues? _parseRange() {
    final from = int.tryParse(_fromCtrl.text.trim());
    final to = int.tryParse(_toCtrl.text.trim());
    if (from == null || to == null) return null;

    int start = from.clamp(widget.minYear, widget.maxYear);
    int end = to.clamp(widget.minYear, widget.maxYear);
    if (start > end) {
      final tmp = start;
      start = end;
      end = tmp;
    }
    return RangeValues(start.toDouble(), end.toDouble());
  }

  @override
  Widget build(BuildContext context) {
    return SheetScaffold(
      heightFactor: 0.52,
      title: widget.title,
      // "سنة الصنع"
      showCounter: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Row(
              children: [
                TextButton(
                  onPressed: _reset,
                  child:  Text(
                    AppTranslations.of(context)!.text('common.reset'),
                    style: TextStyle(color: Color(0xFF94A3B8)),
                  ),
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _fromCtrl,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: false),
                    textAlign: TextAlign.center,
                    decoration: _capsuleDecoration(AppTranslations.of(context)!.text('from')),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _toCtrl,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: false),
                    textAlign: TextAlign.center,
                    decoration: _capsuleDecoration(AppTranslations.of(context)!.text('to')),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      footer: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              final r = _parseRange();
              if (r == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(AppTranslations.of(context)!.text('error.invalid_years') )),
                );
                return;
              }
              Navigator.pop<RangeValues>(context, r);
            },
            child: Text(AppTranslations.of(context)!.text('filter.show_results')),
          ),
        ),
      ),
    );
  }
}

/// Public API (سنة الصنع)
Future<RangeValues?> showYearBottomSheet(
  BuildContext context, {
  int minYear = 1990,
  int? maxYear,
  RangeValues? initial,
  String? title,
}) {
  final int max = maxYear ?? DateTime.now().year;
  final RangeValues start =
      initial ?? RangeValues(minYear.toDouble(), max.toDouble());
  return showModalBottomSheet<RangeValues>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) => _YearInputsSheet(
      minYear: minYear,
      maxYear: max,
      initial: start,
      title: title ?? (AppTranslations.of(context)!.text('filter.section_year')),
    ),
  );
}
