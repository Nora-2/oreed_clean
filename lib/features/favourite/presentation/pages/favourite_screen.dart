import 'package:flutter/material.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/features/favourite/presentation/widgets/favourie_section.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppTranslations.of(context);

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              // Grey Handle

              // Title
              GestureDetector(
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
              const SizedBox(height: 10),
              Text(
                t?.text('favorites') ?? 'المفضلة',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),

              const Expanded(child: FavoritesSection()),
            ],
          ), // 👈 نفس الودجت اللي كانت في ProfileScreen
        ),
      ),
    );
  }
}
