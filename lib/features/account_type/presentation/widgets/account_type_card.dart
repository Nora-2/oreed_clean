import 'package:flutter/material.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/core/utils/textstyle/apptext_style.dart';
import 'package:oreed_clean/features/account_type/domain/entities/account_type_entity.dart';
class AccountTypeCard extends StatelessWidget {
  final AccountTypeEntity model;
  final bool isSelected;
  final VoidCallback onTap;

  const AccountTypeCard({
    super.key,
    required this.model,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withValues(alpha: 0.1)
                : AppColors.whiteColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isSelected
                  ? AppColors.primary
                  : Colors.grey.withValues(alpha: 0.25),
              width: isSelected ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 4),
              Text(
                model.title,
                style: AppTextStyles.bodyBold
                    .copyWith(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(
              textAlign: TextAlign.center,
                model.subtitle,
                style: AppTextStyles.bodySmall.copyWith(fontSize: 12,),
              ),
              const Spacer(),
              Image.asset(
                model.imageAsset,
                fit: BoxFit.cover,
                height: isSelected ? 100 : 100,
                // width: double.infinity,
                // height: 100,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AccountTypeCardbottomsheet extends StatelessWidget {
  final AccountTypeEntity model;
  final bool isSelected;
  final VoidCallback onTap;

  const AccountTypeCardbottomsheet({
    super.key,
    required this.model,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 5,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withValues(alpha: 0.1)
                : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isSelected
                  ? AppColors.primary
                  : Colors.grey.withValues(alpha: 0.25),
              width: isSelected ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 4),
              Image.asset(
                model.imageAsset,
                fit: BoxFit.cover,
                height: isSelected ? 30 : 30,
                
              ),
              Text(
                model.title,
                style: AppTextStyles.bodyBold.copyWith(
                    fontSize: isRTL ? 14 : 12, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(
                model.subtitle,
                style:
                    AppTextStyles.bodySmall.copyWith(fontSize: isRTL ? 12 : 10),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
