
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/core/utils/appicons/app_icons.dart';
import 'package:oreed_clean/core/utils/shared_widgets/custom_button.dart';

class PriorityBottomSheet extends StatefulWidget {
  final int companyId;

  const PriorityBottomSheet({super.key, required this.companyId});

  @override
  State<PriorityBottomSheet> createState() => _PriorityBottomSheetState();
}

class _PriorityBottomSheetState extends State<PriorityBottomSheet> {
  int _currentStep = 1; // 1 = Priority Level, 2 = Rank Selection
  int _selectedPriority = 0; // Index of priority
  int _selectedRank = 0; // Index of rank

  List<Map<String, String>> _getPriorities(AppTranslations? t) => [
        {
          'title': t?.text('very_high_priority') ?? 'أولوية عالية جداً',
          'subtitle': t?.text('maximum_visibility') ?? 'أقصى ظهور للاعلان'
        },
        {
          'title': t?.text('high_priority') ?? 'أولوية عالية',
          'subtitle': t?.text('featured_visibility') ?? 'ظهور متميز'
        },
        {
          'title': t?.text('normal_priority') ?? 'أولوية عادية',
          'subtitle': t?.text('standard_visibility') ?? 'ظهور قياسي'
        },
      ];

  List<Map<String, String>> _getRanks(AppTranslations? t) => [
        {
          'title': t?.text('first_rank') ?? 'الأول',
          'subtitle': t?.text('first_rank_desc') ?? 'يظهر إعلانك في أعلى الصفحة'
        },
        {
          'title': t?.text('second_rank') ?? 'الثاني',
          'subtitle': t?.text('second_rank_desc') ?? 'يظهر بعد الإعلان الأول'
        },
        {
          'title': t?.text('third_rank') ?? 'الثالث',
          'subtitle': t?.text('third_rank_desc') ?? 'يظهر بعد الإعلان الثاني'
        },
      ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:  BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.secondary, width: 5)),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Directionality(
        textDirection: TextDirection.rtl, // Set RTL for Arabic
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top Indicator
            Container(
                width: 150,
                height: 4,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 24),

            // Header (Changes based on step)
            _buildHeader(),
            const SizedBox(height: 24),

            // Content List
            _currentStep == 1 ? _buildPriorityList() : _buildRankList(),
            const SizedBox(height: 24),

            // Footer Buttons
            _buildFooter(),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final t = AppTranslations.of(context);
    final priorities = _getPriorities(t);
    String title = _currentStep == 1
        ? t?.text('choose_ad_visibility_order') ??
            "اختر ترتيب ظهور هذا الإعلان للزوار"
        : priorities[_selectedPriority]['title']!;
    String subtitle = _currentStep == 1
        ? t?.text('visibility_order_company_page') ??
            "ترتيب الظهور في صفحة الشركة"
        : priorities[_selectedPriority]['subtitle']!;

    return Column(
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black)),
        const SizedBox(height: 4),
        Text(subtitle, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
      ],
    );
  }

  // Right Screenshot UI
  Widget _buildPriorityList() {
    final t = AppTranslations.of(context);
    final priorities = _getPriorities(t);
    return Column(
      children: List.generate(priorities.length, (index) {
        bool isSelected = _selectedPriority == index;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () => setState(() {
              _selectedPriority = index;
              _currentStep = 2; // Transition to Step 2
            }),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: isSelected
                        ? const Color(0xFF1E4AD3)
                        : Colors.grey[100]!),
                color: isSelected ? const Color(0xFFF5F8FF) : Colors.white,
              ),
              child: Row(
                textDirection: TextDirection.ltr,
                children: [
                  // Blue Arrow Icon
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF1E4AD3)
                            : const Color(0xffE8E8E9).withOpacity(.5),
                        shape: BoxShape.circle),
                    child: Icon(Icons.arrow_forward,
                        color: isSelected
                            ? AppColors.secondary
                            : const Color(0xFF1E4AD3),
                        size: 16),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(priorities[index]['title']!,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                        Text(priorities[index]['subtitle']!,
                            style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 4),
                  SvgPicture.asset(
                    index == 0
                        ? AppIcons.ratingStarFull
                        : index == 1
                            ? AppIcons.ratingStarHalf
                            : AppIcons.ratingStarEmpty,
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  // Left Screenshot UI
  Widget _buildRankList() {
    final t = AppTranslations.of(context);
    final ranks = _getRanks(t);
    return Column(
      children: List.generate(ranks.length, (index) {
        bool isSelected = _selectedRank == index;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () => setState(() => _selectedRank = index),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: isSelected
                        ? const Color(0xFF1E4AD3)
                        : Colors.grey[100]!),
                color: isSelected ? const Color(0xFFF5F8FF) : Colors.white,
              ),
              child: Row(
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF1E4AD3)
                            : Colors.grey[300]!,
                        width: 1.4,
                      ),
                    ),
                    child: isSelected
                        ? Center(
                            child: Container(
                              width: 15,
                              height: 15,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFF1E4AD3),
                              ),
                            ),
                          )
                        : null,
                  ),

                  const SizedBox(
                    width: 5,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(ranks[index]['title']!,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                      Text(ranks[index]['subtitle']!,
                          style: const TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w600,
                              fontSize: 12)),
                    ],
                  ),
                  // Custom Radio Button
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildFooter() {
    final t = AppTranslations.of(context);
    return CustomButton(
        onTap: () {
          if (_currentStep == 2) {
            setState(() => _currentStep = 1);
          } else {
            Navigator.pop(context);
          }
        },
        text: t?.text('confirm') ?? 'تأكيد');
  }
}
