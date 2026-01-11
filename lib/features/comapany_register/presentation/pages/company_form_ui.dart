import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Changed from provider
import 'package:image_picker/image_picker.dart';
import 'package:oreed_clean/core/app_shared_prefs.dart';
import 'package:oreed_clean/core/routing/routes.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/core/utils/shared_widgets/custom_button.dart';
import 'package:oreed_clean/core/utils/shared_widgets/custom_form_field.dart';
import 'package:oreed_clean/features/comapany_register/domain/entities/company_entity.dart';
import 'package:oreed_clean/features/comapany_register/presentation/cubit/form_ui_cubit.dart';


class CompanyFormUI extends StatefulWidget {
  const CompanyFormUI({super.key});

  @override
  State<CompanyFormUI> createState() => _CompanyFormUIState();
}

class _CompanyFormUIState extends State<CompanyFormUI> {
  static final _blue = AppColors.primary;

  final _nameArCtrl = TextEditingController();
  final _nameEnCtrl = TextEditingController();
  File? _image;
  final picker = ImagePicker();

  Future<void> _pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (picked != null) setState(() => _image = File(picked.path));
  }

  @override
  void dispose() {
    _nameArCtrl.dispose();
    _nameEnCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // BlocConsumer allows us to "Listen" for navigation/snackbars 
    // and "Build" the UI based on state changes.
    return BlocConsumer<CompanyFormCubit, CompanyFormState>(
      listener: (context, state) async {
        if (state.status == CompanyFormStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.response!.msg)),
          );
          
          // Save to shared prefs and navigate
          if (state.response!.id != null) {
            await AppSharedPreferences().saveCompanyId(state.response!.id!);
          }
          
          Navigator.pushReplacementNamed(context, Routes.homelayout);
        } else if (state == CompanyFormStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage.toString())),
          );
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            Scaffold(
              appBar: AppBar(title: const Text('إنشاء شركة جديدة'), centerTitle: true),
              body: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const SizedBox(height: 12),
                  const Text('الاسم بالعربية'),
                  AppTextField(
                    controller: _nameArCtrl,
                    hint: 'مثال: شركة الريادة', label: null, validator: (String? p1) {  },
                    
                  ),
                  const Text('الاسم بالإنجليزية'),
                  AppTextField(
                    controller: _nameEnCtrl,
                    hint: 'Example: Al-Reyada Company', label: null, validator: (String? p1) {  },
                   
                  ),
                  const Text('شعار الشركة'),
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      height: 180,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: _image == null
                          ?  Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.upload_rounded, size: 50, color: _blue),
                                  Text('اضغط لاختيار الصورة'),
                                ],
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(_image!, fit: BoxFit.cover, width: double.infinity),
                            ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  CustomButton(
                    text: 'إنشاء الشركة',
               
                    onTap: () {
                      if (_nameArCtrl.text.isEmpty || _nameEnCtrl.text.isEmpty || _image == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('يرجى إدخال جميع البيانات المطلوبة')),
                        );
                        return;
                      }

                      final userId = AppSharedPreferences().getUserIdD();
                      if (userId == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('يرجى تسجيل الدخول أولاً')),
                        );
                        return;
                      }

                      final company = CompanyEntity(
                        nameAr: _nameArCtrl.text.trim(),
                        nameEn: _nameEnCtrl.text.trim(),
                        userId: userId,
                        image: _image!,
                      );

                      // Call the Cubit
                      context.read<CompanyFormCubit>().submitCompany(company);
                    },
                  ),
                ],
              ),
            ),
            // Use the Cubit state to show/hide the loading overlay
            if (state == CompanyFormStatus.loading)
              Container(
                color: Colors.black54,
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
          ],
        );
      },
    );
  }
}