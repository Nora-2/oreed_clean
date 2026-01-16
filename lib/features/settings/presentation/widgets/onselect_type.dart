import 'package:flutter/material.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/core/utils/shared_widgets/custom_button.dart';
import 'package:oreed_clean/features/settings/data/models/local_type.dart';

Future<void> onSelectType({required BuildContext context}) {
  AppTranslations appTrans = AppTranslations.of(context)!;

  final List<LocalType> types = [
    LocalType(
      id: "new_contracts",
      titleAr: "طلب اشتراك جديد",
      titleEn: "New contracts",
    ),
    LocalType(
      id: "complaints_suggestions",
      titleAr: "شكاوى واقتراحات",
      titleEn: "Complaints and suggestions",
    ),
  ];

  return showModalBottomSheet<LocalType>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) {
      LocalType? selectedType;

      return StatefulBuilder(
        builder: (context, setState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.40,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: AppColors.secondary, width: 5),
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: Column(
              children: [
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

                /// ───────── Title ─────────
                Text(
                  appTrans.text("select_type"),
                  style: TextStyle(
                    fontSize: 20,
                    color: AppColors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                /// ───────── Subtitle ─────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    appTrans.text("please_select_appropriate_type"),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xff676768),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// ───────── List ─────────
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: types.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, i) {
                      final item = types[i];
                      final isSelected = selectedType == item;

                      return InkWell(
                        onTap: () {
                          setState(() {
                            selectedType = item;
                          });
                        },
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          height: 40,
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: isSelected
                                ? AppColors.primary.withOpacity(0.1)
                                : Colors.white,
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : Colors.grey.shade300,
                              width: isSelected ? 1.5 : 1,
                            ),
                          ),
                          child: Row(
                            textDirection: TextDirection.rtl,
                            children: [
                              Expanded(
                                child: Text(
                                  appTrans.text(item.id ?? ''),
                                  textAlign: TextAlign.right,
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
                    horizontal: 15,
                    vertical: 20,
                  ),
                  child: CustomButton(
                    text: appTrans.text("confirm"),
                    onTap: () {
                      Navigator.pop(ctx, selectedType);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
