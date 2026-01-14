import 'package:flutter/material.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/core/utils/appicons/app_icons.dart';
import 'package:oreed_clean/features/companydetails/domain/entities/company_entity.dart';

class CompanyCard extends StatelessWidget {
  final CompanyDetailsEntity company;
  final int adsCount;
  final Function(String) onCall;
  final Function(String) onWhatsApp;

  const CompanyCard({
    super.key,
    required this.company,
    required this.adsCount,
    required this.onCall,
    required this.onWhatsApp,
  });

  @override
  Widget build(BuildContext context) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(.8),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Row(
            textDirection: isRTL ? TextDirection.ltr : TextDirection.rtl,
            children: [
              Expanded(
                child: Text(
                  company.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              CircleAvatar(
                radius: 25,
                backgroundImage: company.imageUrl != null
                    ? NetworkImage(company.imageUrl!)
                    : null,
                child: company.imageUrl == null
                    ? const Icon(Icons.business)
                    : null,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => company.whatsapp != null
                      ? onWhatsApp(company.whatsapp!)
                      : null,
                  child: _actionButton(
                    context,
                    AppTranslations.of(context)?.text("whatsappPhone") ?? '',
                    AppIcons.whatsapp,
                    bordered: true,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: InkWell(
                  onTap: () =>
                      company.phone != null ? onCall(company.phone!) : null,
                  child: _actionButton(
                    context,
                    AppTranslations.of(context)?.text("call") ?? '',
                    AppIcons.phone,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionButton(
    BuildContext context,
    String title,
    String icon, {
    bool bordered = false,
  }) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: bordered ? null : Colors.white,
        border: bordered ? Border.all(color: Colors.white) : null,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            color: bordered ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
