import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/core/utils/appicons/app_icons.dart';
import 'package:oreed_clean/core/utils/appimage/app_images.dart';
import 'package:oreed_clean/core/utils/shared_widgets/custom_button.dart';
import 'package:oreed_clean/features/technicalforms/presentation/widgets/review_section.dart';

class GenericReviewScreen extends StatefulWidget {
  const GenericReviewScreen({
    super.key,
    required this.pageTitle,
    required this.sections,
    this.requireAgreement = true,
    this.confirmLabel, // Now optional, will fallback to localized "تأكيد ونشر"
    this.onConfirm, // اختياري: تنفيذ نشر فعلي قبل الإغلاق
  });

  final String pageTitle;
  final List<ReviewSection> sections;
  final bool requireAgreement;

  final String? confirmLabel;
  final Future<void> Function()? onConfirm;

  @override
  State<GenericReviewScreen> createState() => _GenericReviewScreenState();
}

class _GenericReviewScreenState extends State<GenericReviewScreen> {
  static final _orange = AppColors.accentLight;

  bool _loading = false;
  final bool _agreeChecked = true; // user agreement state

  // Open full image preview
  void _openImagePreview(dynamic file) {
    if (file == null) return;
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        insetPadding: const EdgeInsets.all(16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: InteractiveViewer(
            panEnabled: true,
            minScale: 0.8,
            maxScale: 3.0,
            child: Image.file(file, fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }

  Future<void> _handleConfirm() async {
    if (widget.requireAgreement && !_agreeChecked) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppTranslations.of(context)?.text("review.please_agree") ??
                'يرجى الموافقة قبل النشر',
          ),
        ),
      );
      return;
    }
    setState(() => _loading = true);
    try {
      if (widget.onConfirm != null) {
        await widget.onConfirm!();
      }
      if (mounted) {
        Navigator.pop(context, const ReviewScreenResult(confirmed: true));
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppTranslations.of(context)?.text("review.publish_error") ??
                'حصل خطأ أثناء النشر، حاول مرة أخرى',
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _handleEdit(String keyName) {
    Navigator.pop(
      context,
      ReviewScreenResult(confirmed: false, editSection: keyName),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tr = AppTranslations.of(context);
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Appimage.addAdDetails),
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Header (Back button and Title)
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xffe8e8e9),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: const EdgeInsets.all(6),
                      child: Icon(Icons.arrow_back, color: AppColors.primary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                widget.pageTitle.isNotEmpty
                    ? widget.pageTitle
                    : (tr?.text("review.screen_title") ??
                          'راجع إعلانك قبل النشر'),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),

              // SECTIONS LOOP
              for (final sec in widget.sections) ...[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 1. Section Title Row
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        children: [
                          // Orange pipe marker
                          Container(
                            height: 20,
                            width: 3,
                            color: _orange,
                            margin: const EdgeInsets.only(left: 8, right: 8),
                          ),

                          Expanded(
                            child: Text(
                              sec.title,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                                color: AppColors.black,
                              ),
                            ),
                          ),
                          // Edit Button
                          GestureDetector(
                            onTap: () => _handleEdit(sec.keyName),
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xffE8E8E9),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              padding: const EdgeInsets.all(8),
                              child: SvgPicture.asset(
                                AppIcons.editPen,
                                height: 16,
                                width: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 2. The Main Block (Card) containing both Text and Images
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xffE8E8E9),
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // A. Text Items (Description, etc.)
                          for (final it in sec.items)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: _KVRow(
                                label: it.label,
                                value: it.value,
                                icon: it.icon,
                              ),
                            ),

                          // B. Images (Inline inside the same block)
                          if (sec.images != null && sec.images!.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            _InlineImagesRow(
                              images: sec.images!,
                              onTap: _openImagePreview,
                            ),
                          ],

                          // C. Custom Widgets (if any)
                          if (sec.custom != null) ...[
                            const SizedBox(height: 12),
                            sec.custom!,
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],

              // Footer Button
              CustomButton(
                text:
                    widget.confirmLabel ??
                    (tr?.text("action.confirm_publish") ??
                        'تأكيد ونشر'), // Use dynamic label
                onTap: _handleConfirm,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      // Loading Overlay
      bottomSheet: _loading
          ? Container(
              color: Colors.black12,
              height: double.infinity,
              width: double.infinity,
              child: const Center(child: CircularProgressIndicator()),
            )
          : null,
    );
  }
}

class _KVRow extends StatelessWidget {
  const _KVRow({required this.label, required this.value, this.icon});

  final String label;
  final String value;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 18, color: const Color(0xFF7B8499)),
          const SizedBox(width: 8),
        ],
        // Label (e.g., "الوصف:")
        SizedBox(
          width: 80,
          child: Text(
            label, // Added colon
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Color(0xFF1C1C1E),
            ),
          ),
        ),

        const SizedBox(width: 50),
        // Value (e.g., "أودي A4...")
        Expanded(
          child: Text(
            value.isEmpty ? '-' : value,
            textAlign: TextAlign.start,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: Color(0xff676768),
              height: 1.4, // Better line spacing for description
            ),
          ),
        ),
      ],
    );
  }
}

// New Widget specifically for the "Images: [img] [img]" layout
class _InlineImagesRow extends StatelessWidget {
  const _InlineImagesRow({required this.images, this.onTap});

  final List<dynamic> images;
  final void Function(dynamic file)? onTap;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemCount: images.length,
      itemBuilder: (context, index) {
        final file = images[index];
        return GestureDetector(
          onTap: () => onTap?.call(file),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(file, fit: BoxFit.cover),
            ),
          ),
        );
      },
    );
  }
}
