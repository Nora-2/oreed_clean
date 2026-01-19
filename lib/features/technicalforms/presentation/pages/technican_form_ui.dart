
// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:oreed_clean/core/app_shared_prefs.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/core/utils/appimage/app_images.dart';
import 'package:oreed_clean/core/utils/shared_widgets/custom_button.dart';
import 'package:oreed_clean/core/utils/shared_widgets/generic_review_screen.dart';
import 'package:oreed_clean/features/technicalforms/domain/entities/city_entity.dart';
import 'package:oreed_clean/features/technicalforms/domain/entities/state_entity.dart';
import 'package:oreed_clean/features/technicalforms/domain/entities/technican_detailes_entity.dart';
import 'package:oreed_clean/features/technicalforms/presentation/cubit/technician_forms_state.dart';
import 'package:oreed_clean/features/technicalforms/presentation/widgets/gallery_grid.dart';
import 'package:oreed_clean/features/technicalforms/presentation/widgets/image_componants.dart';
import 'package:oreed_clean/features/technicalforms/presentation/widgets/image_source_sheet.dart';
import 'package:oreed_clean/features/technicalforms/presentation/widgets/location_selector.dart';
import 'package:oreed_clean/features/technicalforms/presentation/widgets/review_section.dart';
import 'package:oreed_clean/features/technicalforms/presentation/widgets/submitad.dart';
import 'package:oreed_clean/features/technicalforms/presentation/widgets/technican_form_header_fields.dart';
import 'package:oreed_clean/networking/api_provider.dart';
import '../cubit/technician_forms_cubit.dart';


class TechnicianFormUI extends StatefulWidget {
  const TechnicianFormUI({
    super.key,
    required this.categoryId,
    required this.sectionID,
    this.companyId,
    this.companyTypeId,
    this.adId,
  });

  final int categoryId;
  final int sectionID;
  final int? companyId;
  final int? companyTypeId;
  final int? adId;

  @override
  State<TechnicianFormUI> createState() => _TechnicianFormUIState();
}

class _TechnicianFormUIState extends State<TechnicianFormUI> {
  bool get _isEditing => widget.adId != null;

  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _phone = TextEditingController();
  final _whatsapp = TextEditingController();
  final _picker = ImagePicker();

  File? _mainImageFile;
  String? _mainImageUrl;

  final List<MediaItem> _galleryRemote = [];
  final List<File> _galleryLocal = [];
  final Set<int> _deletingRemote = {};


