// ignore_for_file: use_build_context_synchronously
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Changed from Provider
import 'package:image_picker/image_picker.dart';
import 'package:oreed_clean/core/app_shared_prefs.dart';
import 'package:oreed_clean/core/routing/routes.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart'
    show AppTranslations;
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/core/utils/appimage/app_images.dart';
import 'package:oreed_clean/core/utils/appstring/app_string.dart';
import 'package:oreed_clean/core/utils/shared_widgets/custom_button.dart';
import 'package:oreed_clean/features/comapany_register/presentation/cubit/comapany_register_cubit.dart';
import 'package:oreed_clean/features/comapany_register/presentation/widgets/company_register_form.dart';
import 'package:oreed_clean/features/comapany_register/presentation/widgets/helperwidgets.dart';
import 'package:oreed_clean/features/comapany_register/presentation/widgets/loading.dart';
import 'package:oreed_clean/features/comapany_register/presentation/widgets/themtile.dart';
import 'package:oreed_clean/features/home/domain/entities/section_entity.dart';
import 'package:oreed_clean/features/login/presentation/cubit/login_cubit.dart';
import 'package:oreed_clean/features/login/presentation/cubit/login_state.dart';
import 'package:oreed_clean/features/login/presentation/widgets/custom_apptextfield.dart';
import 'package:oreed_clean/features/login/presentation/widgets/custom_phonefield.dart';
import 'package:oreed_clean/features/login/presentation/widgets/success_dialog.dart';
import '../../../../features/comapany_register/presentation/cubit/comapany_register_state.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/country_entity.dart';
import '../../domain/entities/state_entity.dart';

class CompanyRegisterScreen extends StatefulWidget {
  const CompanyRegisterScreen({super.key});

  @override
  State<CompanyRegisterScreen> createState() => _CompanyRegisterScreenState();
}

class _CompanyRegisterScreenState extends State<CompanyRegisterScreen> {
  final _companyFormKey = GlobalKey<FormState>();
  final companyNameController = TextEditingController();
  final mobileController = TextEditingController();
  final whatsappController = TextEditingController();
  final passwordController = TextEditingController();

  final _loginFormKey = GlobalKey<FormState>();
  final loginPhoneController = TextEditingController();
  final loginPasswordController = TextEditingController();

  int _currentPage = 0;
  int _currentStep = 1;
  bool isPasswordHidden = true;
  bool isLoginPasswordHidden = true;

  File? logoFile;
  File? licenseFile;

  CountryEntity? selectedCountry;
  StateEntity? selectedGovernorate;
  SectionEntity? selectedMainCategory;
  CategoryEntity? selectedSubCategory;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CompanyRegisterCubit>().fetchCountries();
      context.read<CompanyRegisterCubit>().fetchSections();
    });
  }

  Future<void> _pickImage(void Function(File file) onPicked) async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => onPicked(File(picked.path)));
  }

  Future<void> _pickLogo() async => _pickImage((f) => logoFile = f);

  Future<void> _pickLicense() async => _pickImage((f) => licenseFile = f);


 
  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }


  Future<void> _onLoginPressed() async {
    final rawInput = loginPhoneController.text.trim();
    final onlyDigits = rawInput.replaceAll(RegExp(r'\D'), '');
    String? token = await FirebaseMessaging.instance.getToken();
    context.read<AuthCubit>().login(
      phone: onlyDigits,
      password: loginPasswordController.text.trim(),
      fcmToken: token ?? "dummy",
    );
  }


