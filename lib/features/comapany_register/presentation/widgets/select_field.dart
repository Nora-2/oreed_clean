import 'package:flutter/material.dart';
import 'package:oreed_clean/features/comapany_register/presentation/widgets/inputdecoration.dart';

class SelectField extends StatelessWidget {
  const SelectField({super.key, 
    required this.label,
    this.value,
    this.errorText,
    this.onTap,
  });

  final String label;
  final String? value;
  final String? errorText;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: InputDecorator(
        decoration: selectDecoration(
          label: label,
          errorText: errorText,
        ),
        child: Text(value ?? label, style: const TextStyle(fontSize: 14)),
      ),
    );
  }
}
