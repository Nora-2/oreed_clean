import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/bottomsheets/option_sheet_register_grid_model.dart';
import 'package:oreed_clean/core/utils/option_item_register.dart';
import 'package:oreed_clean/core/utils/shared_widgets/custom_form_field.dart';
import 'package:oreed_clean/core/utils/textstyle/appfonts.dart';
import 'package:oreed_clean/features/carform/presentation/widgets/color_grid_sheet.dart';
import 'package:oreed_clean/features/carform/presentation/widgets/open_color_picker.dart';
import 'package:oreed_clean/features/company_types_by_company/presentation/widgets/select_sheet_field_ads.dart';
import 'package:oreed_clean/features/dynamicfields/presentation/cubit/dynamicfields_cubit.dart';
import 'package:oreed_clean/features/dynamicfields/presentation/cubit/dynamicfields_state.dart';

class DynamicFieldsSection extends StatefulWidget {
  final int sectionId;

  final Map<String, dynamic>? initData;

  /// Callback to bubble up current values
  final ValueChanged<Map<String, dynamic>>? onChanged;

  const DynamicFieldsSection({
    super.key,
    required this.sectionId,
    this.onChanged,
    this.initData,
  });

  @override
  State<DynamicFieldsSection> createState() => _DynamicFieldsSectionState();
}



class _DynamicFieldsSectionState extends State<DynamicFieldsSection> {
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, String?> _selectedValues = {};
  bool _emittedInitial = false;

