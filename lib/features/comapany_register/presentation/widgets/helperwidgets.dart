import 'package:flutter/material.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';

class RegisterAppBar extends StatelessWidget {
  final int currentStep;
  final VoidCallback onBack;
  final VoidCallback onPop;

  const RegisterAppBar({
    super.key,
    required this.currentStep,
    required this.onBack,
    required this.onPop,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: IconButton(
        icon: CircleAvatar(
          backgroundColor: Colors.white,
          child: Icon(Icons.arrow_back, color: AppColors.primary),
        ),
        onPressed: currentStep == 2 ? onBack : onPop,
      ),
    );
  }
}
class RegisterHeader extends StatelessWidget {
  final AppTranslations t;

  const RegisterHeader({super.key, required this.t});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          t.text('auth.create_company_account'),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            t.text('company_register_subtitle'),
            style: const TextStyle(color: Colors.white70),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
class RegisterToggleTabs extends StatelessWidget {
  final int currentPage;
  final ValueChanged<int> onTabChange;
  final AppTranslations t;

  const RegisterToggleTabs({
    super.key,
    required this.currentPage,
    required this.onTabChange,
    required this.t,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: AppColors.secondary),
        ),
        child: Row(
          children: [
            _TabItem(
              index: 0,
              label: t.text('auth.create_company_account'),
              currentPage: currentPage,
              onTap: onTabChange,
            ),
            _TabItem(
              index: 1,
              label: t.text('login'),
              currentPage: currentPage,
              onTap: onTabChange,
            ),
          ],
        ),
      ),
    );
  }
}
class _TabItem extends StatelessWidget {
  final int index;
  final int currentPage;
  final String label;
  final ValueChanged<int> onTap;

  const _TabItem({
    required this.index,
    required this.currentPage,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool active = currentPage == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        child: Container(
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: active ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(40),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: active ? Colors.white : AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
