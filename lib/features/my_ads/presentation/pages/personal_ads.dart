import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oreed_clean/core/app_shared_prefs.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/features/my_ads/presentation/cubit/my_ads_cubit.dart';
import 'package:oreed_clean/features/my_ads/presentation/widgets/personal_ads_shimmer.dart';
import 'package:oreed_clean/features/my_ads/presentation/widgets/pesonal_ads_section.dart';

class PersonalAds extends StatefulWidget {
  const PersonalAds({super.key});

  @override
  State<PersonalAds> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<PersonalAds> {
  void getId() async {
    AppSharedPreferences().userId;
  }

  Future<void> _refresh() async {
    await context.read<PersonAdsCubit>().fetchUserAds(
      AppSharedPreferences().userId!,
    );
  }

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // set your desired color
        statusBarIconBrightness:
            Brightness.dark, // light icons (for dark background)
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppTranslations.of(context)!;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(),
        child: RefreshIndicator.adaptive(
          onRefresh: _refresh,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 6, top: 10),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xffe8e8e9),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        padding: const EdgeInsets.all(6),
                        child: Icon(Icons.arrow_back, color: AppColors.primary),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    t.text('my_ads'),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  FutureBuilder(
                    future: AppSharedPreferences().initSharedPreferencesProp(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const UserAdsSectionShimmer();
                      }

                      final prefs = AppSharedPreferences();
                      if (prefs.userToken == null) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              t.text('please_login'),
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      } else {
                        return UserAdsSection(userId: prefs.userId!);
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
