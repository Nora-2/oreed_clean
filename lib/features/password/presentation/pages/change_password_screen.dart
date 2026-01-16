import 'package:flutter/material.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/core/utils/shared_widgets/custom_button.dart';
import 'package:oreed_clean/features/password/presentation/widgets/change_pass_aide_func.dart';

class ChangePasswordScreen extends StatefulWidget {
  final String? phone;

  const ChangePasswordScreen({super.key, this.phone});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _oldPassCtrl = TextEditingController();
  final TextEditingController _newPassCtrl = TextEditingController();
  final TextEditingController _confirmPassCtrl = TextEditingController();

  bool _hideOld = true;
  bool _hideNew = true;
  bool _hideConfirm = true; // was final
  bool _isSaving = false;

  String? _phoneFromArgs;

  @override
  void initState() {
    super.initState();
    // دعم تمرير arguments عبر pushNamed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final routeArgs = ModalRoute.of(context)?.settings.arguments;
      if (routeArgs is String) {
        setState(() => _phoneFromArgs = routeArgs);
      } else {
        _phoneFromArgs = widget.phone; // في حال تم الإنشاء بمُنشئ مباشر
      }
    });
  }

  @override
  void dispose() {
    _oldPassCtrl.dispose();
    _newPassCtrl.dispose();
    _confirmPassCtrl.dispose();
    super.dispose();
  }

  String _t(BuildContext context, String key, String fallback) {
    final t = AppTranslations.of(context);
    return t?.text(key) ?? fallback;
  }

  // ---------- Validators ----------
  String? _required(String? v) => (v == null || v.trim().isEmpty)
      ? _t(context, 'required', 'هذا الحقل مطلوب')
      : null;

  String? _newPassValidator(String? v) {
    if (v == null || v.isEmpty) {
      return _t(context, 'required', 'هذا الحقل مطلوب');
    }
    final pass = v.trim();
    if (pass.length < 2) {
      return _t(
        context,
        'weak_password',
        'كلمة المرور يجب أن تكون 8 أحرف على الأقل',
      );
    }
    return null;
  }

  String? _confirmPassValidator(String? v) {
    if (v == null || v.isEmpty) {
      return _t(context, 'required', 'هذا الحقل مطلوب');
    }
    if (v != _newPassCtrl.text) {
      return _t(context, 'passwords_not_match', 'كلمتا المرور غير متطابقتين');
    }
    return null;
  }

  Future<void> _saveTapped() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    final oldPassword = _oldPassCtrl.text.trim();
    final newPassword = _newPassCtrl.text.trim();
    if (oldPassword == newPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _t(
              context,
              'new_same_old',
              'كلمة المرور الجديدة لا يجب أن تطابق القديمة',
            ),
          ),
        ),
      );
      return;
    }
    setState(() => _isSaving = true);
    try {
      final ok = await performChangePassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
      );
      if (!mounted) return;
      if (ok) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_t(context, 'saved_successfully', 'تم الحفظ بنجاح')),
          ),
        );
        Navigator.of(context).pop(true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _t(context, 'something_wrong', 'حدث خطأ ما، حاول لاحقًا'),
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _t(context, 'خطأ في كلمة المرور', 'خطأ في كلمة المرور'),
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          onChanged: () => setState(() {}),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Padding(
                padding: isRTL
                    ? const EdgeInsets.only(
                        right: 8,
                        top: 8,
                        left: 8,
                        bottom: 8,
                      )
                    : const EdgeInsets.only(
                        left: 8,
                        top: 8,
                        right: 8,
                        bottom: 8,
                      ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xffe8e8e9),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        padding: const EdgeInsets.all(6),
                        child: Icon(Icons.arrow_back, color: AppColors.primary),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(
                        _t(context, 'password', 'كلمة المرور'),
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // old password
                    TextFormField(
                      controller: _oldPassCtrl,
                      obscureText: _hideOld,
                      validator: _required,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: _t(
                          context,
                          'current_password',
                          'كلمة المرور الحالية',
                        ),
                        hintText: '********',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1.2,
                          ),
                        ),
                        suffixIcon: IconButton(
                          onPressed: () => setState(() => _hideOld = !_hideOld),
                          icon: Icon(
                            size: 22,
                            color: const Color(0xff676768).withOpacity(.6),
                            _hideOld ? Icons.visibility_off : Icons.visibility,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),
                    // new password
                    TextFormField(
                      controller: _newPassCtrl,
                      obscureText: _hideNew,
                      validator: _newPassValidator,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: _t(
                          context,
                          'new_password',
                          'كلمة المرور الجديدة',
                        ),
                        hintText: '********',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1.2,
                          ),
                        ),
                        suffixIcon: IconButton(
                          onPressed: () => setState(() => _hideNew = !_hideNew),
                          icon: Icon(
                            size: 22,
                            color: const Color(0xff676768).withOpacity(.6),
                            _hideNew ? Icons.visibility_off : Icons.visibility,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _confirmPassCtrl,
                      obscureText: _hideConfirm,
                      validator: _confirmPassValidator,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: _t(
                          context,
                          'confirm_password',
                          'تأكيد كلمة المرور',
                        ),
                        hintText: '********',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1.2,
                          ),
                        ),
                        suffixIcon: IconButton(
                          onPressed: () =>
                              setState(() => _hideConfirm = !_hideConfirm),
                          icon: Icon(
                            size: 22,
                            color: const Color(0xff676768).withOpacity(.6),
                            _hideConfirm
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 150),
                    CustomButton(
                      onTap: () {
                        _isSaving ? null : _saveTapped();
                      },
                      text: _t(context, 'set_password', 'تعيين كلمة المرور'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
