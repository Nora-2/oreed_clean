import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appicons/app_icons.dart';
import 'package:oreed_clean/features/addetails/data/models/favourie_ad_model.dart';
import 'package:oreed_clean/features/addetails/domain/entities/ad_detiles_entity.dart';
import 'package:oreed_clean/features/addetails/presentation/cubit/addetails_cubit.dart';
import 'package:oreed_clean/features/addetails/presentation/cubit/saved_ads_cubit.dart';
import 'package:oreed_clean/features/addetails/presentation/widgets/ad_detailes_shimmer.dart';
import 'package:oreed_clean/features/addetails/presentation/widgets/build_detailes_row.dart';
import 'package:oreed_clean/features/addetails/presentation/widgets/build_inspection_cert.dart';
import 'package:oreed_clean/features/addetails/presentation/widgets/desicription_card.dart';
import 'package:oreed_clean/features/addetails/presentation/widgets/image_header.dart';
import 'package:oreed_clean/features/addetails/presentation/widgets/inspection_certification.dart';
import 'package:oreed_clean/features/addetails/presentation/widgets/socila_linkes.dart';
import 'package:oreed_clean/features/addetails/presentation/widgets/title_price_card.dart';
import 'package:oreed_clean/features/addetails/presentation/widgets/top_action_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsAdsScreen extends StatefulWidget {
  final int adId;
  final int sectionId;
  final dynamic workerId;

  const DetailsAdsScreen({
    super.key,
    required this.adId,
    required this.sectionId,
    this.workerId,
  });

  @override
  State<DetailsAdsScreen> createState() => _DetailsAdsScreenState();
}

class _DetailsAdsScreenState extends State<DetailsAdsScreen> {
  int _activeIndex = 0;

  @override
  void initState() {
    super.initState();
    // Use Cubit to fetch data
    Future.microtask(() {
      context.read<AddetailsCubit>().fetchAd(widget.adId, widget.sectionId);
    });
  }

