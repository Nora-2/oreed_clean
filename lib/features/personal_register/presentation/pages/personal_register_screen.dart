import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:oreed_clean/core/app_shared_prefs.dart';
import 'package:oreed_clean/core/routing/routes.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/core/utils/appimage/app_images.dart';
import 'package:oreed_clean/core/utils/shared_widgets/custom_button.dart';
import 'package:oreed_clean/core/utils/shared_widgets/custom_form_field.dart';
import 'package:oreed_clean/features/login/presentation/widgets/custom_apptextfield.dart';
import 'package:oreed_clean/features/login/presentation/widgets/custom_phonefield.dart';
import 'package:oreed_clean/features/personal_register/presentation/cubit/personal_register_cubit.dart';
import 'package:oreed_clean/features/login/presentation/cubit/login_cubit.dart';

import '../../../login/presentation/cubit/login_state.dart';

class PersonalRegistrationScreen extends StatefulWidget {
  const PersonalRegistrationScreen({super.key});

  @override
  State<PersonalRegistrationScreen> createState() =>
      _PersonalRegistrationScreenState();
}

class _PersonalRegistrationScreenState
    extends State<PersonalRegistrationScreen> {
  // Forms
  final _personalFormKey = GlobalKey<FormState>();
  final _loginFormKey = GlobalKey<FormState>();

  // Controllers
  final firstNameController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final loginPhoneController = TextEditingController();
  final loginPasswordController = TextEditingController();

  String? fullPhoneNumber;
  late PageController _pageController;
  int _currentPage = 0;

  bool isPasswordHidden = true;
  bool isLoginPasswordHidden = true;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    firstNameController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    loginPhoneController.dispose();
    loginPasswordController.dispose();
    super.dispose();
  }

  void _switchToPage(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onRegisterPressed() {
    if (!_personalFormKey.currentState!.validate()) return;

    final phoneToUse = (fullPhoneNumber?.trim().isNotEmpty ?? false)
        ? fullPhoneNumber!.trim()
        : phoneController.text.trim();

    context.read<PersonalRegisterCubit>().register(
      name: firstNameController.text.trim(),
      phone: phoneToUse,
      password: passwordController.text.trim(),
      fcmToken: "dummy-fcm-token",
    );
  }

  void _onLoginPressed() {
    if (!_loginFormKey.currentState!.validate()) return;

    final rawInput = loginPhoneController.text;
    final onlyDigits = rawInput.replaceAll(RegExp(r'\D'), '');

    context.read<AuthCubit>().login(
      phone: onlyDigits,
      password: loginPasswordController.text.trim(),
      fcmToken: 'knkdnlqlwndl',
    );
  }

  // Logic to save user data upon successful login
  Future<void> _handleLoginPersistence(dynamic user) async {
    final prefs = AppSharedPreferences();
    await prefs.saveuserPhone(user.phone ?? "");
    await prefs.saveUserId(user.id);
    await prefs.saveUserName(user.name);
    await prefs.saveUserType(user.accountType);
    await prefs.saveUserToken(user.token ?? "");

    // Navigate to home
    if (mounted) {
      Navigator.pushReplacementNamed(context, Routes.homelayout);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appTrans = AppTranslations.of(context)!;
    final size = MediaQuery.of(context).size;

    return MultiBlocListener(
      listeners: [
        // Registration Listener
        BlocListener<PersonalRegisterCubit, PersonalRegisterState>(
          listener: (context, state) {
            if (state.status == PersonalRegisterStatus.success) {
              Fluttertoast.showToast(
                msg: state.response?.msg ?? appTrans.text('register_success'),
              );
              // Navigate to OTP or success screen here
            } else if (state.status == PersonalRegisterStatus.error) {
              Fluttertoast.showToast(
                msg: state.errorMessage ?? appTrans.text('register_failed'),
              );
            }
          },
        ),
        // Login Listener
        BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state.status == AuthStatus.success) {
              _handleLoginPersistence(state.user);
            } else if (state.status == AuthStatus.error) {
              Fluttertoast.showToast(msg: state.errorMessage.toString());
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.primary,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Icon(Icons.arrow_back, color: AppColors.primary),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Stack(
          children: [
            Container(
              height: size.height,
              width: size.width,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(Appimage.loginBack),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  SizedBox(height: size.height * 0.01),
                  Center(
                    child: Text(
                      _currentPage == 0
                          ? appTrans.text("register_create_account")
                          : appTrans.text("login"),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: Column(
                        children: [
                          _buildToggleButtons(appTrans),
                          Expanded(
                            child: PageView(
                              controller: _pageController,
                              onPageChanged: (page) =>
                                  setState(() => _currentPage = page),
                              children: [
                                _buildPersonalForm(appTrans, size.height * .45),
                                _buildLoginForm(appTrans, size.height * .45),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleButtons(AppTranslations appTrans) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: AppColors.secondary),
        ),
        child: Row(
          children: [
            _toggleItem(appTrans.text('newAccount'), 0),
            _toggleItem(appTrans.text('login'), 1),
          ],
        ),
      ),
    );
  }

  Widget _toggleItem(String title, int index) {
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() => _currentPage = index);
          _switchToPage(index);
        },
        child: Container(
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: _currentPage == index
                ? const Color.fromRGBO(21, 77, 187, 1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(40),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              color: _currentPage == index ? Colors.white : AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPersonalForm(AppTranslations appTrans, double d) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _personalFormKey,
        child: Column(
          children: [
            AppTextField(
              controller: firstNameController,
              label: appTrans.text("register_name"),
              hint: appTrans.text("register_name_hint"),
              validator: (val) => val == null || val.isEmpty
                  ? appTrans.text("register_name_error")
                  : null,
            ),
            const SizedBox(height: 20),
            PhoneField(
              controller: phoneController,
              onChanged: (val) => fullPhoneNumber = '965$val',
              validator: (val) => val == null || val.isEmpty
                  ? appTrans.text("register_phone_error")
                  : null,
              labletext: appTrans.text("register_phone"),
              lablehint: '0xxxxxxxx',
            ),
            const SizedBox(height: 20),
            PasswordField(
              controller: passwordController,
              isHidden: isPasswordHidden,
              validator: (val) => val != null && val.length >= 6
                  ? null
                  : appTrans.text("register_password_error"),
              labelText: appTrans.text("register_password"),
              hintText: appTrans.text("register_password_hint"),
            ),
            SizedBox(height: d),
            BlocBuilder<PersonalRegisterCubit, PersonalRegisterState>(
              builder: (context, state) {
                final isLoading =
                    state.status == PersonalRegisterStatus.loading;
                return Column(
                  children: [
                    CustomButton(
                      onTap: () => isLoading ? null : _onRegisterPressed,
                      text: appTrans.text("register_submit"),
                    ),
                    if (isLoading)
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginForm(AppTranslations appTrans, double height) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _loginFormKey,
        child: Column(
          children: [
            PhoneField(
              controller: loginPhoneController,
              onChanged: (raw) {
                fullPhoneNumber = '+965${raw.replaceAll(RegExp(r'\D'), '')}';
              },
              validator: (val) => val == null || val.isEmpty
                  ? appTrans.text("register_phone_error")
                  : null,
              labletext: appTrans.text("phone_number"),
              lablehint: appTrans.text('loginPhoneHint'),
            ),
            const SizedBox(height: 20),
            PasswordField(
              controller: loginPasswordController,
              isHidden: isLoginPasswordHidden,
            ),
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                if (state.status == AuthStatus.error) {
                  return Text(state.errorMessage.toString());
                }
                return const SizedBox.shrink();
              },
            ),
            const SizedBox(height: 10),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: TextButton(
                onPressed: () {},
                child: Text(
                  appTrans.text('forgetPass'),
                  style: TextStyle(color: AppColors.primary),
                ),
              ),
            ),
            SizedBox(height: height),
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                final isLoading = state.status == AuthStatus.loading;
                return Column(
                  children: [
                    CustomButton(
                      onTap: () {
                        isLoading ? null : _onLoginPressed();
                      },
                      text: isLoading
                          ? appTrans.text('loggingIn')
                          : (appTrans.text('login_button')),
                    ),
                    if (isLoading)
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
