import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/core/utils/option_item_register.dart';
import 'package:oreed_clean/core/utils/shared_widgets/custom_button.dart';

Future<String?> showAppOptionSheetregister({
  required BuildContext context,
  required String title,
  required String hint,
  required String subtitle,
  required List<OptionItemregister> options,
  required Color Function(int tag) tagColor,
  String? current,
}) {
  const Color designBlue = Color(0xFF154DBB);
  // const Color designOrange = Color(0xFFF6A609);

  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) {
      List<OptionItemregister> filteredOptions = List.from(options);
      String? selectedOption = current;
      final TextEditingController searchCtrl = TextEditingController();

      return StatefulBuilder(
        builder: (context, setState) {
          final isRTL = Directionality.of(context) == TextDirection.rtl;

          return SafeArea(
              top: false,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.80,
                decoration:  BoxDecoration(
                  color: Colors.white,
                  border: Border(
                      top: BorderSide(color: AppColors.secondary, width: 5)),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: Column(
                  children: [
                    // --- Drag Handle ---
                    Center(
                      child: Container(
                        width: 150,
                        height: 5,
                        margin: const EdgeInsets.only(top: 12, bottom: 15),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    // --- Title ---
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // --- Subtitle ---
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        subtitle,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xff676768),
                          fontWeight: FontWeight.w500,
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
                            setState(() {
                              if (val.isEmpty) {
                                filteredOptions = List.from(options);
                              } else {
                                filteredOptions = options
                                    .where((element) => element.label
                                        .toLowerCase()
                                        .contains(val.toLowerCase()))
                                    .toList();
                              }
                            });
                          },
                          decoration: InputDecoration(
                            hintText: hint,
                            hintStyle: const TextStyle(
                              color: Color(0xff676768),
                              fontSize: 14,
                            ),
                            // Remove default underline
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 13, horizontal: 20),
                            prefixIcon: SizedBox(
                              width: 15,
                              height: 20,
                              child: Center(
                                child: SvgPicture.asset(
                                  'assets/svg/search.svg',
                                  width: 20,
                                  height: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // --- Filtered List Options ---
                    Expanded(
                      child: filteredOptions.isEmpty
                          ? Center(
                              child: Text(
                                AppTranslations.of(context)?.text("confirm") ?? "لا توجد نتائج" ,
                                style: TextStyle(color: Colors.grey.shade400),
                              ),
                            )
                          : ListView.separated(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              itemCount: filteredOptions.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 12),
                              itemBuilder: (_, i) {
                                final opt = filteredOptions[i];
                                final isSelected = selectedOption == opt.label;

                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      selectedOption = opt.label;
                                    });
                                    Navigator.pop(ctx, selectedOption);
                                  },
                                  borderRadius: BorderRadius.circular(30),
                                  child: Container(
                                    height: 40,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? designBlue.withOpacity(0.1)
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(
                                        color: isSelected
                                            ? designBlue
                                            : Colors.grey.shade300,
                                        width: isSelected ? 1.5 : 1,
                                      ),
                                    ),
                                    child: Row(
                                      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                                      children: [
                                        SvgPicture.asset(
                                          opt.icon!,
                                          color: Colors.black,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            opt.label,
                                            textAlign: isRTL ? TextAlign.right : TextAlign.left,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: isSelected
                                                  ? FontWeight.w700
                                                  : FontWeight.w500,
                                              color: isSelected
                                                  ? Colors.black
                                                  : Colors.grey.shade600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 20),
                      child: CustomButton(
                          onTap: () {
                            Navigator.pop(ctx, selectedOption);
                          },
                          text :AppTranslations.of(context)?.text("confirm") ?? "تأكيد")
                    )
                  ],
                ),
              ));
        },
      );
    },
  );
}
