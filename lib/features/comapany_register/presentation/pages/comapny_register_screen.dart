// ignore_for_file: body_might_complete_normally_nullable

import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Changed from Provider
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oreed_clean/core/routing/routes.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart'
    show AppTranslations;
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/core/utils/appicons/app_icons.dart';
import 'package:oreed_clean/core/utils/appimage/app_images.dart';
import 'package:oreed_clean/core/utils/appstring/app_string.dart';
import 'package:oreed_clean/core/utils/bottomsheets/option_sheet_register_grid.dart';
import 'package:oreed_clean/core/utils/option_item_register.dart';
import 'package:oreed_clean/core/utils/shared_widgets/custom_button.dart';
import 'package:oreed_clean/core/utils/shared_widgets/custom_form_field.dart';
import 'package:oreed_clean/core/utils/textstyle/appfonts.dart';
import 'package:oreed_clean/features/comapany_register/presentation/cubit/comapany_register_cubit.dart';
import 'package:oreed_clean/features/login/presentation/cubit/login_cubit.dart';
import 'package:oreed_clean/features/login/presentation/cubit/login_state.dart';
import 'package:oreed_clean/features/login/presentation/widgets/custom_apptextfield.dart';
import 'package:oreed_clean/features/login/presentation/widgets/custom_phonefield.dart';
import '../../../../core/utils/bottomsheets/option_sheet_register_list.dart';
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
  CategoryEntity? selectedMainCategory;
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


  // --- Original Decoration Method ---
  InputDecoration _selectDecoration({
    required String label,
    String? errorText,
  }) {
    return InputDecoration(
      suffixIcon: const Icon(
        Icons.keyboard_arrow_down,
        color: Colors.black,
        size: 30,
      ),
      labelText: label,
      errorText: errorText,
      labelStyle: AppFonts.body.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300, width: 1.2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
    );
  }

  Color _tagColor(int i) => i.isEven ? AppColors.primary : AppColors.secondary;

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  // ============== LOGIC ==============

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
    String? token = await FirebaseMessaging.instance.getToken();
    final phone = mobileController.text.trim();
    final body = {
      'business_name_ar': companyNameController.text.trim(),
      'phone': '965$phone',
      'whatsapp': whatsappController.text.trim(),
      'password': passwordController.text.trim(),
      'account_type': 'business',
      'fcm_token': token,
      'state_id': selectedCountry!.id.toString(),
      'city_id': selectedGovernorate!.id.toString(),
      'section_id': selectedMainCategory!.id.toString(),
      'company_type_id': selectedSubCategory!.id.toString(),
      'image': logoFile,
      'license': licenseFile,
    };
    context.read<CompanyRegisterCubit>().submitRegister(body);
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
              // Navigator.push(context, MaterialPageRoute(builder: (context) => VerificationScreen(
              //   isRegister: true, phone: '965${mobileController.text.trim()}', isCompany: true,
              // )));
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
                    _buildAppBar(),
                    _buildHeader(appTrans!),
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
                          ? _buildStep1Content(appTrans,size.height*.45)
                          : _buildStep2Content(appTrans),
                    ),
                  ],
                ),
              ),
            ),
            _buildLoadingOverlay(),
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
            text: appTrans.text('verify_phone_number') ?? 'تحقق من رقم هاتفك',
            font: 16,
            
            onTap: _onRegisterPressed,
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
  Widget _buildStep1Content(AppTranslations appTrans ,double height) {
    return Column(
      children: [
        _buildToggleTabs(appTrans),
        if (_currentPage == 0)
          Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _companyFormKey,
              child: _buildRegistrationFields(context),
            ),
          )
        else
          _buildLoginForm(appTrans,height),
      ],
    );
  }

  // --- THE ORIGINAL FORM FIELD UI ---
  Widget _buildRegistrationFields(BuildContext context) {
    final t = AppTranslations.of(context);
    return BlocBuilder<CompanyRegisterCubit, CompanyRegisterState>(
      builder: (context, state) {
        return Column(
          children: [
            AppTextField(
              hint:t?.text(AppString.companyNameHint) ?? 'Company Name' ,
              controller: companyNameController,
              label: Text(t?.text('company_name_label') ?? 'Company Name'),
              validator: (String? p1) {},
            ),
            const SizedBox(height: 20),
            PhoneField(
              controller: mobileController,
              labletext: t?.text('phone_label') ?? 'Phone',
              validator: (String? p1) {},
              lablehint: t?.text(AppString.phoneHint) ?? 'Phone',
            ),
            const SizedBox(height: 20),
            PhoneField(
              controller: whatsappController,
              labletext: t?.text('whatsapp_label') ?? 'WhatsApp',
              validator: (String? p1) {},
              lablehint: t?.text(AppString.whatsappHint) ?? 'whatsapp',
            ),
            const SizedBox(height: 20),
            PasswordField(
              controller: passwordController,
              isHidden: isPasswordHidden,
              labelText: t?.text('password_label') ?? 'Password',
            ),
            const SizedBox(height: 20),

            FormField<CountryEntity>(
              validator: (_) => selectedCountry == null ? 'Required' : null,
              builder: (fieldState) => GestureDetector(
                onTap: () async {
                  final opts = state.countries
                      .asMap()
                      .entries
                      .map(
                        (e) => OptionItemregister(
                          label: e.value.name,
                          icon: AppIcons.global,
                          colorTag: e.key,
                        ),
                      )
                      .toList();
                  final res = await showAppOptionSheetregister(
                    context: context,
                    subtitle: t?.text('choose_country_subtitle') ??
                    'اختر محافظتك لعرض الإعلانات والخدمات القريبة منك.',
                hint:
                    t?.text('select.search_governorate') ?? 'ابحث عن المحافظة',
                title: t?.text('choose_governorate') ?? 'اختر الدولة',
                    options: opts,
                    tagColor: _tagColor,
                    current: selectedCountry?.name,
                    
                  );
                  if (res != null) {
                    setState(() {
                      selectedCountry = state.countries.firstWhere(
                        (c) => c.name == res,
                      );
                      selectedGovernorate = null;
                    });
                    fieldState.didChange(selectedCountry);
                    context.read<CompanyRegisterCubit>().fetchStates(
                      selectedCountry!.id,
                    );
                  }
                },
                child: InputDecorator(
                  decoration: _selectDecoration(
                    label: t?.text('governorate') ?? 'الدولة',
                    errorText: fieldState.errorText,
                  ),
                  child: Text(
                    selectedCountry?.name ??
                        (t?.text('choose_governorate') ?? 'اختر الدولة'),
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // --- STATE SELECTION (ORIGINAL UI) ---
            FormField<StateEntity>(
              validator: (_) => selectedGovernorate == null ? 'Required' : null,
              builder: (fieldState) => GestureDetector(
                onTap: () async {
                  if (state.states.isEmpty) return;
                  final opts = state.states
                      .asMap()
                      .entries
                      .map(
                        (e) => OptionItemregister(
                          label: e.value.name,
                          icon: AppIcons.location,
                          colorTag: e.key,
                        ),
                      )
                      .toList();
                  final res = await showAppOptionSheetregister(
                    context: context,
                    title: t?.text('choose_country') ?? 'اختر المحافظة',
                    options: opts,
                    tagColor: _tagColor,
                    current: selectedGovernorate?.name,
                    subtitle: t?.text('select.select_area_subtitle') ??
                    'اختر منطقتك لعرض الإعلانات والخدمات القريبة منك.',
                hint: t?.text('select.search_area') ?? 'ابحث عن المنطقة',
              
                  );
                  if (res != null) {
                    setState(
                      () => selectedGovernorate = state.states.firstWhere(
                        (s) => s.name == res,
                      ),
                    );
                    fieldState.didChange(selectedGovernorate);
                  }
                },
                child: InputDecorator(
                  decoration: _selectDecoration(
                    label: t?.text("location.area") ?? 'المحافظة',
                    errorText: fieldState.errorText,
                  ),
                  child: Text(
                    selectedGovernorate?.name ??
                        (t?.text("select.select_area") ?? 'اختر المحافظة'),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // --- MAIN CATEGORY (GRID ORIGINAL UI) ---
            FormField<CategoryEntity>(
              validator: (_) =>
                  selectedMainCategory == null ? 'Required' : null,
              builder: (fieldState) => GestureDetector(
                onTap: () async {
                  if (state.sections.isEmpty) return;
                  final opts = state.sections
                      .asMap()
                      .entries
                      .map(
                        (e) => OptionItemregister(
                          label: e.value.name,
                          icon: e.value.image,
                          colorTag: e.key,
                        ),
                      )
                      .toList();
                  final res = await showAppOptionSheetregistergrid(
                    context: context,
                    
                    options: opts,
                    current: selectedMainCategory?.name,
                   hint: AppTranslations.of(context)!.text('search_main_section_hint'),
      subtitle:
          AppTranslations.of(context)!.text('select_main_section_subtitle'),
    
      title: AppTranslations.of(context)?.text('company_main_section_title') ??
          'القسم الرئيسي لشركتك',
                  );
                  if (res != null) {
                    final section = state.sections.firstWhere(
                      (s) => s.name == res,
                    );
                    setState(() {
                      selectedMainCategory = CategoryEntity(
                        id: section.id,
                        name: section.name,
                      );
                      selectedSubCategory = null;
                    });
                    fieldState.didChange(selectedMainCategory);
                    context.read<CompanyRegisterCubit>().getCategories(
                      section.id,
                    );
                  }
                },
                child: InputDecorator(
                  decoration: _selectDecoration(
                    label: t?.text('main_category_label') ?? 'القسم الرئيسي',
                    errorText: fieldState.errorText,
                  ),
                  child: Text(
                    selectedMainCategory?.name ??
                        (t?.text('choose_main_section') ??
                            'اختر القسم الرئيسي'),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            FormField<CategoryEntity>(
              validator: (_) => selectedSubCategory == null ? 'Required' : null,
              builder: (fieldState) => GestureDetector(
                onTap: () async {
                  List<CategoryEntity> cats = _getSubCats(state);
                  if (cats.isEmpty) return;
                  final opts = cats
                      .asMap()
                      .entries
                      .map(
                        (e) => OptionItemregister(
                          label: e.value.name,
                          icon: e.value.image,
                          colorTag: e.key,
                        ),
                      )
                      .toList();
                  final res = await showAppOptionSheetregistergrid(
                  
                    options: opts,
                    current: selectedSubCategory?.name,
                 hint: AppTranslations.of(context)!.text('search_sub_section_hint'),
      context: context,
      subtitle:
          AppTranslations.of(context)!.text('select_sub_section_subtitle'),
      title: AppTranslations.of(context)?.text('sub_section_title') ??
          ' القسم الفرعي',
                  );
                  if (res != null) {
                    setState(
                      () => selectedSubCategory = cats.firstWhere(
                        (c) => c.name == res,
                      ),
                    );
                    fieldState.didChange(selectedSubCategory);
                  }
                },
                child: InputDecorator(
                  decoration: _selectDecoration(
                    label: t?.text('choose_sub_section') ?? 'القسم الفرعي',
                    errorText: fieldState.errorText,
                  ),
                  child: Text(
                    selectedSubCategory?.name ??
                        (t?.text('choose_sub_section') ?? 'اختر القسم الفرعي'),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: t?.text('verify_phone_number') ?? 'Next',
              onTap: () {
                if (_companyFormKey.currentState!.validate() &&
                    selectedSubCategory != null)
                  setState(() => _currentStep = 2);
              },
            ),
          ],
        );
      },
    );
  }

  List<CategoryEntity> _getSubCats(CompanyRegisterState state) {
    if (selectedMainCategory?.id == 1) return state.categoriesCars;
    if (selectedMainCategory?.id == 2) return state.categoriesProperties;
    if (selectedMainCategory?.id == 3) return state.categoriesTechnicians;
    return state.categoriesAnyThing;
  }

  // --- UI SUPPORT METHODS ---
  Widget _buildAppBar() {
    return Align(
      alignment: Alignment.centerRight,
      child: IconButton(
        icon: CircleAvatar(
          backgroundColor: Colors.white,
          child: Icon(Icons.arrow_back, color: AppColors.primary),
        ),
        onPressed: () => _currentStep == 2
            ? setState(() => _currentStep = 1)
            : Navigator.pop(context),
      ),
    );
  }

  Widget _buildHeader(AppTranslations t) {
    return Column(
      children: [
        Text(
          t.text('auth.create_company_account'),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            t.text('company_register_subtitle'),
            style: const TextStyle(color: Colors.white70),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildToggleTabs(AppTranslations t) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: AppColors.secondary),
        ),
        child: Row(
          children: [
            _tab(0, t.text('auth.create_company_account')),
            _tab(1, t.text('login')),
          ],
        ),
      ),
    );
  }

  Widget _tab(int index, String label) {
    bool active = _currentPage == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _currentPage = index),
        child: Container(
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: active ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(40),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: active ? Colors.white : AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm(AppTranslations t,double height) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _loginFormKey,
        child: Column(
          children: [
            PhoneField(
              controller: loginPhoneController,
              labletext: t.text('phone_label'),
              validator: (String? p1) {},
              lablehint: t.text(AppString.phoneHint),
            ),
            const SizedBox(height: 20),
            PasswordField(
              controller: loginPasswordController,
              isHidden: isLoginPasswordHidden,
              labelText: t.text('password_label'),
            ),
             SizedBox(height:height),
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
          _buildThumbnailTile(
            context,
            subtitle: t?.text('company_logo_subtitle') ?? "Logo",
            title: t?.text('company_logo_title') ?? 'Company Logo',
            file: logoFile,
            onPick: _pickLogo,
          ),
          const SizedBox(height: 25),
          _buildThumbnailTile(
            context,
            title: t?.text('license_title') ?? 'License',
            file: licenseFile,
            onPick: _pickLicense,
          ),
          const SizedBox(height: 16),
          
        ],
      ),
    );
  }
  Widget _buildThumbnailTile(
    BuildContext context, {
    required String title,
    required File? file,
    required VoidCallback onPick,
    String? subtitle,
  }) {
    final t = AppTranslations.of(context);

    if (file == null) {
      return InkWell(
        onTap: onPick,
        borderRadius: BorderRadius.circular(12),
        child: InputDecorator(
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            label: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: title,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                  subtitle != null
                      ? TextSpan(
                          text: " ($subtitle)",
                          style: const TextStyle(
                              color: Colors.black, fontSize: 16),
                        )
                      : const TextSpan(),
                  const TextSpan(
                    text: ' *',
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  ),
                ],
              ),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                   BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                AppIcons.uploadIcon,
                height: 32,
              ),
              const SizedBox(height: 12),
              Text(
                t?.text('upload_hint_1') ?? 'Choose file or JPG, PNG..',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                t?.text('upload_hint_2') ?? 'Max size 10MB, JPG, PNG or PDF',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return SizedBox(
      height: 180,
      width: 400,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                width: double.infinity,
                file,
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Change/Edit Icon Overlay
          Positioned(
            top: 8,
            right: 8,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onPick,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.edit_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        t?.text('change') ?? 'تغيير',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildLoadingOverlay() {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, auth) {
        return BlocBuilder<CompanyRegisterCubit, CompanyRegisterState>(
          builder: (context, reg) {
            if (auth.status == AuthStatus.loading ||
                reg.status == RegisterStatus.loading) {
              return Container(
                color: Colors.black12,
                child: const Center(child: CircularProgressIndicator()),
              );
            }
            return const SizedBox.shrink();
          },
        );
      },
    );
  }
}
