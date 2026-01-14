// ignore_for_file: use_build_context_synchronously, curly_braces_in_flow_control_structures

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Added
import 'package:fluttertoast/fluttertoast.dart';
import 'package:oreed_clean/core/app_shared_prefs.dart';
import 'package:oreed_clean/core/routing/routes.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/core/utils/shared_widgets/custom_button.dart';
import 'package:oreed_clean/features/login/presentation/cubit/login_cubit.dart';
import 'package:oreed_clean/features/login/presentation/cubit/login_state.dart';
import 'package:oreed_clean/features/login/presentation/widgets/authbackground.dart';
import 'package:oreed_clean/features/login/presentation/widgets/custom_apptextfield.dart';
import 'package:oreed_clean/features/login/presentation/widgets/custom_phonefield.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = "/home_add_ads";
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _phoneCtrl = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();

  String dialCode = '+965';
  String? errorMessage;
  late AppTranslations appTrans;

  @override
  void dispose() {
    _passController.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  void _onForgetPassPressed() {
    Navigator.of(context).pushNamed(Routes.resetpass);
  }

  /// Trigger the login process
  Future<void> _onLoginPressed() async {
    FocusScope.of(context).unfocus();

    final rawInput = _phoneCtrl.text;
    final onlyDigits = rawInput.replaceAll(RegExp(r'\D'), '');

    if (onlyDigits.isEmpty) {
      setState(() => errorMessage = appTrans.text('enterPhoneNote'));
      return;
    }
    if (_passController.text.trim().isEmpty) {
      setState(() => errorMessage = appTrans.text('enterPass'));
      return;
    }

    String? token = await FirebaseMessaging.instance.getToken();
    token ??= "dummy_token_for_simulator";

    // Call the Cubit
    context.read<AuthCubit>().login(
      phone: onlyDigits,
      password: _passController.text.trim(),
      fcmToken: token,
    );
  }

  /// Handle navigation and persistence after Cubit emits Success
  Future<void> _handlePostLogin(AuthState state) async {
    final user = state.user!;
    final onlyDigits = _phoneCtrl.text.replaceAll(RegExp(r'\D'), '');
    final prefs = AppSharedPreferences();

    await prefs.saveuserPhone(onlyDigits);

    // Flow A: Company account with valid company ID
    if (user.companyId != 'null' && user.accountType != 'personal') {
      await prefs.saveCompanyId(int.parse(user.companyId!));
      await prefs.saveUserName(user.name);
      await prefs.saveUserType(user.accountType);
      await prefs.saveUserToken(user.token!);
      await prefs.saveUserId(user.id);
      // await NotificationService().subscribeToUserTypeTopic(user.accountType);

      if (mounted) Navigator.pushReplacementNamed(context, Routes.homelayout);
    }
    // Flow B: Company account without company ID
    else if (user.companyId == 'null' && user.accountType != 'personal') {
      await prefs.saveUserToken(user.token!);
      await prefs.saveUserId(user.id);

      if (mounted) {
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (context) => const CompanyFormUI()),
        // );
      }
    }
    // Flow C: Personal account
    else {
      await prefs.saveUserId(user.id);
      await prefs.saveUserName(user.name);
      await prefs.saveUserType(user.accountType);
      await prefs.saveUserToken(user.token!);
      // await NotificationService().subscribeToUserTypeTopic(user.accountType);

      if (mounted) Navigator.pushReplacementNamed(context, Routes.homelayout);
    }
  }

  @override
  Widget build(BuildContext context) {
    appTrans = AppTranslations.of(context)!;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.success) {
          _handlePostLogin(state);
        } else if (state.status == AuthStatus.error) {
          setState(() => errorMessage = state.errorMessage);
          Fluttertoast.showToast(
            msg: state.errorMessage ?? appTrans.text('loginFailed'),
          );
        }
      },
      child: AuthBack(
        title: appTrans.text('login'),
        subtitle: appTrans.text('login_subtitle'),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            border: Border(
              top: BorderSide(color: AppColors.secondary, width: 2),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  PhoneField(
                    controller: _phoneCtrl,
                    onChanged: (raw) {
                      if (errorMessage != null)
                        setState(() => errorMessage = null);
                    },
                    validator: (val) => val == null || val.isEmpty
                        ? (appTrans.text("register_phone_error"))
                        : null,
                    labletext: appTrans.text('phone_label'),
                    lablehint: appTrans.text('loginPhoneHint'),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 45,
                    child: PasswordField(
                      controller: _passController,
                      isHidden: null,
                    ),
                  ),
                  if (errorMessage != null && errorMessage!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(errorMessage!),
                    ),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: TextButton(
                      onPressed: () {
                        _onForgetPassPressed();
                      },
                      child: Text(
                        appTrans.text('forgetPass'),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Use BlocBuilder or context.watch to detect loading status
                  Builder(
                    builder: (context) {
                      final status = context.watch<AuthCubit>().state.status;
                      final isLoading = status == AuthStatus.loading;

                      return SizedBox(
                        height: 50,
                        child: CustomButton(
                          onTap: () => isLoading ? null : _onLoginPressed,
                          text: isLoading
                              ? "..." // Or a loading spinner if CustomButton supports it
                              : appTrans.text('login_button'),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
