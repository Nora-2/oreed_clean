import 'package:flutter/material.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/features/sub_category/data/models/company_model.dart';
import 'package:oreed_clean/features/sub_category/presentation/widgets/compines_grid.dart';

class CompaniesSection extends StatelessWidget {
  final List<CompanyModel> companies;
  final ValueChanged<CompanyModel>? onCompanyTap;

  const CompaniesSection(
      {super.key, required this.companies, this.onCompanyTap});

  @override
  Widget build(BuildContext context) {
    final t = AppTranslations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppColors.secondary),
              height: 20,
              width: 3,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              t?.text('companies.title') ?? "الشركات",
              style:  TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        CompaniesGrid(
          companies: companies,
          onTap: onCompanyTap, // 👈
        ),
      ],
    );
  }
}
