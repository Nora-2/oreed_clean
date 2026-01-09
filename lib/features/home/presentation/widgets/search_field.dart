import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/core/utils/appicons/app_icons.dart';
import 'package:oreed_clean/core/utils/appstring/app_string.dart';
import 'package:oreed_clean/features/AdvancedSearch/presentation/cubit/advancedsearch_cubit.dart';
import 'package:oreed_clean/features/AdvancedSearch/presentation/pages/advanced_search.dart';

class HomeSearchField extends StatelessWidget {
  const HomeSearchField({super.key});

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;

    return TextField(
      textAlign: TextAlign.right,
      onSubmitted:  (searchText) {
        if (searchText.trim().isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>BlocProvider<AdvancedSearchCubit>(
            create: (_) => AdvancedSearchCubit(),
            child:   AdvancedSearchScreen(
                initialSearchQuery: searchText,
              ),
          ),
              
            ),
          );
        }
      },
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        hintText: AppTranslations.of(context)!.text(AppString.searchHint),
        hintStyle: TextStyle(fontSize: isTablet ? 16 : 14),
        prefixIcon: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isTablet ? 12 : 16,
            vertical: isTablet ? 12 : 16,
          ),
          child: SvgPicture.asset(
            AppIcons.search,
            width: isTablet ? 24 : 15,
            height: isTablet ? 24 : 15,
          ),
        ),
        
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1.2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(color: Colors.red, width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: isTablet ? 16 : 12,
        ),
      ),
    );
  }
}
