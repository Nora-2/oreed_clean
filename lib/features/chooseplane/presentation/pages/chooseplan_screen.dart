import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Changed from provider
import 'package:oreed_clean/core/routing/routes.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/shared_widgets/custom_button.dart';
import 'package:oreed_clean/features/chooseplane/domain/entities/package_entity.dart';
import 'package:oreed_clean/features/chooseplane/presentation/cubit/chooseplane_cubit.dart';
import 'package:oreed_clean/features/chooseplane/presentation/cubit/chooseplane_state.dart';
import 'package:oreed_clean/features/chooseplane/presentation/widgets/plan_card_item.dart';
import 'package:oreed_clean/features/login/presentation/widgets/authbackground.dart';

class ChoosePlanScreen extends StatefulWidget {
  final String type;
  final String title;
  final IconData icon;
  final String introText;
  final Color accentColor;

  const ChoosePlanScreen({
    super.key,
    required this.type,
    required this.title,
    required this.icon,
    required this.introText,
    required this.accentColor,
  });

  static Future<PackageEntity?> show({
    required BuildContext context,
    required String type,
    required String title,
    required IconData icon,
    required String introText,
    required Color accentColor,
    required Function() onTap,
  }) {
    return Navigator.pushNamed<PackageEntity?>(
      context,
      Routes.choosePlanScreen,
      arguments: {
        'type': type,
        'title': title,
        'icon': icon,
        'introText': introText,
        'accentColor': accentColor,
      },
    );
  }

  @override
  State<ChoosePlanScreen> createState() => _ChoosePlanScreenState();
}

class _ChoosePlanScreenState extends State<ChoosePlanScreen> {
  // To track the selected plan locally in the UI
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    // Fetch packages on init using the Cubit
    context.read<PackagesCubit>().fetchPackages(widget.type);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppTranslations.of(context);

    return AuthBack(
      title: t?.text('choose_your_plan_title') ?? "اختر باقتك",
      subtitle: widget.introText,
      child: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: BlocBuilder<PackagesCubit, PackagesState>(
                builder: (context, state) {
                  // Handle Loading
                  if (state.status == PackagesStatus.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // Handle Error
                  if (state.status == PackagesStatus.error) {
                    return Center(
                      child: Text(
                        '${t?.text('ad_details.error_occurred') ?? 'حدث خطأ: '} ${state.error}',
                      ),
                    );
                  }

                  // Handle Success
                  if (state.status == PackagesStatus.success) {
                    final list = state.packages;
                    if (list.isEmpty) {
                      return Center(
                        child: Text(t?.text('no_plans_available') ?? 'لا توجد باقات حالياً'),
                      );
                    }

                    return Column(
                      children: [
                        Expanded(
                          child: ListView.separated(
                            padding: const EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 20),
                            itemCount: list.length,
                            separatorBuilder: (ctx, index) => const SizedBox(height: 16),
                            itemBuilder: (ctx, index) {
                              final p = list[index];
                              return PlanCardItem(
                                package: p,
                                index: index,
                                isSelected: _selectedIndex == index,
                                onTap: () {
                                  setState(() {
                                    _selectedIndex = index;
                                  });
                                },
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                          child: CustomButton(
                            onTap:()=> _selectedIndex == null
                                ? null 
                                : () {
                                    // Return the selected package to the previous screen
                                    Navigator.pop(context, list[_selectedIndex!]);
                                  },
                            text: t?.text('subscribe_now') ?? "اشترك الآن",
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    );
                  }

                  return const SizedBox();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
