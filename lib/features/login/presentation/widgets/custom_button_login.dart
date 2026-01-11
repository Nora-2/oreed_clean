import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/core/utils/appicons/app_icons.dart';
import 'package:oreed_clean/core/utils/appstring/app_string.dart';
import 'package:oreed_clean/features/login/presentation/cubit/login_cubit.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/features/login/presentation/cubit/login_state.dart';
class CustomloginButton extends StatelessWidget {
  const CustomloginButton({
    super.key,
    required this.phoneController,
    required this.passwordController,
    required this.isMobile,
  });

  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    // Watch the state to react to loading
    final state = context.watch<AuthCubit>().state;
    final isLoading = state.status == AuthStatus.loading;

    return SizedBox(
      width: double.infinity,
      child: GestureDetector(
        onTap: isLoading
            ? null // Disable tap while loading
            : () {
                // Trigger logic from Cubit
                context.read<AuthCubit>().login(
                      phone: phoneController.text,
                      password: passwordController.text,
                      fcmToken: "device_token_here", // Pass your FCM token logic
                    );
              },
        child: Container(
          width: double.infinity,
          height: 55,
          decoration: BoxDecoration(
            color: isLoading ? Colors.grey : const Color(0xff1146D1),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 40),
                Expanded(
                  child: isLoading
                      ? const Center(
                          child: SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          ),
                        )
                      : Text(
                          AppTranslations.of(context)!.text(AppString.loginButton),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.whicolor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColors.whicolor,
                    child: SvgPicture.asset(
                      AppIcons.arrowLeft,
                      width: 20,
                      height: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}