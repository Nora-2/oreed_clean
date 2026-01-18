import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/core/utils/appimage/app_images.dart';
import 'package:oreed_clean/core/utils/shared_widgets/emptywidget.dart';
import 'package:oreed_clean/features/companyprofile/presentation/widgets/adbanner_carousel.dart';
import 'package:oreed_clean/features/my_ads/presentation/cubit/my_ads_cubit.dart';

class UserAdsSection extends StatefulWidget {
  final int userId;

  const UserAdsSection({super.key, required this.userId});

  @override
  State<UserAdsSection> createState() => _UserAdsSectionState();
}

class _UserAdsSectionState extends State<UserAdsSection> {
  @override
  void initState() {
    super.initState();
    // Use the Cubit to fetch ads
    context.read<PersonAdsCubit>().fetchUserAds(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppTranslations.of(context);

    return BlocListener<PersonAdsCubit, PersonAdsState>(
      // Only listen when there is a success/error message from a specific action (like delete)
      listenWhen: (previous, current) => current.actionMessage != null,
      listener: (context, state) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.actionMessage!),
            backgroundColor:
                state.actionMessage!.contains('Error') ||
                    state.actionMessage!.contains('Failed')
                ? Colors.red
                : Colors.green,
          ),
        );
      },
      child: BlocBuilder<PersonAdsCubit, PersonAdsState>(
        builder: (context, state) {
          // 1. Loading State
          if (state.status == PersonAdsStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. Error State
          if (state.status == PersonAdsStatus.error) {
            return Center(
              child: Text(
                state.errorMessage ??
                    t?.text('ads.load_error') ??
                    'حدث خطأ أثناء تحميل الإعلانات',
              ),
            );
          }

          // 3. Empty State
          if (state.ads.isEmpty) {
            return emptyAdsView(
              visible: true,
              context: context,
              button: t?.text('add_new_ad') ?? 'إضافة إعلان جديد',
              image: 'assets/svg/emptyads.svg',
              title: t?.text('ads.empty') ?? 'لا توجد إعلانات بعد',
              subtitle: t?.text('ads.empty_sub') ?? 'لا توجد إعلانات بعد',
              onAddPressed: () {
                // Navigate to add ad screen
              },
            );
          }

          // 4. Success State (Data list)
          return AdBannerCarousel(
            ownerType: 'personal',
            itemCount: state.ads.length,
            titleBuilder: (i) =>
                state.ads[i].title ?? t?.text('ads.no_title') ?? 'بدون عنوان',
            dateBuilder: (i) => state.ads[i].adsExpirationDate,
            viewsBuilder: (i) => state.ads[i].visit,
            sectionId: (i) => state.ads[i].sectionId,
            imageUrlBuilder: (i) => state.ads[i].mainImage,
            statusBuilder: (i) => state.ads[i].status,
            onEdit: (i) {},
            typeBuilder: (i) => state.ads[i].sectionName ?? '',
            onDelete: (i) async {
              final ad = state.ads[i];
              bool? confirmed = await showDeleteConfirmDialog(context: context);

              if (confirmed == true && context.mounted) {
                // Call delete in Cubit
                context.read<PersonAdsCubit>().deleteAd(ad.id, ad.sectionId);
              }
            },
            cardDecoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.white, Color(0xFFF5F5F5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            adTypeBuilder: (i) => state.ads[i].adType,
            sectionTypeBuilder: (i) => state.ads[i].sectionType,
            adIdBuilder: (i) => state.ads[i].id.toString(),
            companyId: 0,
          );
        },
      ),
    );
  }

  // --- Confirmation Dialog ---
  Future<bool?> showDeleteConfirmDialog({required BuildContext context}) {
    final t = AppTranslations.of(context);
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.42,
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
                    color: Colors.grey.shade500,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Image.asset(Appimage.deleteImage, height: 100),
              Text(
                t?.text('delete_ad_question') ?? 'هل تريد حذف الإعلان؟',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  t?.text('delete_ad_warning') ??
                      'سيتم حذف الإعلان بشكل نهائي ولن يكون متاحًا مرة أخرى.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context, true),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xffD80027).withOpacity(.1),
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(color: const Color(0xffD80027)),
                          ),
                          child: Text(
                            t?.text('yes_delete') ?? 'نعم، احذف',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Color(0xffD80027)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context, false),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(color: const Color(0xff676768)),
                          ),
                          child: Text(
                            t?.text('no') ?? 'لا',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Color(0xff676768)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