Future<void> _onRegisterPressed() async {

  
  if (logoFile == null || licenseFile == null) {
    _showSnack("Please upload logo and license");
    return;
  }

  // 2. Setup
  final cubit = context.read<CompanyRegisterCubit>();
  final t = AppTranslations.of(context);
  


  try {
    // 3. Prepare Data
    String? token = await FirebaseMessaging.instance.getToken();
    final phoneTrimmed = mobileController.text.trim();
    final fullPhone = '965$phoneTrimmed';

    final body = {
      'business_name_ar': companyNameController.text.trim(),
      'phone': fullPhone,
      'whatsapp': whatsappController.text.trim(),
      'password': passwordController.text.trim(),
      'account_type': 'business',
      'fcm_token': token,
      'state_id': selectedCountry!.id.toString(),
      'city_id': selectedGovernorate!.id.toString(),
      'section_id': selectedMainCategory!.id.toString(),
      'image': logoFile,
      'license': licenseFile,

    };

    if (selectedSubCategory != null) {
      body['company_type_id'] = selectedSubCategory!.id.toString();
    }

    // 4. Call Cubit and WAIT for it to finish
    await cubit.submitRegister(body);

    // 5. Logic handling based on Cubit State
    if (cubit.state.status == RegisterStatus.success) {
      // Save data locally
      await AppSharedPreferences().saveuserPhone(fullPhone);

      // Show Success Dialog
      if (mounted) {
        await showRequestSubmittedDialog(
          context,
          title: '',
          message: cubit.state.response?.msg ??
              (t?.text('request_sent_msg') ?? 'سوف يتم التواصل معكم قريبًا'),
        );
      }

      // Navigate to Verification
      if (mounted) {
          Navigator.pushNamed(
            context,
            Routes.verificationScreen,
            arguments: {
               'isRegister': true,
               'phone': fullPhone,
               'isCompany': true,
            },
          );
      }
    } else if (cubit.state.status == RegisterStatus.error) {
      // Show Error Message
      final err = cubit.state.error;
      _showSnack(err ?? t?.text('register_office_failed') ?? 'Registration failed');
    }
  } catch (e) {
    _showSnack(e.toString());
  } finally {
   
  }
}

  @override
  Widget build(BuildContext context) {
    final appTrans = AppTranslations.of(context);
    final size = MediaQuery.of(context).size;

    return MultiBlocListener(
      listeners: [
        BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state.status == AuthStatus.success) {
              Navigator.pushReplacementNamed(context, Routes.homelayout);
            } else if (state.status == AuthStatus.error) {
              _showSnack(state.errorMessage ?? "Error");
            }
          },
        ),
        BlocListener<CompanyRegisterCubit, CompanyRegisterState>(
          listener: (context, state) {
            if (state.status == RegisterStatus.success) {
              Navigator.pushNamed(context, Routes.verificationScreen, arguments: {
                'isRegister': true, 'phone': '965${mobileController.text.trim()}', 'isCompany': true,
              });
            } else if (state.status == RegisterStatus.error) {
              _showSnack(state.error ?? "Error");
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(Appimage.loginBack),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    RegisterAppBar(
                      currentStep: _currentStep,
                      onBack: () => setState(() => _currentStep = 1),
                      onPop: () => Navigator.pop(context),
                    ),

                    RegisterHeader(t: appTrans!),

                    const SizedBox(height: 30),
                    Container(
                      width: double.infinity,
                      constraints: BoxConstraints(minHeight: size.height * 0.9),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(30),
                        ),
                      ),
                      child: _currentStep == 1
                          ? _buildStep1Content(appTrans, size.height * .45)
                          : _buildStep2Content(appTrans),
                    ),
                  ],
                ),
              ),
            ),
            Loading(),
          ],
        ),
      ),
    );
  }

  Widget _buildStep2Content(AppTranslations appTrans) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 10),
          _buildStep2Images(context),
          SizedBox(height: size.height * 0.12),
          CustomButton(
            text: appTrans.text('verify_phone_number') ,
            font: 16,

            onTap: _onRegisterPressed,
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildStep1Content(AppTranslations appTrans, double height) {
    return Column(
      children: [
        RegisterToggleTabs(
          t: appTrans,
          currentPage: _currentPage,
          onTabChange: (index) {
            setState(() => _currentPage = index);
          },
        ),

        if (_currentPage == 0)
          Padding(
  padding: const EdgeInsets.all(20),
  child: Form(
    key: _companyFormKey,
    child: CompanyRegistrationForm(
      companyNameController: companyNameController,
      mobileController: mobileController,
      whatsappController: whatsappController,
      passwordController: passwordController,
      isPasswordHidden: isPasswordHidden,

      selectedCountry: selectedCountry,
      selectedGovernorate: selectedGovernorate,
      selectedMainCategory: selectedMainCategory,
      selectedSubCategory: selectedSubCategory,

      onCountrySelected: (country) {
        setState(() {
          selectedCountry = country;
          selectedGovernorate = null;
        });
        context
            .read<CompanyRegisterCubit>()
            .fetchStates(country.id);
      },

      onGovernorateSelected: (stateEntity) {
        setState(() => selectedGovernorate = stateEntity);
      },

      onMainCategorySelected: (category) {
        setState(() {
          selectedMainCategory = category;
          selectedSubCategory = null;
        });
        context
            .read<CompanyRegisterCubit>()
            .getCategories(category.id);
      },

      onSubCategorySelected: (category) {
        setState(() => selectedSubCategory = category);
      },

      onSubmit: () {
        if (_companyFormKey.currentState!.validate() &&
            selectedSubCategory != null) {
          setState(() => _currentStep = 2);
        }
      },
    ),
  ),
)
        else
          _buildLoginForm(appTrans, height),
      ],
    );
  }




  Widget _buildLoginForm(AppTranslations t, double height) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _loginFormKey,
        child: Column(
          children: [
            PhoneField(
              controller: loginPhoneController,
              labletext: t.text('phone_label'),
              validator: (String? p1) {
                return null;
              },
              lablehint: t.text(AppString.phoneHint),
            ),
            const SizedBox(height: 20),
            PasswordField(
              controller: loginPasswordController,
              isHidden: isLoginPasswordHidden,
              labelText: t.text('password_label'),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, Routes.resetpass);
                },
                child: Text(
                  t.text('forgetPass'),
                  style: TextStyle(color: AppColors.primary),
                ),
              ),
            ),
            SizedBox(height: height),
            CustomButton(text: t.text('login'), onTap: _onLoginPressed),
          ],
        ),
      ),
    );
  }

  Widget _buildStep2Images(BuildContext context) {
    final t = AppTranslations.of(context);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title Section

          // Images upload section
          ThumbnailTile(
            subtitle: t?.text('company_logo_subtitle') ?? "Logo",
            title: t?.text('company_logo_title') ?? 'Company Logo',
            file: logoFile,
            onPick: _pickLogo,
          ),
          const SizedBox(height: 25),
          ThumbnailTile(
            title: t?.text('license_title') ?? 'License',
            file: licenseFile,
            onPick: _pickLicense,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
