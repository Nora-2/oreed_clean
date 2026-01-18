import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/core/utils/appicons/app_icons.dart';
import 'package:oreed_clean/core/utils/appimage/app_images.dart';
import 'package:oreed_clean/features/settings/data/models/appsetting_model.dart';
import 'package:oreed_clean/features/settings/presentation/widgets/phone_action_row.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AllPhonesCard extends StatelessWidget {
  final AppSettingsModel? settingsModel;
  final AppTranslations appTrans;

  const AllPhonesCard({
    super.key,
    required this.settingsModel,
    required this.appTrans,
  });

  @override
  Widget build(BuildContext context) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    final phones = <String>[
      settingsModel!.phone,
      settingsModel!.phone1!,
      settingsModel!.phone2!,
      settingsModel!.phone3!,
      settingsModel!.phone4!,
    ].whereType<String>().where((e) => e.isNotEmpty).toList();

    if (phones.isEmpty) return const SizedBox.shrink();

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.only(left: 8, top: 5, right: 8, bottom: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: const DecorationImage(
              image: AssetImage(Appimage.frame),
              opacity: .8,
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _supportText(context),
              const SizedBox(height: 6),
              _addressRow(context),
              const SizedBox(height: 5),
              _emailRow(context),
              const SizedBox(height: 8),
              _phonesContainer(context, phones, isRTL),
            ],
          ),
        ),
      ],
    );
  }

  // ================= UI PARTS =================

  Widget _supportText(BuildContext context) {
    return Text(
      appTrans.text('contact_us_support_message'),
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
        color: AppColors.whiteColor,
        fontWeight: FontWeight.w400,
        fontSize: 17,
      ),
    );
  }

  Widget _addressRow(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(AppIcons.locationCountry, color: AppColors.whiteColor),
        const SizedBox(width: 3),
        Text(
          settingsModel?.address ?? '—',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.whiteColor,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _emailRow(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(AppIcons.mail, color: AppColors.whiteColor),
        const SizedBox(width: 5),
        InkWell(
          onTap: settingsModel?.email.isNotEmpty == true
              ? () => _launchEmail(email: settingsModel!.email)
              : null,
          child: Text(
            settingsModel?.email ?? '—',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.whiteColor,
              fontWeight: FontWeight.w500,
              fontSize: 14,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.whiteColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _phonesContainer(
    BuildContext context,
    List<String> phones,
    bool isRTL,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Column(
          children: [
            _whatsAppHeader(context, isRTL),
            const SizedBox(height: 5),
            ...phones.asMap().entries.map((entry) {
              final idx = entry.key;
              final phone = entry.value;
              return Column(
                children: [
                  PhoneActionRow(
                    phone: phone,
                    onCall: () => _openProfileURL("tel:$phone"),
                    onWhatsApp: () => _launchWhatsApp(phone: phone),
                  ),
                  if (idx != phones.length - 1)
                    Divider(
                      color: Colors.grey.shade100,
                      thickness: 1,
                      height: 12,
                    ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _whatsAppHeader(BuildContext context, bool isRTL) {
    return Row(
      textDirection: isRTL ? TextDirection.ltr : TextDirection.rtl,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          appTrans.text("whatsapp"),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: 3,
          height: 22,
          decoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }

  Future<void> _launchWhatsApp({required String phone}) async {
    final parsed = phone.startsWith('+') ? phone.substring(1) : phone;
    final uri = Uri.parse(
      'https://api.whatsapp.com/send/?phone=$parsed&text&type=phone_number&app_absent=0',
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _launchEmail({required String email}) async {
    final uri = Uri.parse('mailto:$email');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _openProfileURL(String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url, mode: LaunchMode.externalApplication);
    }
  }
}
