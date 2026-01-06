import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/core/utils/shared_widgets/custom_button.dart';
import 'package:oreed_clean/core/utils/option_item_register.dart';
Future<String?> showAppOptionSheetregistergridmodel({
  required BuildContext context,
  required String title,
  required String subtitle,
  required List<OptionItemregister> options,
  String? current,
}) {

  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) {
      List<OptionItemregister> filteredOptions = List.from(options);
      String? selectedOption = current;
      final isRTL = Directionality.of(context) == TextDirection.rtl;
      return StatefulBuilder(
        builder: (context, setState) {
          return SafeArea(
            top: false,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                  constraints: BoxConstraints(
                    // 👈 أقصى ارتفاع (مثلاً 80% من الشاشة)
                    maxHeight: MediaQuery.of(context).size.height * 0.8,
                  ),
                  decoration:  BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      top: BorderSide(color: AppColors.secondary, width: 3),
                    ),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min, // 👈 مهم جداً
                      children: [
                        // --- Drag Handle ---
                        Center(
                          child: Container(
                            width: 150,
                            height: 5,
                            margin: const EdgeInsets.only(top: 12, bottom: 15),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade400,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),

                        // --- Title ---
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // --- Subtitle ---
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            subtitle,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xff676768),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // --- Options (fixed 4 columns) ---
                        Padding(
                          padding: const EdgeInsets.only(right: 10, left: 10),
                          child: GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: MediaQuery.of(context).size.width>400?4:3,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 10,
                            childAspectRatio: 2.2,
                            children: filteredOptions.map((opt) {
                              final isSelected = selectedOption == opt.label;

                              return Center(
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      selectedOption = opt.label;
                                    });
                                    Navigator.pop(ctx, selectedOption);
                                  },
                                  borderRadius: BorderRadius.circular(30),
                                  child: SizedBox(
                                    width: double.infinity, // ✅ يملأ عرض الخلية
                                    height: double.infinity,
                                    child: Container(
                                      alignment:
                                          Alignment.center, // ✅ محتوى بالمنتصف
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? const Color(0xFF154DBB)
                                                .withOpacity(0.1)
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(30),
                                        border: Border.all(
                                          color: isSelected
                                              ? const Color(0xFF154DBB)
                                              : Colors.grey.shade300,
                                        ),
                                      ),
                                      child: opt.icon != null
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .center, // ✅ مهم
                                              mainAxisSize: MainAxisSize.min,
                                              textDirection: isRTL
                                                  ? TextDirection.rtl
                                                  : TextDirection.ltr,
                                              children: [
                                                SvgPicture.asset(
                                                  opt.icon!,
                                                  width: 16,
                                                  height: 16,
                                                  color: isSelected
                                                      ? Colors.black
                                                      : const Color(0xff676768),
                                                ),
                                                const SizedBox(width: 6),
                                                Flexible(
                                                  child: Text(
                                                    opt.label,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      color: isSelected
                                                          ? Colors.black
                                                          : const Color(
                                                              0xff676768),
                                                      fontWeight: isSelected
                                                          ? FontWeight.w800
                                                          : FontWeight.w500,
                                                    ),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Text(
                                              opt.label,
                                              textAlign: TextAlign.center,
                                              textDirection: isRTL
                                                  ? TextDirection.rtl
                                                  : TextDirection.ltr,
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: isSelected
                                                    ? Colors.black
                                                    : const Color(0xff676768),
                                                fontWeight: isSelected
                                                    ? FontWeight.w800
                                                    : FontWeight.w500,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),

                        const SizedBox(height: 30),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: CustomButton(
                            onTap: () {
                              Navigator.pop(ctx, selectedOption);
                            },
                            text:
                                AppTranslations.of(context)?.text("confirm") ??
                                    "تأكيد",
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      );
    },
  );
}