  String _formatDateOnly(dynamic dateValue) {
    if (dateValue == null) return '';
    try {
      DateTime dateTime;
      if (dateValue is String) {
        dateTime = DateTime.parse(dateValue);
      } else if (dateValue is DateTime) {
        dateTime = dateValue;
      } else {
        return '';
      }
      return DateFormat('yyyy-MM-dd').format(dateTime);
    } catch (e) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppTranslations.of(context);

    // Using BlocBuilder to handle different states
    return BlocBuilder<AddetailsCubit, AddetailsState>(
      builder: (context, state) {
        if (state is AddetailsLoading || state is AddetailsInitial) {
          return const AdDetailsShimmerLoading();
        }

        if (state is AddetailsError) {
          return Scaffold(
            body: Center(
              child: Text(
                '${t?.text('ad_details.error_occurred') ?? 'حدث خطأ: '} ${state.message}',
              ),
            ),
          );
        }

        if (state is AddetailsLoaded) {
          final ad = state.ad;

          // Normalize images
          final List<String> images = [];
          if (ad.mainImage.isNotEmpty) images.add(ad.mainImage);
          if (ad.media.isNotEmpty) {
            images.addAll(ad.media.where((e) => e.isNotEmpty));
          }

          final detailsRows = buildDetailsRows(ad.sectionId, ad.extra, context);
          final carDoc = ad.extra['car_document'];
          final isInspected = ad.extra['is_inspected'] == true;
          final createdAt = ad.extra['created_at'];

          return Scaffold(
            extendBodyBehindAppBar: true,
            backgroundColor: Colors.white,
            bottomNavigationBar: _bottomBar(ad),
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  expandedHeight: 250,
                  backgroundColor: Colors.white,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      children: [
                        ImageHeader(
                          images: images.isNotEmpty ? images : const [],
                          activeIndex: _activeIndex,
                          onChanged: (i) => setState(() => _activeIndex = i),
                          heroTagPrefix:
                              'details-hero-${widget.workerId ?? ad.id}',
                          bottomRadius: 35,
                        ),
                        Positioned(
                          top: 40,
                          left: 15,
                          right: 5,
                          child: TopActionsBar(
                            pin: ad.adType,
                            adId: ad.id,
                            sectionId: widget.sectionId,
                            adTitle: ad.title,
                            adImage: ad.mainImage,
                            onBack: () => Navigator.of(context).pop(),
                            onSave: () {
                              final fav = FavoriteAd(
                                id: ad.id.toString(),
                                title: ad.title,
                                imageUrl: ad.mainImage,
                                createdAt: DateTime.now(),
                              );
                              context.read<SavedAdsCubit>().toggle(fav);
                              final savedNow = context
                                  .read<SavedAdsCubit>()
                                  .isSaved(ad.id.toString());
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    savedNow
                                        ? (t?.text('message.ad_saved') ??
                                              'تمت إضافة الإعلان للمفضلة')
                                        : (t?.text('message.ad_removed') ??
                                              'تمت إزالته من المفضلة'),
                                  ),
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: TitlePriceCard(
                          dateText: _formatDateOnly(createdAt),
                          title: ad.title,
                          type: ad.extra['speciality'],
                          priceText: ad.price.isNotEmpty
                              ? '${ad.price} ${t?.text('currency_kwd') ?? 'د.ك'}'
                              : (t?.text('ad_details.price_on_contact') ??
                                    'السعر عند التواصل'),
                          viewsText: ad.visit.toString(),
                          cityText: ad.cityName,
                          stateText: ad.stateName,
                          sectionId: ad.sectionId,
                        ),
                      ),
                      if (detailsRows.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: DetailsTableSimple(
                            sectionTitle: sectionTitle(ad.sectionId, context),
                            rows: detailsRows,
                            zebra: true,
                          ),
                        ),

                      // Inspection Certificate Logic
                      if (widget.sectionId == 1 &&
                          carDoc is String &&
                          carDoc.isNotEmpty)
                        BuildInspectioncert(
                          context: context,
                          ad: ad,
                          carDoc: carDoc,
                          t: t,
                        ),

                      if (isInspected)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: InspectionCertificateBadge(images: images),
                        ),

                      DescriptionCard(
                        description: ad.description.isNotEmpty
                            ? ad.description
                            : (t?.text('ad_details.no_description') ??
                                  'لا يوجد وصف متاح'),
                        adId: ad.id.toString(),
                      ),

                      if (widget.sectionId == 3)
                        SocilaLinkes(context: context, ad: ad),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  // Extracted UI helper for clean code

  Widget _bottomBar(AdDetailesEntity ad) {
    final t = AppTranslations.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        border: Border(top: BorderSide(color: Color(0x11000000))),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => _callNumber(ad.phone),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 18,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: const Color(0xFF1649D3),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(AppIcons.phone, color: Colors.white),
                      const SizedBox(width: 5),
                      Text(
                        t?.text('ad_details.call') ?? 'اتصال',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: () => _sendWhatsApp(ad),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 18,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: const Color(0xff3AA517),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(AppIcons.whatsapp),
                      const SizedBox(width: 5),
                      Text(
                        t?.text('ad_details.whatsapp') ?? 'واتساب',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 📞 Open phone dialer
  Future<void> _callNumber(String phone) async {
    final Uri telUri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(telUri)) {
      await launchUrl(telUri);
    }
  }

  /// 💬 Send WhatsApp message with ad details
  Future<void> _sendWhatsApp(AdDetailesEntity ad) async {
    final t = AppTranslations.of(context);
    final formattedPrice = ad.price.isNotEmpty
        ? '${NumberFormat.decimalPattern('ar').format(double.tryParse(ad.price) ?? 0)} ${t?.text('currency_kwd') ?? 'د.ك'}'
        : (t?.text('ad_details.price_on_contact') ?? 'السعر عند التواصل');

    // Short description
    final shortDesc = ad.description.length > 100
        ? '${ad.description.substring(0, 100)}...'
        : ad.description;

    // Optional: Build a link to the ad (if you have a domain)
    final adLink = 'https://oreed.app/ad/${ad.id}'; // change to your actual URL

    final message =
        '''
${t?.text('ad_details.whatsapp_greeting') ?? 'السلام عليكم 👋'}

${t?.text('ad_details.whatsapp_interested') ?? 'أنا مهتم بالإعلان التالي على تطبيق *Oreed* 📱'}

📌 *${ad.title}*
${t?.text('ad_details.whatsapp_price') ?? '💰 السعر:'} $formattedPrice
${t?.text('ad_details.whatsapp_location') ?? '📍 الموقع:'} ${ad.stateName} - ${ad.cityName}
${t?.text('ad_details.whatsapp_desc') ?? '📝 الوصف:'} $shortDesc

${t?.text('ad_details.whatsapp_link') ?? '🔗 رابط الإعلان:'}
$adLink

${t?.text('ad_details.whatsapp_more_details') ?? 'من فضلك أرسل لي مزيدًا من التفاصيل 🙏'}
''';

    final encodedMessage = Uri.encodeComponent(message);
    final whatsappUrl = Uri.parse(
      'https://wa.me/${_normalizePhone(ad.phone)}?text=$encodedMessage',
    );

    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('❌ Could not launch WhatsApp');
    }
  }

  /// 🧹 Normalize phone number (removes symbols, converts leading 0 to country code)
  String _normalizePhone(String phone) {
    var cleaned = phone.replaceAll(RegExp(r'[^0-9+]'), '');
    if (cleaned.startsWith('0')) {
      cleaned = '+20${cleaned.substring(1)}'; // 🇪🇬 Egypt default example
    }
    return cleaned;
  }
}
