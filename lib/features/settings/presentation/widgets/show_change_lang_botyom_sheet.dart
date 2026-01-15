import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oreed_clean/core/app_shared_prefs.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/translation/application.dart';
import 'package:oreed_clean/core/utils/shared_widgets/custom_button.dart';
import 'package:oreed_clean/features/login/presentation/cubit/login_cubit.dart';

Future<void> showChangeLanguageBottomSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) {
      // Initial Logic from your ChangeLang class
      String selectedCode = AppSharedPreferences().languageCode ?? 'ar';
      final supportedLanguages = application.supportedLanguages;
      final supportedCodes = application.supportedLanguagesCodes;
      final appTrans = AppTranslations.of(context);

      return StatefulBuilder(
        builder: (context, setState) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(
                  color: Colors.orange,
                  width: 5,
                ), // Orange top border line
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // --- Top Drag Handle ---
                Center(
                  child: Container(
                    width: 130,
                    height: 5,
                    margin: const EdgeInsets.only(top: 15, bottom: 25),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                // --- Title ---
                Text(
                  appTrans?.text('choose_language') ?? "أختر اللغة",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 35),

                // --- Language Selection Row ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: List.generate(supportedLanguages.length, (index) {
                      final langName = supportedLanguages[index];
                      final code = supportedCodes[index];
                      final isSelected = selectedCode == code;
                      final isArabic = code == 'ar';

                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: GestureDetector(
                            onTap: () => setState(() => selectedCode = code),
                            child: Container(
                              margin: EdgeInsets.only(
                                left: index == 0 ? 0 : 8,
                                right: index == supportedLanguages.length - 1
                                    ? 0
                                    : 8,
                              ),
                              height: 45,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFFECF3FF)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(35),
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFF1E56D0)
                                      : Colors.grey.shade300,
                                  width: 1.5,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    isArabic ? "🇦🇪 " : "🇬🇧 ",
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  Text(
                                    appTrans?.text(langName) ?? langName,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.w500,
                                      color: isSelected
                                          ? Colors.black
                                          : Colors.grey.shade700,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),

                // --- Confirm Button ---
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  child: CustomButton(
                    onTap: () async {
                      await context.read<AuthCubit>().changeLocale(
                        selectedCode,
                      );

                      if (context.mounted) Navigator.pop(context);
                    },
                    text: appTrans?.text('confirm') ?? 'تأكيد',
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          );
        },
      );
    },
  );
}
