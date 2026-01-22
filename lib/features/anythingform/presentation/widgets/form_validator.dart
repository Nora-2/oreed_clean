import 'package:flutter/material.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/features/anythingform/presentation/widgets/state_manager.dart';

class AnythingFormValidator {
  final AnythingFormStateManager stateManager;

  AnythingFormValidator({required this.stateManager});

  List<String> validateFields(AppTranslations? appTrans, bool isEditing) {
    final errs = <String>[];

    if (stateManager.titleCtrl.text.trim().isEmpty || 
        stateManager.titleCtrl.text.trim().length < 3) {
      errs.add('title');
    }
    
    if (!_isPositiveNumber(stateManager.priceCtrl.text)) {
      errs.add('price');
    }
    
    if (stateManager.descCtrl.text.trim().isEmpty) {
      errs.add('description');
    }
    
    if (stateManager.selectedCountryId == null) errs.add('state');
    if (stateManager.selectedStateId == null) errs.add('city');
    
    if (!isEditing && 
        stateManager.mainImageFile == null && 
        stateManager.mainImageUrl == null) {
      errs.add('images');
    }

    return errs;
  }

  void showFillAllFieldsSnack(BuildContext context, AppTranslations? appTrans) {
    final msg =
        appTrans?.text('validation.fill_all_fields') ??
        'من فضلك أدخل جميع الحقول المطلوبة';

    final bar = SnackBar(
      content: Row(
        children: [
          const Icon(Icons.info_outline_rounded, color: Colors.white),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              msg,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
      backgroundColor: AppColors.primary,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      duration: const Duration(seconds: 3),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(bar);
  }

  bool _isPositiveNumber(String? v) {
    if (v == null) return false;
    final t = v.trim();
    if (t.isEmpty) return false;
    final n = num.tryParse(t.replaceAll(',', ''));
    return n != null && n > 0;
  }
}
