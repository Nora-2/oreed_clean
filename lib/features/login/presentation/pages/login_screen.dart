import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oreed_clean/core/utils/appimage/app_images.dart';
import 'package:oreed_clean/core/utils/appstring/app_string.dart';
import 'package:oreed_clean/features/login/presentation/cubit/login_cubit.dart';
import 'package:oreed_clean/features/login/presentation/widgets/auth_card_container.dart';
import 'package:oreed_clean/features/login/presentation/widgets/auth_toggel_selector.dart';
import 'package:oreed_clean/features/login/presentation/widgets/authheader.dart';
import 'package:oreed_clean/features/login/presentation/widgets/custom_apptextfield.dart';
import 'package:oreed_clean/features/login/presentation/widgets/custom_button_login.dart';
import 'package:oreed_clean/features/login/presentation/widgets/custom_phonefield.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoginSelected = true;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
     final size = MediaQuery.of(context).size;
    final isMobile = size.width <= 600;
    return Scaffold(
    body: Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(Appimage.loginBack), fit: BoxFit.fill),
      ),
      child: SafeArea(
        child: Column(
          children: [
            
            AuthHeader(
              title: AppTranslations.of(context)!.text(AppString.loginTitle),
              subtitle: AppTranslations.of(context)!.text(AppString.loginSubtitle),
              isMobile: isMobile,
            ),
            
         // Pushes content to bottom
           
            Expanded(
              child: AuthCardContainer(
                horizontalPadding: isMobile ? 20 : size.width * 0.2,
                child: Column(
                  children: [
                    // 3. Reusable Toggle
                    AuthToggleSelector(
                      leftLabel: AppTranslations.of(context)!.text(AppString.register),
                      rightLabel: AppTranslations.of(context)!.text(AppString.loginTitle),
                      isLeftSelected: _isLoginSelected,
                      isMobile: isMobile,
                      onToggle: (val) => setState(() => _isLoginSelected = val),
                    ),
                    const SizedBox(height: 20),
                    
                    // 4. Form Fields
                    _buildForm(isMobile),
                    
                     SizedBox(height: size.height*.4),
                 
                    CustomloginButton(
                      phoneController: _phoneController,
                      passwordController: _passwordController,
                      state: context.watch<AuthCubit>().state,
                      isMobile: isMobile,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
        );
  }
  
  Widget _buildForm(bool isMobile) {
    return Column(
      children: [
        PhoneField(
          validator: (p) {},
          labletext: AppTranslations.of(context)!.text('phone_number'),
          lablehint: AppTranslations.of(context)!.text('phone_hint'),
          controller: _phoneController,
        ),
        SizedBox(height: isMobile ? 15 : 20),
        PasswordField(
          controller: _passwordController,
          isHidden: !_isPasswordVisible,
          onChanged: (value) {
            setState(() {
              _isPasswordVisible = value.isNotEmpty;
            });
          },
        ),
      ],
    );
  }
}
