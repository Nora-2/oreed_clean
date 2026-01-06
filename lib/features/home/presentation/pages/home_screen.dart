import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/core/utils/appstring/app_string.dart';
import 'package:oreed_clean/features/home/presentation/cubit/home_cubit.dart';
import 'package:oreed_clean/features/home/presentation/widgets/bottomnav.dart';
import 'package:oreed_clean/features/home/presentation/widgets/home_back.dart';
import 'package:oreed_clean/features/home/presentation/widgets/home_contant.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whicolor,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          child: Stack(
            children: [
              const HomeBackground(),
          
              SafeArea(
                child: BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state) {
                    if (state is HomeLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
          
                    if (state is HomeError) { return Center( child: Column( mainAxisAlignment: MainAxisAlignment.center, children: [ Icon( Icons.error_outline, size: 60, color: Colors.red, ), SizedBox(height: 16), Text(state.message), SizedBox(height: 16), ElevatedButton( onPressed: () => context.read<HomeCubit>().loadHomeData(), child: Text(AppTranslations.of(context)!.text(AppString.retry)), ), ], ), ); }
          
                    if (state is HomeLoaded) {
                      return HomeContent(state: state);
                    }
          
                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}
