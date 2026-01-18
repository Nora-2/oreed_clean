// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:oreed_clean/core/app_shared_prefs.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/core/utils/shared_widgets/custom_button.dart';
import 'package:oreed_clean/core/utils/shared_widgets/custom_form_field.dart';
import 'package:oreed_clean/features/settings/data/repositories/profile_repo.dart';
import 'package:oreed_clean/networking/exception.dart';
import 'package:oreed_clean/networking/response.dart';

// -------- الخطوة 1: النوع + الآرجس --------
enum ProfileKind { user, company }

class EditProfileArgs {
  final ProfileKind kind;
  final String initialName;
  final String initialPhone;
  final String? initialLogoUrl; // للشركة فقط

  const EditProfileArgs({
    required this.kind,
    required this.initialName,
    required this.initialPhone,
    this.initialLogoUrl,
  });
}

class EditProfileScreen extends StatefulWidget {
  static const routeName = '/edit-profile';

  final ProfileKind kind;
  final String initialName;
  final String initialPhone;
  final String? initialLogoUrl; // للشركة فقط

  const EditProfileScreen({
    super.key,
    required this.kind,
    required this.initialName,
    required this.initialPhone,
    this.initialLogoUrl,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _phoneCtrl;

  // Use a local variable for ease of use, but initialize it from widget props
  late ProfileKind _kind;

  @override
  void initState() {
    super.initState();
    // Initialize controllers from widget properties directly
    _nameCtrl = TextEditingController(text: widget.initialName);
    _kind = widget.kind;

    // ✅ Initialize phone controller first, then load from cache
    _phoneCtrl = TextEditingController();
    _loadPhoneFromCache();
    
  }

  Future<void> _loadPhoneFromCache() async {
    if (!_isCompany) {
      // For personal users, load phone from cache
      final cachedPhone = _prefs.userPhone ?? widget.initialPhone;
      _phoneCtrl.text = cachedPhone;
    } else {
      // For company, use the passed phone
      _phoneCtrl.text = widget.initialPhone;
    }
  }

  bool get _isCompany => _kind == ProfileKind.company;
  final _profileRepo = ProfileRepository();
  final _prefs = AppSharedPreferences();
  bool _isSaving = false;


  bool get _showPhoneField => !_isCompany; // Show phone field for personal users only

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  String _t(BuildContext context, String key, String fallback) {
    final t = AppTranslations.of(context);
    return t?.text(key) ?? fallback;
  }

  String? _required(String? v) => (v == null || v.trim().isEmpty)
      ? _t(context, 'required', 'هذا الحقل مطلوب')
      : null;

  Future<void> _saveTapped() async {
    if (_isSaving) return; // Prevent double taps
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    await _saveProfile();
  }

  Future<void> _saveProfile() async {
    setState(() => _isSaving = true);
    try {
      final newName = _nameCtrl.text.trim();
      final newPhone = _showPhoneField ? _phoneCtrl.text.trim() : null;

      String? logoUrl;

      // Call API to update profile
      final response = await _profileRepo.editProfile(
        name: newName,
        phone: newPhone,
        logo: logoUrl,
      );

      if (!mounted) return;

      // Check if response is successful
      if (response.status == Status.COMPLETED) {
        final data = response.data;
        String successMessage = 'تم الحفظ بنجاح';

        // Extract success message from API response
        if (data is Map) {
          if (data.containsKey('msg')) {
            successMessage = data['msg'].toString();
          } else if (data.containsKey('message')) {
            successMessage = data['message'].toString();
          }
        }

        // ✅ Cache the new name in SharedPreferences
        if (_isCompany) {
          await _prefs.saveUserNameAr(newName);
        } else {
          await _prefs.saveUserName(newName);
        }

        // Also cache phone if updated
        if (newPhone != null && newPhone.isNotEmpty) {
          await _prefs.saveuserPhone(newPhone);
        }

      

        // Return success to previous screen
        Navigator.of(context).pop(true);
      } else {
        throw Exception('Failed to update profile');
      }
    } on ErrorMessgeException catch (e) {
      if (!mounted) return;
      // Handle validation errors from API
      String errorMsg =
          _t(context, 'something_wrong', 'حدث خطأ ما، حاول لاحقًا');

      try {
        final errors = e.bodyWithErrors;
        if (errors.containsKey('msg')) {
          errorMsg = errors['msg'].toString();
        } else if (errors.containsKey('message')) {
          errorMsg = errors['message'].toString();
        } else if (errors.containsKey('errors')) {
          // Handle validation errors
          final validationErrors = errors['errors'];
          if (validationErrors is Map) {
            errorMsg = validationErrors.values.first.toString();
          }
        }
            } catch (_) {}

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMsg)),
      );
    } catch (e) {
      if (!mounted) return;
      debugPrint('Error saving profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                _t(context, 'something_wrong', 'حدث خطأ ما، حاول لاحقًا'))),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppTranslations.of(context)!;
    final theme = Theme.of(context);
  
    final nameLabel = _isCompany
        ? (t.text('company_name'))
        : (t.text('name') );

    final nameHint = _isCompany
        ? (t.text('enter_company_name') )
        : (t.text('enter_name'));

    final phoneLabel = _isCompany
        ? (t.text('company_phone') )
        : (t.text('phone'));

    final phoneHint = _isCompany
        ? (t.text('enter_company_phone') )
        : (t.text('enter_phone') );

    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          onChanged: () => setState(() {}),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: const Color(0xffe8e8e9),
                          borderRadius: BorderRadius.circular(25)),
                      padding: const EdgeInsets.all(6),
                      child:  Icon(
                        Icons.arrow_back,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                t.text('personalData') ,
                style: theme.textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),


              const SizedBox(height: 12),

              // ---- بيانات عامة ----
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 12),

                    AppTextField(
                      controller: _nameCtrl,
                      validator: _required,
                      label: Text(nameLabel),
                      hint: nameHint,
                    ),

                    const SizedBox(height: 12),
                    
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.5),

              CustomButton(
                onTap: () {
                  _isSaving ? null : _saveTapped();
                },
                text: t.text('action.save_changes'),
              )
            ],
          ),
        ),
      ),
    );
  }
}

