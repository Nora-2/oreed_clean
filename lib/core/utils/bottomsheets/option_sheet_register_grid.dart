import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/core/utils/appicons/app_icons.dart';
import 'package:oreed_clean/core/utils/shared_widgets/custom_button.dart';
import 'package:oreed_clean/core/utils/option_item_register.dart';
Future<String?> showAppOptionSheetregistergrid({
  required BuildContext context,
  required String title,
  required String hint,
  required String subtitle,
  required List<OptionItemregister> options,
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
      final isRTL = Directionality.of(context) == TextDirection.rtl;
      return StatefulBuilder(
        builder: (context, setState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.80,
            decoration:  BoxDecoration(
              color: Colors.white,
              border:
                  Border(top: BorderSide(color: AppColors.secondary, width: 5)),
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
                    fontWeight: FontWeight.w800,
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
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade500,
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
                        hintStyle: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 14,
                        ),
                        // Remove default underline
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 13, horizontal: 20),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(
                              left: 5, right: 10, top: 15, bottom: 15),
                          child: SvgPicture.asset(
                           AppIcons.search,
                            width: 10,
                            height: 14,
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
                            AppTranslations.of(context)
                                    ?.text("commonNoResults") ??
                                "لا توجد نتائج",
                            style: TextStyle(color: Colors.grey.shade400),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 6,
                              mainAxisSpacing: 6,
                              childAspectRatio: 1.3,
                            ),
                            itemCount: filteredOptions.length,
                            itemBuilder: (context, index) {
                              final opt = filteredOptions[index];
                              final isSelected = selectedOption == opt.label;
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    selectedOption = opt.label;
                                  });
                                  Navigator.pop(ctx, selectedOption);
                                },
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 2, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? designBlue.withOpacity(0.1)
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: isSelected
                                          ? designBlue
                                          : Colors.grey.shade300,
                                      width: isSelected ? 1.5 : 1,
                                    ),
                                  ),
                                  child: opt.icon != null
                                      ? Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.network(
                                              opt.icon!,
                                              width: 40,
                                              height: 40,
                                            ),
                                            const SizedBox(height: 2),
                                            Flexible(
                                              child: Text(
                                                opt.label,
                                                textAlign: TextAlign.center,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: isSelected
                                                      ? FontWeight.w800
                                                      : FontWeight.w500,
                                                  color: isSelected
                                                      ? Colors.black
                                                      : Colors.grey.shade600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      : Center(
                                          child: Text(
                                            opt.label,
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: isSelected
                                                  ? FontWeight.w800
                                                  : FontWeight.w500,
                                              color: isSelected
                                                  ? Colors.black
                                                  : Colors.grey.shade600,
                                            ),
                                          ),
                                        ),
                                ),
                              );
                            },
                          ),
                        ),
                ),

                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  child: CustomButton(
                      onTap: () {
                        Navigator.pop(ctx, selectedOption);
                      },
                      text: AppTranslations.of(context)?.text("confirm") ??
                          "تأكيد"),
                )
              ],
            ),
          );
        },
      );
    },
  );
}
