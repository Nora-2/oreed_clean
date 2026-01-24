
import 'package:flutter/material.dart';
import 'package:oreed_clean/features/sub_category/data/models/company_model.dart';
import 'package:oreed_clean/features/sub_category/presentation/widgets/CompanyCardsubcategory.dart';

class CompaniesGrid extends StatelessWidget {
  final List<CompanyModel> companies;
  final ValueChanged<CompanyModel>? onTap;

  const CompaniesGrid({super.key, required this.companies, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: companies.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 4,
        childAspectRatio: 1.1,
      ),
      itemBuilder: (context, index) {
        final company = companies[index];
        return CompanyCardsubcategory(
          title: company.name,
          imageUrl: company.logoUrl,
          len: companies.length,
          onTap: onTap == null ? null : () => onTap!(company),
        );
      },
    );
  }
}
