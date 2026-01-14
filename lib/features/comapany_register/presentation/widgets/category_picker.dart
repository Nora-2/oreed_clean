import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:oreed_clean/core/utils/bottomsheets/option_sheet_register_grid.dart';
import 'package:oreed_clean/core/utils/option_item_register.dart';
import 'package:oreed_clean/features/comapany_register/domain/entities/category_entity.dart';
import 'package:oreed_clean/features/comapany_register/presentation/widgets/inputdecoration.dart';
import 'package:oreed_clean/features/home/domain/entities/section_entity.dart';

class CategoryPicker extends StatelessWidget {
  const CategoryPicker({super.key, 
    required this.label,
    required this.value,
    required this.options,
    required this.onSelected,
    required this.title,
    required this.errorRequired,
    required this.hint,required this.subtitle
  });

  final String? label;
  final String? value;
  final String title;
  final bool errorRequired;
  final List<CategoryEntity> options;
  final ValueChanged<CategoryEntity> onSelected;
  
  final String subtitle;
  
  final String hint;

  @override
  Widget build(BuildContext context) {
    return FormField<CategoryEntity>(
      validator: (_) => errorRequired ? 'Required' : null,
      builder: (field) => GestureDetector(
        onTap: options.isEmpty
            ? null
            : () async {
                final res = await showAppOptionSheetregistergrid(
                  context: context,
                  title: title,
                  options: options
                      .asMap()
                      .entries
                      .map((e) => OptionItemregister(
                            label: e.value.name,
                            icon: e.value.image,
                            colorTag: e.key,
                          ))
                      .toList(),
                  current: value, hint: hint, subtitle: subtitle
                );

                if (res != null) {
                  final cat =
                      options.firstWhere((c) => c.name == res);
                  onSelected(cat);
                  field.didChange(cat);
                }
              },
        child: InputDecorator(
          decoration: selectDecoration(
            label: label ?? '',
            errorText: field.errorText,
          ),
          child: Text(value ?? label ?? '',
              style: const TextStyle(fontSize: 16)),
        ),
      ),
    );
  }
}


class SectionPicker extends StatelessWidget {
  const SectionPicker({super.key, 
    required this.label,
    required this.value,
    required this.options,
    required this.onSelected,
    required this.title,
    required this.errorRequired,
    required this.hint,required this.subtitle
  });

  final String? label;
  final String? value;
  final String title;
  final bool errorRequired;
  final List<SectionEntity> options;
  final ValueChanged<SectionEntity> onSelected;
  
  final String subtitle;
  
  final String hint;

  @override
  Widget build(BuildContext context) {
    return FormField<SectionEntity>(
      validator: (_) => errorRequired ? 'Required' : null,
      builder: (field) => GestureDetector(
        onTap: options.isEmpty
            ? null
            : () async {
                final res = await showAppOptionSheetregistergrid(
                  context: context,
                  title: title,
                  options: options
                      .asMap()
                      .entries
                      .map((e) => OptionItemregister(
                            label: e.value.name,
                            icon: e.value.image,
                            colorTag: e.key,
                          ))
                      .toList(),
                  current: value, hint: hint, subtitle: subtitle
                );

                if (res != null) {
                  final cat =
                      options.firstWhere((c) => c.name == res);
                  onSelected(cat);
                  field.didChange(cat);
                }
              },
        child: InputDecorator(
          decoration: selectDecoration(
            label: label ?? '',
            errorText: field.errorText,
          ),
          child: Text(value ?? label ?? '',
              style: const TextStyle(fontSize: 16)),
        ),
      ),
    );
  }
}