  StateEntity? _selectedState;
  CityEntity? _selectedCity;

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  Future<void> _initializeForm() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final cubit = context.read<TechnicianFormsCubit>();
      await cubit.fetchStates();
      if (_isEditing) {
        await _loadExistingData(cubit);
      }
    });
  }

  Future<void> _loadExistingData(TechnicianFormsCubit cubit) async {
    await cubit.fetchTechnicianDetails(widget.adId!);
    final d = cubit.loadedDetails;
    if (d != null) {
      _nameCtrl.text = d.name;
      _descCtrl.text = d.description;
      _phone.text = d.phone;
      _whatsapp.text = d.whatsapp;
      _galleryRemote.addAll(d.media);
      _mainImageUrl = d.mainImageUrl;

      _selectedState = StateEntity(id: d.stateId, name: d.stateName!);
      await cubit.fetchCities(d.stateId);
      _selectedCity = CityEntity(id: d.cityId, name: d.cityName!);
      setState(() {});
    }
  }

  Future<void> _pickMainImage(ImageSource source) async {
    final image = await _picker.pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 1920,
      maxHeight: 1920,
    );
    if (image != null) {
      setState(() {
        _mainImageFile = File(image.path);
        _mainImageUrl = null;
      });
    }
  }

  Future<void> _pickGalleryImages(ImageSource source) async {
    if (source == ImageSource.gallery) {
      final images = await _picker.pickMultiImage(
        imageQuality: 85,
        maxWidth: 1920,
        maxHeight: 1920,
      );
      if (images.isNotEmpty) {
        setState(() => _galleryLocal.addAll(images.map((e) => File(e.path))));
      }
    } else {
      final image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
        maxWidth: 1920,
        maxHeight: 1920,
      );
      if (image != null) {
        setState(() => _galleryLocal.add(File(image.path)));
      }
    }
  }

  Future<void> _handleMainImagePick() async {
    final choice = await showImageSourceSheet(context);
    if (choice == ImageSourceChoice.camera) {
      await _pickMainImage(ImageSource.camera);
    } else if (choice == ImageSourceChoice.gallery) {
      await _pickMainImage(ImageSource.gallery);
    }
  }

  Future<void> _handleGalleryImagePick() async {
    final choice = await showImageSourceSheet(context);
    if (choice == ImageSourceChoice.camera) {
      await _pickGalleryImages(ImageSource.camera);
    } else if (choice == ImageSourceChoice.gallery) {
      await _pickGalleryImages(ImageSource.gallery);
    }
  }

  Future<bool> _deleteRemoteImageApi({
    required String adId,
    required String imageId,
  }) async {
    try {
      final token = AppSharedPreferences().getUserToken ?? AppSharedPreferences().userToken;
      if (token == null || token.trim().isEmpty) {
        if (mounted) {
          final appTrans = AppTranslations.of(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                appTrans?.text('auth.login_required_action') ?? 'Please login to perform this action',
              ),
            ),
          );
        }
        return false;
      }

      final headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final uri = Uri.parse('${ApiProvider.baseUrl}/api/v1/remove_technician_image');
      final request = http.MultipartRequest('POST', uri);
      request.fields.addAll({'ad_id': adId, 'image_id': imageId});
      request.headers.addAll(headers);

      final streamed = await request.send();
      return streamed.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<void> _confirmAndDeleteRemote(MediaItem mediaItem) async {
    if (widget.adId == null) return;

    final appTrans = AppTranslations.of(context);
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(appTrans?.text('common.confirm') ?? 'Confirm'),
        content: Text(
          appTrans?.text('photos.confirm_delete') ?? 'Are you sure you want to delete this photo?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(appTrans?.text('common.no') ?? 'No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(appTrans?.text('common.yes') ?? 'Yes'),
          ),
        ],
      ),
    );

    if (shouldDelete != true) return;

    setState(() => _deletingRemote.add(mediaItem.id));

    final success = await _deleteRemoteImageApi(
      adId: widget.adId!.toString(),
      imageId: mediaItem.id.toString(),
    );

    if (mounted) setState(() => _deletingRemote.remove(mediaItem.id));

    if (success) {
      await _refreshDetailsAfterDelete();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(appTrans?.text('photos.delete_success') ?? 'Photo deleted')),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(appTrans?.text('photos.delete_failed') ?? 'Failed to delete photo')),
        );
      }
    }
  }

  Future<void> _refreshDetailsAfterDelete() async {
    if (widget.adId == null) return;

    try {
      final cubit = context.read<TechnicianFormsCubit>();
      await cubit.fetchTechnicianDetails(widget.adId!);

      final details = cubit.loadedDetails;
      if (details != null && mounted) {
        setState(() {
          _galleryRemote
            ..clear()
            ..addAll(details.media);
          if (_mainImageFile == null) {
            _mainImageUrl = details.mainImageUrl;
          }
        });
      }
    } catch (e) {
      if (mounted) {
        final appTrans = AppTranslations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${appTrans?.text('error.data_refresh_failed') ?? 'Error refreshing data'}: ${e.toString()}'),
          ),
        );
      }
    }
  }

  Color _tagColor(int tag) {
    switch (tag % 6) {
      case 0: return const Color(0xFF2563EB);
      
      default: return const Color(0xFF0EA5E9);
    }
  }

  List<String> _validateFields(AppTranslations? appTrans) {
    final errors = <String>[];
    final name = _nameCtrl.text.trim();
    if (name.isEmpty || name.length < 3) errors.add('name');
    if (_selectedState == null) errors.add('state');
    if (_selectedCity == null) errors.add('city');
    if (_descCtrl.text.trim().isEmpty) errors.add('description');
    if (!_isEditing && _mainImageFile == null && _mainImageUrl == null) {
      errors.add('images');
    }
    return errors;
  }

  List<ReviewSection> _buildTechnicianReviewSections(AppTranslations? appTrans) {
    String dash(String? v) => (v == null || v.trim().isEmpty) ? '-' : v;

    final List<File> mainImageForReview = [];
    if (_mainImageFile != null) mainImageForReview.add(_mainImageFile!);

    final List<File> galleryImagesForReview = [..._galleryLocal];

    final sections = <ReviewSection>[
      ReviewSection(
        keyName: 'basics',
        title: appTrans?.text('review.basics_location') ?? 'المعلومات الأساسية والموقع',
        items: [
          ReviewItem(label: '${appTrans?.text('field.name') ?? 'Name'}:', value: dash(_nameCtrl.text)),
          ReviewItem(label: '${appTrans?.text('field.state') ?? 'Governorate'}:', value: _selectedState?.name ?? '-'),
          ReviewItem(label: '${appTrans?.text('field.city') ?? 'City'}:', value: _selectedCity?.name ?? '-'),
        ],
      ),
      ReviewSection(
        keyName: 'details',
        title: appTrans?.text('field.description') ?? 'الوصف',
        items: [
          ReviewItem(label: '${appTrans?.text('field.description') ?? 'Description'}:', value: dash(_descCtrl.text)),
        ],
      ),
    ];

    if (mainImageForReview.isNotEmpty) {
      sections.add(ReviewSection(
        keyName: 'main_photo',
        title: appTrans?.text('photos.main_image') ?? 'الصورة الرئيسية',
        items: const [],
        images: mainImageForReview,
      ));
    } else if (_mainImageUrl != null) {
      sections.add(ReviewSection(
        keyName: 'main_photo_info',
        title: '',
        items: [
          ReviewItem(
            label: appTrans?.text('photos.current_image') ?? 'الصورة الحالية',
            value: appTrans?.text('photos.image_exists') ?? 'موجودة على الخادم',
            icon: Icons.check_circle,
          ),
        ],
      ));
    }

    if (galleryImagesForReview.isNotEmpty) {
      sections.add(ReviewSection(
        keyName: 'gallery_photos',
        title: appTrans?.text('photos.gallery') ?? 'صور المعرض',
        items: const [],
        images: galleryImagesForReview,
      ));
    } else if (_galleryRemote.isNotEmpty) {
      sections.add(ReviewSection(
        keyName: 'gallery_info',
        title: '',
        items: [
          ReviewItem(
            label: '',
            value: '${_galleryRemote.length} ${appTrans?.text('photos.images_on_server') ?? 'صورة على الخادم'}',
            icon: Icons.photo_library,
          ),
        ],
      ));
    }

    return sections;
  }

  void _showFillAllFieldsSnack(AppTranslations? appTrans) {
    final msg = appTrans?.text('validation.fill_all_fields') ?? 'من فضلك أدخل جميع الحقول المطلوبة';

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.info_outline_rounded, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(child: Text(msg, style: const TextStyle(fontWeight: FontWeight.w700))),
            ],
          ),
          backgroundColor: AppColors.accentLight,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          duration: const Duration(seconds: 3),
        ),
      );
  }

  Future<void> _handleStateSelection(StateEntity state) async {
    final cubit = context.read<TechnicianFormsCubit>();
    setState(() {
      _selectedState = state;
      _selectedCity = null;
    });
    cubit.clearCities(); // Clear cached cities
    await cubit.fetchCities(state.id);
  }

  void _handleCitySelection(CityEntity city) {
    setState(() => _selectedCity = city);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _phone.dispose();
    _whatsapp.dispose();
    _galleryRemote.clear();
    _galleryLocal.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appTrans = AppTranslations.of(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage(Appimage.addAdDetails)),
        ),
        child: SafeArea(
          child: BlocConsumer<TechnicianFormsCubit, TechnicianFormsState>(
            listener: (context, state) {
              // Handle submission states
              if (state is AdSubmitted || state is AdUpdated) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      _isEditing
                          ? (appTrans?.text('success.ad_updated') ?? 'Ad updated successfully')
                          : (appTrans?.text('success.ad_created') ?? 'Ad created successfully'),
                    ),
                  ),
                );
                Navigator.pop(context);
              } else if (state is AdSubmissionError || state is AdUpdateError) {
                final errorMsg = state is AdSubmissionError ? state.message : (state as AdUpdateError).message;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(errorMsg)),
                );
              }
            },
            builder: (context, state) {
              final cubit = context.read<TechnicianFormsCubit>();
              
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const SizedBox(height: 12),
                  TechnicianFormHeader(
                    onBack: () => Navigator.pop(context),
                    appTrans: appTrans,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 30),
                      NameField(controller: _nameCtrl, appTrans: appTrans),
                      const SizedBox(height: 30),
                      StateSelector(
                        selectedState: _selectedState,
                        states: cubit.states,
                        appTrans: appTrans,
                        tagColor: _tagColor,
                        onStateSelected: _handleStateSelection,
                        onError: () async {
                          await cubit.fetchStates(forceRefresh: true);
                        },
                      ),
                      const SizedBox(height: 30),
                      CitySelector(
                        selectedCity: _selectedCity,
                        selectedState: _selectedState,
                        cities: cubit.cities,
                        appTrans: appTrans,
                        tagColor: _tagColor,
                        onCitySelected: _handleCitySelection,
                        onStateNotSelected: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(appTrans?.text('error.select_state_first') ?? 'Please select governorate first'),
                            ),
                          );
                        },
                        onError: () async {
                          if (_selectedState != null) {
                            await cubit.fetchCities(_selectedState!.id);
                          }
                        },
                      ),
                      const SizedBox(height: 30),
                      DescriptionField(controller: _descCtrl, appTrans: appTrans),
                      const SizedBox(height: 30),
                      MainImageTileWidget(
                        mainImageFile: _mainImageFile,
                        mainImageUrl: _mainImageUrl,
                        onImagePicked: _handleMainImagePick,
                        onRemove: () => setState(() => _mainImageFile = null),
                        appTrans: appTrans,
                      ),
                      const SizedBox(height: 20),
                      GalleryAddTile(
                        onAdd: _handleGalleryImagePick,
                        appTrans: appTrans,
                      ),
                      const SizedBox(height: 10),
                      GalleryGrid(
                        galleryRemote: _galleryRemote,
                        galleryLocal: _galleryLocal,
                        deletingRemote: _deletingRemote,
                        onDeleteRemote: _confirmAndDeleteRemote,
                        onDeleteLocal: (i) => setState(() => _galleryLocal.removeAt(i)),
                      ),
                      const SizedBox(height: 10),
                      CustomButton(
                        text: (state is SubmittingAd || state is UpdatingAd)
                            ? (appTrans?.text('action.sending') ?? 'Sending...')
                            : _isEditing
                                ? (appTrans?.text('action.save_changes') ?? 'Save Changes')
                                : (appTrans?.text('common.next') ?? 'Next'),
                        onTap: (state is SubmittingAd || state is UpdatingAd)
                            ? () {}
                            : () {
                                final errors = _validateFields(appTrans);
                                if (errors.isNotEmpty) {
                                  _showFillAllFieldsSnack(appTrans);
                                  return;
                                }
                                final sections = _buildTechnicianReviewSections(appTrans);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => GenericReviewScreen(
                                      pageTitle: _isEditing
                                          ? (appTrans?.text('review.technician_edit_page_title') ?? 'Review Ad Modification')
                                          : (appTrans?.text('review.technician_page_title') ?? 'Review Technician Ad'),
                                      sections: sections,
                                      requireAgreement: true,
                                      confirmLabel: _isEditing
                                          ? (appTrans?.text('action.confirm_save') ?? 'Confirm and Save')
                                          : (appTrans?.text('action.confirm_publish') ?? 'Confirm and Publish'),
                                      onConfirm: () async {
                                        Navigator.pop(context);
                                        await TechnicianAdService.submitAd(
                                          context: context,
                                          appTrans: appTrans,
                                          nameCtrl: _nameCtrl,
                                          descCtrl: _descCtrl,
                                          phoneCtrl: _phone,
                                          whatsappCtrl: _whatsapp,
                                          isEditing: _isEditing,
                                          adId: widget.adId,
                                          sectionId: widget.sectionID,
                                          categoryId: widget.categoryId,
                                          selectedState: _selectedState,
                                          selectedCity: _selectedCity,
                                          galleryLocal: _galleryLocal,
                                          mainImageFile: _mainImageFile,
                                          companyId: widget.companyId,
                                          companyTypeId: widget.companyTypeId,
                                          cubit: cubit,
                                          showFillAllFieldsSnack: () => _showFillAllFieldsSnack(appTrans),
                                          validateFields: () => _validateFields(appTrans),
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}