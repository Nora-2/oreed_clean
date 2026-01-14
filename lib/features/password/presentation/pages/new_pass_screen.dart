import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:oreed_clean/features/password/presentation/cubit/password_cubit.dart';
import 'package:oreed_clean/core/routing/routes.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/core/utils/shared_widgets/custom_button.dart';
import 'package:oreed_clean/features/login/presentation/widgets/authbackground.dart';
import 'package:oreed_clean/features/login/presentation/widgets/custom_apptextfield.dart';

class NewPassScreen extends StatefulWidget {
  static const routeName = "/newPass";
  final String? phone;

  const NewPassScreen({super.key, this.phone});

  @override
  State<NewPassScreen> createState() => _NewPassScreenState();
}

class _NewPassScreenState extends State<NewPassScreen> {
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _passControllernew = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _passController.dispose();
    _passControllernew.dispose();
    super.dispose();
  }

  void _onConfirmPressed() {
    if (_formKey.currentState!.validate()) {
      context.read<PasswordCubit>().submitNewPassword(
            phone: widget.phone ?? '',
            password: _passController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppTranslations.of(context);

    return BlocListener<PasswordCubit, PasswordState>(
      listener: (context, state) {
        if (state.status == PasswordStatus.success) {
          Fluttertoast.showToast(
            msg: t?.text('editDone') ?? "تم تغيير كلمة المرور بنجاح",
          );

    
          Navigator.pushNamedAndRemoveUntil(
            context,
            Routes.homelayout,
            (p) => p.isFirst,
          );
        }

        if (state.status == PasswordStatus.error) {
          Fluttertoast.showToast(
            msg: state.errorMessage ?? t?.text('somethingWrong') ?? "خطأ",
            backgroundColor: Colors.red,
          );
        }
      },
      child: AuthBack(
        title: 'أدخل كلمة مرور جديدة',
        subtitle: 'حط كلمة مرور جديدة علشان نحافظ على حسابك',
        child: Expanded(
          child: Container(
            decoration:  BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              border: Border(
                top: BorderSide(color: AppColors.secondary, width: 2),
              ),
            ),
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: PasswordField(
                          labelText: 'كلمة المرور الجديدة',
                          controller: _passController,
                          isHidden: true,
                          validator: (v) {
                            if (v == null || v.isEmpty) return "من فضلك أدخل كلمة المرور";
                            if (v.length < 6) return "كلمة المرور قصيرة جداً";
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: PasswordField(
                          controller: _passControllernew,
                          labelText: 'تأكيد كلمة المرور',
                          isHidden: true,
                          validator: (v) {
                            if (v == null || v.isEmpty) return "من فضلك أكد كلمة المرور";
                            if (v != _passController.text) return "كلمتا المرور غير متطابقتين";
                            return null;
                          },
                        ),
                      ),

                      // Spacing
                      SizedBox(height: MediaQuery.of(context).size.height * 0.35),

                      // Button with loading logic
                      BlocBuilder<PasswordCubit, PasswordState>(
                        builder: (context, state) {
                          bool isLoading = state.status == PasswordStatus.loading;
                          
                          return CustomButton(
                            text: isLoading ? 'جاري التحميل...' : 'تأكيد',
                            onTap:()=> isLoading ? null : _onConfirmPressed,
                          );
                        },
                      ),

                      // Keyboard offset
                      SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}