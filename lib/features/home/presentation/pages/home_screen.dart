import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/features/home/presentation/cubit/home_cubit.dart';
import 'package:oreed_clean/features/home/presentation/widgets/error_state.dart';
import 'package:oreed_clean/features/home/presentation/widgets/home_back.dart';
import 'package:oreed_clean/features/home/presentation/widgets/home_contant.dart';
import 'package:oreed_clean/features/home/presentation/widgets/home_load_shimmer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whicolor,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            const HomeBackground(),

            SafeArea(
              child: BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  if (state is HomeLoading) {
                    return  LoadingShimmer(isTablet: false,);
                  }

                  if (state is HomeError) {
                    return Center(
                      child: ErrorState(errorMessage: state.message,onRetry:  () =>
                                context.read<HomeCubit>().loadHomeData(),)
                    );
                  }

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
     
    );
  }
}
