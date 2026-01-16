import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:oreed_clean/core/app_shared_prefs.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/core/utils/shared_widgets/custom_button.dart';
import 'package:oreed_clean/core/utils/shared_widgets/custom_form_field.dart';
import 'package:oreed_clean/core/utils/textstyle/appfonts.dart';
import 'package:oreed_clean/features/company_types_by_company/presentation/widgets/select_sheet_field_ads.dart';
import 'package:oreed_clean/features/login/presentation/widgets/custom_phonefield.dart';
import 'package:oreed_clean/features/settings/data/models/appsetting_model.dart';
import 'package:oreed_clean/features/settings/data/models/local_type.dart';
import 'package:oreed_clean/features/settings/domain/repositories/more_repo.dart';
import 'package:oreed_clean/features/settings/domain/repositories/settings_repo.dart';
import 'package:oreed_clean/features/settings/presentation/widgets/app_validator.dart';
import 'package:oreed_clean/features/settings/presentation/widgets/onselect_type.dart';
import 'package:oreed_clean/features/settings/presentation/widgets/phone_cards.dart';
import 'package:oreed_clean/features/settings/presentation/widgets/thankyou.dart';

class MsgContactUs extends StatefulWidget {
  const MsgContactUs({super.key});

  @override
  State<MsgContactUs> createState() => _MsgContactUsState();
}

class _MsgContactUsState extends State<MsgContactUs> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController msgController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey();

  late AppTranslations appTrans;
  bool? isLoading;
  String? errorMessage;

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

  AppSettingsModel? settingsModel;
  LocalType? selectedType;

  @override
  void initState() {
    super.initState();
    selectedType = types[0];
    // Prefill name/phone from shared prefs if available
    try {
      final prefs = AppSharedPreferences();
      final isAr = (prefs.languageCode ?? 'ar') == 'ar';
      final cachedName = isAr ? prefs.userNameAr : prefs.userName;
      if ((cachedName ?? '').isNotEmpty) {
        nameController.text = cachedName!;
      }
      if ((prefs.userPhone ?? '').isNotEmpty) {
        phoneController.text = prefs.userPhone!;
      }
    } catch (_) {}
    // Load app settings to render phone card at top
    _getSettings();
  }

  Future<void> _getSettings() async {
    try {
      final repo = SettingsRepository();
      final model = await repo.fetchSettings();
      if (!mounted) return;
      setState(() => settingsModel = model);
    } catch (e) {
      log('contact_us: failed to load settings -> $e');
    }
  }

  @override
  void dispose() {
    msgController.dispose();
    phoneController.dispose();
    nameController.dispose();
    super.dispose();
  }

  Future<void> _onSend() async {
    // Prevent double submit and dismiss the keyboard
    if (isLoading == true) return;
    FocusScope.of(context).unfocus();

    // Validate login token (API requires Authorization: Bearer)
    final token = AppSharedPreferences().getUserToken;
    if (token == null || token.isEmpty) {
      Fluttertoast.showToast(msg: appTrans.text('please_login_first'));
      return;
    }

    // No phone validation: use the raw text as entered by the user
    final String phoneRaw = phoneController.text.trim();

    // Validate other fields only (name/message)
    if (!_formKey.currentState!.validate()) return;

    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final String type =
          (selectedType?.id == 'contracts' || selectedType?.id == 'complaints')
          ? (selectedType!.id ?? 'contracts')
          : 'complaints';

      final Map<String, dynamic> data = {
        "name": nameController.text.trim(),
        "phone": phoneRaw,
        "message": msgController.text.trim(),
        "type": type,
      };

      final res = await MoreRepository().sendContactUsMsg(body: data);
      print(res);

      setState(() => isLoading = false);

      final bool ok = res["status"] == true;
      final String serverMsg = (res["message"]?.toString() ?? '').trim();

      if (ok) {
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => ThankYou(
              screenTitle: appTrans.text("contact_us"),
              title1: serverMsg.isNotEmpty
                  ? serverMsg
                  : appTrans.text('msgHasSent'),
            ),
          ),
        );
      } else {
        // show server validation message if any
        final fallback = serverMsg.isNotEmpty
            ? serverMsg
            : appTrans.text('somethingWrong');
        Fluttertoast.showToast(msg: fallback);
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    appTrans = AppTranslations.of(context)!;
    return Container(
      // خلفية متدرّجة لطيفة تحت محتوى الـ Scaffold
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.whicolor, AppColors.whicolor],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,

        // شريط سفلي دقيق يعطي لمسة حديثة
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          leadingWidth: 40,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              decoration: BoxDecoration(
                // color: const Color(0xffe8e8e9),
                borderRadius: BorderRadius.circular(25),
              ),
              padding: const EdgeInsets.all(6),
              child: Icon(Icons.arrow_back, color: AppColors.primary),
            ),
          ),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(8, 2, 8, 24),
            children: [
              Text(
                appTrans.text("contact_us"),
                style: AppFonts.heading2.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 5),
              settingsModel != null
                  ? AllPhonesCard(
                      settingsModel: settingsModel,
                      appTrans: appTrans,
                    )
                  : const SizedBox.shrink(),

              const SizedBox(height: 35),
              Column(
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: AppColors.secondary,
                        ),
                        height: 20,
                        width: 3,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        appTrans.text('send_request_message'),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.secondary),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Column(
                      children: [
                        AppTextField(
                          controller: nameController,
                          label: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: appTrans.text('userName'),
                                  style: AppFonts.body.copyWith(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const TextSpan(
                                  text: ' *',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                          hint: appTrans.text('userName'),
                          validator: (v) =>
                              AppValidator.nameValidate(v, context),
                        ),
                        const SizedBox(height: 12),
                        SelectSheetFieldads(
                          label: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: appTrans.text('msgType'),
                                  style: AppFonts.body.copyWith(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const TextSpan(
                                  text: ' *',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                          hint: appTrans.text(
                            selectedType?.id ?? 'new_contracts',
                          ),
                          onTap: () {
                            onSelectType(context: context);
                          },
                        ),
                        const SizedBox(height: 12),
                        AppTextField(
                          controller: msgController,
                          hint: appTrans.text("addUMsgHere"),
                          max: 10,
                          min: 5,
                          label: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: appTrans.text('your_message'),
                                  style: AppFonts.body.copyWith(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const TextSpan(
                                  text: ' *',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                          validator: (v) => AppValidator.txtValidate(
                            value: v,
                            context: context,
                            title: appTrans.text("addUMsgHere"),
                          ),
                        ),
                        const SizedBox(height: 12),
                        PhoneField(
                          controller: phoneController,
                          lablehint: 'XXX XXXX +965',
                          labletext: appTrans.text('phone_number'),
                          validator: (String? p1) {
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),
                        // زر إرسال أنيميتد
                        CustomButton(
                          onTap: _onSend,
                          text: appTrans.text('send'),
                        ),
                      ],
                    ),
                  ),
                  if (errorMessage != null && errorMessage!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(errorMessage!),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