  @override
  void initState() {
    super.initState();
     WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DynamicFieldsCubit>().fetchDynamicFields(widget.sectionId);
    });
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  // -------- Helpers: Arabic normalization & matching --------
  String _normalize(String? s) {
    if (s == null) return '';
    var t = s.trim();
    t = t.replaceAll(RegExp(r'\s+'), ' '); // collapse spaces
    t = t.replaceAll('ى', 'ي');
    t = t.replaceAll('ة', 'ه');
    // remove Arabic diacritics (tashkeel incl. tanween)
    t = t.replaceAll(RegExp(r'[\u064B-\u0652]'), '');
    return t;
  }



  bool _equalsLoose(String? a, String? b) => _normalize(a) == _normalize(b);

  /// Find the best UI option that matches the API value (loosely).
  String? _matchApiToOption(String? apiValue, List<String> options) {
    if (apiValue == null) return null;
    final a = _normalize(apiValue);

    // 1) exact loose match
    for (final opt in options) {
      if (_equalsLoose(a, _normalize(opt))) return opt;
    }

    // 2) contains / substring match (either way)
    for (final opt in options) {
      final o = _normalize(opt);
      if (a.contains(o) || o.contains(a)) return opt;
    }

    // 3) compare after removing punctuation/diacritics/spaces
    String _strip(String s) =>
        s.replaceAll(RegExp(r"[^0-9\u0600-\u06FFa-zA-Z]"), '');
    final strippedA = _strip(a);
    for (final opt in options) {
      final strippedO = _strip(_normalize(opt));
      if (strippedA == strippedO) return opt;
      if (strippedA.contains(strippedO) || strippedO.contains(strippedA)) {
        return opt;
      }
    }

    return null;
  }

  bool _isDropdownField(String key) {
    // أضف أي مفاتيح أخرى يعاملها الـbackend كقيم تعداد (enum)
    const dropdownKeys = ['new_or_used', 'condition'];
    return dropdownKeys.contains(key.toLowerCase());
  }

  bool _isColorField(String key) => key.toLowerCase() == 'color';

  List<ColorSection> _buildColorSections(AppTranslations? appTrans) {
    return colorsections(context);
  }

  Future<String?> _openColorPicker(String? currentLabel) async {
    final appTrans = AppTranslations.of(context);
    final sections = _buildColorSections(appTrans);
    final searchCtrl = TextEditingController();
    List<ColorSection> filtered = sections;
    String? selectedLabel = currentLabel;

    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            void runFilter(String q) {
              final qn = q.trim().toLowerCase();
              if (qn.isEmpty) {
                filtered = sections;
              } else {
                filtered = sections
                    .map((s) {
                      final matches = s.items
                          .where((i) => i.label.toLowerCase().contains(qn))
                          .toList();
                      return ColorSection(title: s.title, items: matches);
                    })
                    .where((s) => s.items.isNotEmpty)
                    .toList();
              }
              setSheetState(() {});
            }

            return Container(
              height: MediaQuery.of(context).size.height * 0.85,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                border: Border(
                  top: BorderSide(color: Colors.grey.shade200, width: 4),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Container(
                    width: 70,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    appTrans?.text('select.choose_color') ?? 'اختر اللون',
                    style: AppFonts.title.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: TextField(
                        controller: searchCtrl,
                        onChanged: runFilter,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          hintText:
                              appTrans?.text('search.color') ?? 'ابحث عن اللون',
                          hintStyle: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 13,
                          ),
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.search,
                            size: 20,
                            color: Colors.grey.shade500,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 10,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: filtered.isEmpty
                        ? Center(
                            child: Text(
                              appTrans?.text('error.no_results') ??
                                  'لا توجد نتائج',
                              style: AppFonts.body.copyWith(
                                color: Colors.grey.shade500,
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            itemCount: filtered.length,
                            itemBuilder: (context, idx) {
                              final section = filtered[idx];
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                      horizontal: 4,
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          margin:
                                              const EdgeInsetsDirectional.only(
                                                start: 6,
                                                end: 6,
                                              ),
                                          height: 14,
                                          width: 2,
                                          color: const Color(0xFFFFA000),
                                        ),
                                        Text(
                                          section.title,
                                          style: AppFonts.body.copyWith(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Wrap(
                                    spacing: 10,
                                    runSpacing: 10,
                                    children: section.items.map((item) {
                                      final isSelected = _equalsLoose(
                                        item.label,
                                        selectedLabel,
                                      );
                                      return InkWell(
                                        onTap: () {
                                          selectedLabel = item.label;
                                          Navigator.pop(ctx, item.label);
                                        },
                                        borderRadius: BorderRadius.circular(30),
                                        child: AnimatedContainer(
                                          duration: const Duration(
                                            milliseconds: 180,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 8,
                                          ),
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? Theme.of(context).primaryColor
                                                      .withOpacity(0.1)
                                                : Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              30,
                                            ),
                                            border: Border.all(
                                              color: isSelected
                                                  ? Theme.of(
                                                      context,
                                                    ).primaryColor
                                                  : Colors.grey.shade300,
                                              width: isSelected ? 1.4 : 1,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                            
                                                SvgPicture.asset(
                                                  item.iconPath,
                                                  width: 18,
                                                  height: 18,
                                                  // Use the item's specific color
                                                  colorFilter:
                                                      ColorFilter.mode(
                                                          item.iconColor,
                                                          BlendMode.srcIn),
                                                ),
                                              const SizedBox(width: 6),
                                              Text(
                                                item.label,
                                                style: AppFonts.body.copyWith(
                                                  fontSize: 13,
                                                  fontWeight: isSelected
                                                      ? FontWeight.w700
                                                      : FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                  const SizedBox(height: 12),
                                ],
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  /// UI options (Arabic labels shown to users)
  List<String> _getDropdownOptions(String key) {
    final trans = AppTranslations.of(context);
    switch (key.toLowerCase()) {
      case 'new_or_used':
        return [
          trans?.text("options.condition.new") ?? 'جديد',
          trans?.text("options.condition.used") ?? 'مستعمل',
        ];
      case 'condition':
        return [
          trans?.text("options.condition.very_new") ?? 'جديد جدًا',
          trans?.text("options.condition.excellent") ?? 'ممتاز',
          trans?.text("options.condition.very_good") ?? 'جيد جدًا',
          trans?.text("options.condition.good") ?? 'جيد',
          trans?.text("options.condition.average") ?? 'متوسط',
        ];
      default:
        return const [];
    }
  }

  /// جمع كل القيم (نصوص + قوائم منسدلة)
  Map<String, dynamic> collectFieldValues() {
    final Map<String, dynamic> result = {};
    for (final entry in _controllers.entries) {
      result[entry.key] = entry.value.text.trim();
    }
    for (final entry in _selectedValues.entries) {
      result[entry.key] = entry.value;
    }
    return result;
  }

  void _emitChanges() {
    widget.onChanged?.call(collectFieldValues());
  }

  @override
  Widget build(BuildContext context) {
     return BlocBuilder<DynamicFieldsCubit, DynamicFieldsState>(
      builder: (context, state) {
        if (state.status == DynamicFieldsStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status == DynamicFieldsStatus.error) {
          return const SizedBox.shrink();
        }

        final fields = state.fields;

        if (fields.isEmpty) {
          if (!_emittedInitial) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                widget.onChanged?.call({});
                setState(() => _emittedInitial = true);
              }
            });
          }
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: fields.map((field) {
            final key = field.key;
            final bool isDropdown = _isDropdownField(key);
            final bool isColor = _isColorField(key);

            // استخرج القيمة المبدئية من initData (لو موجودة)
            final dynamic rawInit = widget.initData != null
                ? widget.initData![key]
                : null;
            final String? initValue =
                (rawInit == null || rawInit.toString().trim().isEmpty)
                ? null
                : rawInit.toString();

            if (!isDropdown && !isColor) {
              // جهّز الـcontroller مرة واحدة
              _controllers.putIfAbsent(
                key,
                () => TextEditingController(text: initValue ?? ''),
              );
              // تزامن لاحق لو جت init بعد أول بناء
              if (_controllers[key]!.text.isEmpty &&
                  (initValue ?? '').isNotEmpty) {
                _controllers[key]!.text = initValue!;
              }
            } else if (isColor) {
              if (!_selectedValues.containsKey(key)) {
                _selectedValues[key] = initValue;
              }
            } else {
              // dropdown branch
              // ثبّت/حدّث القيمة المبدئية للاختيار (بمطابقة مرنة).
              final options = _getDropdownOptions(key);

              // If we never set this dropdown before, initialize it from initValue (matched or raw)
              if (!_selectedValues.containsKey(key)) {
                _selectedValues[key] =
                    _matchApiToOption(initValue, options) ?? initValue;
              } else {
                // If there's no value yet but we have initValue now, fill it.
                if ((_selectedValues[key] == null ||
                        _selectedValues[key]!.isEmpty) &&
                    (initValue ?? '').isNotEmpty) {
                  _selectedValues[key] =
                      _matchApiToOption(initValue, options) ?? initValue;
                  // If initial emission already happened, make sure UI updates and parent is notified.
                  if (_emittedInitial && mounted) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) setState(() {});
                      _emitChanges();
                    });
                  }
                }
              }
            }

            // بعد تجهيز القيم لأول مرة، ابعثها للأب مرة واحدة
            if (!_emittedInitial) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  _emitChanges();
                  setState(() => _emittedInitial = true);
                }
              });
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isDropdown)
                  SelectSheetFieldads(
                    // The label changes based on selection (similar to your example logic)
                    // Or you can keep it static: Text('${field.label}')
                    label: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: field.label,
                            style: AppFonts.body.copyWith(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          // const TextSpan(
                          //   text: ' *',
                          //   style: TextStyle(color: Colors.red),
                          // ),
                        ],
                      ),
                    ),
                    hint:
                        _selectedValues[key] ??
                        '${(AppTranslations.of(context)?.text("choose") ?? "اختر").trim()} ${field.label}',

                    // Pass the current value so it shows in the field (requires the class update below)
                    onTap: () async {
                      // 1. Get your dynamic options
                      final opts = _getDropdownOptions(key).toList();

                      // 2. Add current value if it exists but isn't in the list (matching your original logic)
                      final selected = _selectedValues[key];
                      if (selected != null && !opts.contains(selected)) {
                        opts.insert(0, selected);
                      }

                      // 3. Convert strings to OptionItemregister (for the bottom sheet)
                      final options = List.generate(opts.length, (i) {
                        return OptionItemregister(
                          label: opts[i],

                          // You can use a generic icon or logic to pick one based on the field
                          colorTag: i,
                        );
                      });

                      // 4. Show the Sheet
                      final chosen = await showAppOptionSheetregistergridmodel(
                        context: context,
                        title:
                            '${(AppTranslations.of(context)?.text("choose") ?? "اختر").trim()} ${field.label}',
                        subtitle:
                            AppTranslations.of(
                              context,
                            )?.text("common.select_from_list") ??
                            'يرجى اختيار قيمة من القائمة أدناه',
                        options: options,
                        // Pass the current selected value to highlight it in the sheet
                        current: _selectedValues[key],

                        // Or your variable _tagColor
                      );

                      // 5. Update State
                      if (chosen != null) {
                        // Assuming the sheet returns the label string (or logic to find it)
                        setState(() => _selectedValues[key] = chosen);
                        _emitChanges();
                      }
                    },
                  )
                else if (isColor)
                  SelectSheetFieldads(
                    label: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: field.label,
                            style: AppFonts.body.copyWith(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    hint:
                        _selectedValues[key] ??
                        '${(AppTranslations.of(context)?.text("choose") ?? "اختر").trim()} ${field.label}',
                    onTap: () async {
                      final chosen = await _openColorPicker(
                        _selectedValues[key],
                      );
                      if (chosen != null) {
                        setState(() => _selectedValues[key] = chosen);
                        _emitChanges();
                      }
                    },
                  )
                else
                  AppTextField(
                    controller: _controllers[key]!,
                    hint:
                        '${(AppTranslations.of(context)?.text("enter") ?? "أدخل").trim()} ${field.label}',
                    label: Text.rich(
                      TextSpan(
                        children: [
                          // Part 1: The localized text (ensure this string does NOT contain the asterisk)
                          TextSpan(text: field.label),
                          // Part 2: The Red Asterisk
                          const TextSpan(
                            text: ' *',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                    onChanged: (_) => _emitChanges(),
                    validator: (String? p1) {
                      return p1;
                    },
                  ),
                const SizedBox(height: 30),
              ],
            );
          }).toList(),
        );
      },
    );
  }
}
