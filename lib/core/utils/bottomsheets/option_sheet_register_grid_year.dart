import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/core/utils/shared_widgets/custom_button.dart';
import 'package:oreed_clean/core/utils/option_item_register.dart';
Future<String?> showAppOptionSheetregistergridyear({
  required BuildContext context,
  required String title,
  required String hint,
  required String subtitle,
  required Map<String, List<OptionItemregister>> groupedOptions,
  String? current,
}) {
  const Color designBlue = Color(0xFF154DBB);

  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) {
      String? selectedOption = current;
      final TextEditingController searchCtrl = TextEditingController();
      final isRTL = Directionality.of(context) == TextDirection.rtl;
      Map<String, List<OptionItemregister>> filteredGroups =
          Map.from(groupedOptions);

      void filter(String val, StateSetter setState) {
        setState(() {
          if (val.isEmpty) {
            filteredGroups = Map.from(groupedOptions);
          } else {
            filteredGroups = {};
            groupedOptions.forEach((key, list) {
              final filtered = list
                  .where(
                      (e) => e.label.toLowerCase().contains(val.toLowerCase()))
                  .toList();
              if (filtered.isNotEmpty) {
                filteredGroups[key] = filtered;
              }
            });
          }
        });
      }

      return StatefulBuilder(
        builder: (context, setState) {
          return Container(
            constraints: BoxConstraints(
              // 👈 أقصى ارتفاع (مثلاً 80% من الشاشة)
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            decoration:  BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: AppColors.secondary, width: 5),
              ),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                // Drag handle
                Container(
                  width: 150,
                  height: 5,
                  margin: const EdgeInsets.only(top: 6, bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                // Title
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.black),
                ),
                const SizedBox(height: 6),

                // Subtitle
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xff676768),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // --- SEARCH BAR ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: TextField(
                      controller: searchCtrl,
                      textAlign: isRTL ? TextAlign.right : TextAlign.left,
                      // RTL Text
                      style: const TextStyle(fontSize: 14),
                      onChanged: (val) {
                        filter(val, setState);
                      },
                      decoration: InputDecoration(
                        hintText: hint,
                        hintStyle: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                        // Remove default underline
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 13, horizontal: 10),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(
                              left: 5, right: 10, top: 15, bottom: 15),
                          child: SvgPicture.asset(
                            'assets/svg/search.svg',
                            width: 10,
                            height: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Content
                Expanded(
                  child: filteredGroups.isEmpty
                      ? Center(
                          child: Text(
                            AppTranslations.of(context)
                                    ?.text("commonNoResults") ??
                                "لا توجد نتائج",
                            style: TextStyle(color: Colors.grey.shade400),
                          ),
                        )
                      : SingleChildScrollView(
                          padding: const EdgeInsets.only(right: 19),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: filteredGroups.entries.map((entry) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: AppColors.secondary),
                                        height: 15,
                                        width: 2,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        entry.key,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w800,
                                            color: Color(0xff0C0C0D)),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Wrap(
                                    spacing: 10,
                                    runSpacing: 12,
                                    alignment: isRTL
                                        ? WrapAlignment.start
                                        : WrapAlignment.end,
                                    children: entry.value.map((opt) {
                                      final isSelected =
                                          selectedOption == opt.label;
                                      return InkWell(
                                        onTap: () {
                                          setState(() {
                                            selectedOption = opt.label;
                                          });
                                          Navigator.pop(ctx, selectedOption);
                                        },
                                        borderRadius: BorderRadius.circular(40),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? designBlue.withOpacity(0.1)
                                                : Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(40),
                                            border: Border.all(
                                              color: isSelected
                                                  ? designBlue
                                                  : Colors.grey.shade300,
                                            ),
                                          ),
                                          child: Text(
                                            opt.label,
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: isSelected
                                                  ? FontWeight.w800
                                                  : FontWeight.w500,
                                              color: isSelected
                                                  ? Colors.black
                                                  : Colors.grey.shade600,
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                  const SizedBox(height: 18),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                ),

                // Confirm
                Padding(
                    padding:
                        const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                    child: CustomButton(
                      onTap: () {
                        Navigator.pop(ctx, selectedOption);
                      },
                      text: AppTranslations.of(context)?.text("confirm") ??
                          'تأكيد',
                    )),
              ],
            ),
          );
        },
      );
    },
  );
}
