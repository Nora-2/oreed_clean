import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:oreed_clean/core/routing/routes.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/core/utils/appicons/app_icons.dart';
import 'package:oreed_clean/core/utils/appstring/app_string.dart';
import 'package:oreed_clean/features/login/presentation/cubit/login_cubit.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';

class CustomloginButton extends StatelessWidget {
  const CustomloginButton({
    super.key,
    required TextEditingController phoneController,
    required TextEditingController passwordController,
    required this.state,
    required this.isMobile,
  }) : _phoneController = phoneController,
       _passwordController = passwordController;

  final TextEditingController _phoneController;
  final TextEditingController _passwordController;
  final AuthState state;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: GestureDetector(
        onTap: state is AuthLoading
            ? null
            : () {
                // Trigger login; navigation should be handled by a BlocListener
                // context.read<AuthCubit>().login(
                //    "956${_phoneController.text}",
                //       _passwordController.text,
                //     );
                Navigator.pushNamed(context, Routes.homelayout);
              },
        child: Container(
          width: double.infinity,
          height: 55,
          decoration: BoxDecoration(
            color: const Color(0xff1146D1),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 40),
                Expanded(
                  child: Text(
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
