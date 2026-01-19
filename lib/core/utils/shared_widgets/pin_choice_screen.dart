import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/core/utils/appicons/app_icons.dart';
import 'package:oreed_clean/core/utils/appimage/app_images.dart';
import 'package:oreed_clean/core/utils/shared_widgets/custom_button.dart';
import 'package:oreed_clean/core/utils/shared_widgets/option_card.dart';
import 'package:oreed_clean/features/chooseplane/domain/entities/package_entity.dart';
import 'package:oreed_clean/features/chooseplane/presentation/pages/chooseplan_screen.dart';

/// The specific ad types
enum AdType { free, pinned, featured }

class PinChoiceScreen extends StatefulWidget {
  const PinChoiceScreen({super.key});

  static Future<PackageEntity?> show(BuildContext context) {
    return Navigator.push<PackageEntity>(
      context,
      MaterialPageRoute(builder: (_) => const PinChoiceScreen()),
    );
  }

  @override
  State<PinChoiceScreen> createState() => _PinChoiceScreenState();
}

class _PinChoiceScreenState extends State<PinChoiceScreen> {
  // Default selection (Pinned - generally the up-sell)
  AdType _selectedType = AdType.pinned;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100, // Background behind the card
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              border: Border(
                top: BorderSide(color: AppColors.secondary, width: 3),
              ),
              boxShadow: [
                BoxShadow(
                  // ignore: deprecated_member_use
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Shrink to fit content
              children: [
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),

                // --- Drag Handle (Visual only) ---
                Container(
                  width: 150,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                // --- Header ---
                Text(
                  textDirection: TextDirection.ltr,
                  AppTranslations.of(
                        context,
                      )?.text("pin_choice.ready_to_publish") ??
                      '!إعلانك جاهز للنشر',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  AppTranslations.of(
                        context,
                      )?.text("pin_choice.choose_view_method") ??
                      'اختر طريقة عرض إعلانك ليصل لأكبر عدد من المهتمين',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 24),

                // --- Options List ---
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // 1. Free Option
                        OptionCard(
                          value: AdType.free,
                          groupValue: _selectedType,
                          title:
                              AppTranslations.of(
                                context,
                              )?.text("ad_type.free") ??
                              'إعلان مجاني',
                          icon: AppIcons.sound,
                          borderColor: const Color(0xFF154BB6),
                          features: [
                            AppTranslations.of(
                                  context,
                                )?.text("pin_choice.free.feature1") ??
                                'ينشر في قائمة الاعلانات العادية بدون إبراز',
                            AppTranslations.of(
                                  context,
                                )?.text("pin_choice.free.feature2") ??
                                'نشر إعلان مجاني',
                            AppTranslations.of(
                                  context,
                                )?.text("pin_choice.common.validity_30_days") ??
                                'صلاحية 30 يوم',
                          ],
                          onChanged: (val) =>
                              setState(() => _selectedType = val),
                        ),
                        const SizedBox(height: 16),

                        // 2. Pinned Option (Featured/Upsell)
                        OptionCard(
                          value: AdType.pinned,
                          groupValue: _selectedType,
                          title:
                              AppTranslations.of(
                                context,
                              )?.text("ad_type.pinned") ??
                              'إعلان مثبت',
                          icon: AppIcons.pin,
                          borderColor: AppColors.secondary,
                          badgeText:
                              AppTranslations.of(
                                context,
                              )?.text("pin_choice.most_popular") ??
                              'الاكثر شيوعا',
                          extraEmoji: Appimage.rocket,
                          features: [
                            AppTranslations.of(
                                  context,
                                )?.text("pin_choice.pinned.feature1") ??
                                'يثبت أعلى القسم لفترة محددة لزيادة الزيارات',
                            AppTranslations.of(
                                  context,
                                )?.text("pin_choice.pinned.feature2") ??
                                'يتم تثبيت اعلانك في القسم',
                            AppTranslations.of(
                                  context,
                                )?.text("pin_choice.common.validity_30_days") ??
                                'صلاحية 30 يوم',
                          ],
                          onChanged: (val) =>
                              setState(() => _selectedType = val),
                        ),
                        const SizedBox(height: 16),

                        // 3. Featured Option
                        OptionCard(
                          value: AdType.featured,
                          groupValue: _selectedType,
                          title:
                              AppTranslations.of(
                                context,
                              )?.text("ad_type.featured") ??
                              'إعلان مميز',
                          icon: AppIcons.star,
                          borderColor: const Color(0xFF8A2BE2).withOpacity(0.5),
                          extraEmoji: Appimage.stickerYellow,
                          features: [
                            AppTranslations.of(
                                  context,
                                )?.text("pin_choice.featured.feature1") ??
                                'إبراز بلون وشارة لزيادة المشاهدات',
                            AppTranslations.of(
                                  context,
                                )?.text("pin_choice.featured.feature2") ??
                                'نشر إعلان مميز',
                            AppTranslations.of(
                                  context,
                                )?.text("pin_choice.common.validity_30_days") ??
                                'صلاحية 30 يوم',
                          ],
                          onChanged: (val) =>
                              setState(() => _selectedType = val),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // --- Next Button ---
                CustomButton(
                  onTap: _handleNextStep,
                  text:
                      AppTranslations.of(context)?.text("nameNextBtn") ??
                      'التالي',
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleNextStep() async {
    HapticFeedback.lightImpact();

    if (_selectedType == AdType.free) {
      // Logic for free ad (Publish directly or go to success screen)
      Navigator.pop(context); // Or return null indicating free
    } else {
      // Determine type string for API
      String planType = _selectedType == AdType.pinned ? 'pinned' : 'featured';
      String title = _selectedType == AdType.pinned
          ? 'إعلان مثبت'
          : 'إعلان مميز';
      Color accent = _selectedType == AdType.pinned
          ? const Color(0xFFFF9900)
          : const Color(0xFF8A2BE2);

      // Navigate to Plan Selection using the provided snippet class
      final result = await ChoosePlanScreen.show(
        context: context,
        type: planType,
        title: title,
        icon: Icons.star,
        introText:
            AppTranslations.of(context)?.text("pin_choice.choose_duration") ??
            'اختر المدة التي تناسبك',
        accentColor: accent,
        onTap: () {},
      );

      if (result != null && mounted) {
        // User selected a plan, return result to previous screen
        Navigator.pop(context, result);
      }
    }
  }
}
