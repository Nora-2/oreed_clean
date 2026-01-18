import 'package:flutter/material.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/features/companyprofile/presentation/widgets/ad_card_newlook.dart';
import 'package:oreed_clean/features/companyprofile/presentation/widgets/build_priorty_option.dart';

class Priortymenu extends StatelessWidget {
  const Priortymenu({
    super.key,
    required this.t,
    required bool isUpdatingPriority,
    required this.widget,
  }) : _isUpdatingPriority = isUpdatingPriority;

  final AppTranslations t;
  final bool _isUpdatingPriority;
  final AdCardNewLook widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with drag indicator
          Column(
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                t.text('set_ad_priority'),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                t.text('choose_priority_to_increase_visibility'),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                  fontSize: 13,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Priority options
          BuildPriorityOption(
            isUpdatingPriority: _isUpdatingPriority,

            priority: 1,
            titleAr: t.text('very_high_priority'),
            subtitleAr: t.text('maximum_visibility'),
            icon: Icons.star,
            color: const Color(0xFFFFC837),

            companyId: widget.companyId,
            badgeColor: const Color(0xFFFFC837),
            adId: widget.adId,
            sectionId: widget.sectionId,
          ),
          const SizedBox(height: 12),
          BuildPriorityOption(
            adId: widget.adId,
            sectionId: widget.sectionId,
            isUpdatingPriority: _isUpdatingPriority,

            priority: 2,
            titleAr: t.text('high_priority'),
            subtitleAr: t.text('featured_visibility'),
            icon: Icons.star_half,
            color: const Color(0xFFFF9800),
            badgeColor: const Color(0xFFFFC107),
            companyId: widget.companyId,
          ),
          const SizedBox(height: 12),
          BuildPriorityOption(
            adId: widget.adId,
            sectionId: widget.sectionId,
            isUpdatingPriority: _isUpdatingPriority,

            priority: 3,
            titleAr: t.text('medium_priority'),
            subtitleAr: t.text('good_visibility'),
            icon: Icons.star_half_outlined,
            color: const Color(0xFF2196F3),
            badgeColor: const Color(0xFFBBDEFB),
            companyId: widget.companyId,
          ),
          const SizedBox(height: 12),
          BuildPriorityOption(
            adId: widget.adId,
            sectionId: widget.sectionId,
            isUpdatingPriority: _isUpdatingPriority,

            priority: 4,
            titleAr: t.text('normal_priority'),
            subtitleAr: t.text('standard_visibility'),
            icon: Icons.star_outline,
            color: Colors.grey[600]!,
            badgeColor: Colors.grey[300]!,
            companyId: widget.companyId,
          ),
          const SizedBox(height: 12),
          BuildPriorityOption(
            isUpdatingPriority: _isUpdatingPriority,

            priority: 5,
            titleAr: t.text('low_priority'),
            subtitleAr: t.text('basic_visibility'),
            icon: Icons.stars_outlined,
            color: Colors.grey[400]!,
            badgeColor: Colors.grey[200]!,
            companyId: widget.companyId,
            adId: widget.adId,
            sectionId: widget.sectionId,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
