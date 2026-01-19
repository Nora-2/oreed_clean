import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/features/realstateform/presentation/cubit/realstateform_cubit.dart';
import 'package:oreed_clean/features/realstateform/presentation/widgets/describtion_media_fields.dart';
import 'package:oreed_clean/features/realstateform/presentation/widgets/form_validator.dart';
import 'package:oreed_clean/features/realstateform/presentation/widgets/image_mannager.dart';
import 'package:oreed_clean/features/realstateform/presentation/widgets/step_indecator.dart';
import 'package:oreed_clean/features/realstateform/presentation/widgets/basic_info_fields.dart';
import 'package:oreed_clean/features/realstateform/presentation/widgets/navigation_buttons.dart';
import 'package:oreed_clean/features/realstateform/presentation/widgets/review_builder.dart';
import 'package:oreed_clean/features/realstateform/presentation/widgets/submission_handler_utility.dart';

class RealEstateFormUI extends StatefulWidget {
  const RealEstateFormUI({
    super.key,
    required this.sectionId,
    required this.categoryId,
    required this.supCategoryId,
    this.companyId,
    this.companyTypeId,
    this.adId,
  });

  final int sectionId;
  final int categoryId;
  final int supCategoryId;
  final int? companyId;
  final int? companyTypeId;
  final int? adId;

  @override
  State<RealEstateFormUI> createState() => _RealEstateFormUIState();
}

class _RealEstateFormUIState extends State<RealEstateFormUI> {
  // Controllers
  final _titleCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _areaCtrl = TextEditingController();

  // Form fields
  String? _rooms;
  String? _baths;
  String? _floor;
  String? _estateType;
  String? _countryId;
  String? _stateId;
  int? _selectedCountryId;
  int? _selectedStateId;

  // State
  bool _isLoading = false;
  int _currentStep = 1;
  static const int _totalSteps = 2;

  // Image management
  late final ImageManager _imageManager;
  late final FormValidator _validator;
  late final SubmissionHandler _submissionHandler;

  bool get _isEditing => widget.adId != null;

  @override
  void initState() {
    super.initState();
    _imageManager = ImageManager(
      onStateChanged: () => setState(() {}),
      isEditing: _isEditing,
      adId: widget.adId,
    );
    _validator = FormValidator(
      titleCtrl: _titleCtrl,
      priceCtrl: _priceCtrl,
      areaCtrl: _areaCtrl,
      descCtrl: _descCtrl,
      getRooms: () => _rooms,
      getBaths: () => _baths,
      getFloor: () => _floor,
      getCountryId: () => _selectedCountryId,
      getStateId: () => _selectedStateId,
      getMainImage: () => _imageManager.mainImage,
      getImages: () => _imageManager.images,
    );
    _submissionHandler = SubmissionHandler(
      widget: widget,
      titleCtrl: _titleCtrl,
      addressCtrl: _addressCtrl,
      priceCtrl: _priceCtrl,
      descCtrl: _descCtrl,
      areaCtrl: _areaCtrl,
      getRooms: () => _rooms,
      getBaths: () => _baths,
      getFloor: () => _floor,
      getEstateType: () => _estateType,
      getCountryId: () => _selectedCountryId,
      getStateId: () => _selectedStateId,
      getMainImage: () => _imageManager.mainImage,
      getImages: () => _imageManager.images,
      setLoading: (val) => setState(() => _isLoading = val),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final cubit = context.read<RealstateformCubit>();
      await cubit.fetchCountries();
      if (_isEditing) {
        await cubit.fetchPropertyDetails(widget.adId!);
      }
    });
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _addressCtrl.dispose();
    _priceCtrl.dispose();
    _descCtrl.dispose();
    _areaCtrl.dispose();
    super.dispose();
  }

  void _updateField(String field, String? value) {
    setState(() {
      switch (field) {
        case 'rooms':
          _rooms = value;
          break;
        case 'baths':
          _baths = value;
          break;
        case 'floor':
          _floor = value;
          break;
        case 'countryId':
          _countryId = value;
          break;
        case 'stateId':
          _stateId = value;
          break;
      }
    });
  }

  void _updateIds(String field, int? value) {
    setState(() {
      switch (field) {
        case 'countryId':
          _selectedCountryId = value;
          break;
        case 'stateId':
          _selectedStateId = value;
          break;
      }
    });
  }

  bool _isCurrentStepValid() {
    if (_currentStep == 1) {
      return _validator.validateStep1();
    }
    if (_currentStep == 2) {
      return _validator.validateStep2(_isEditing);
    }
    return true;
  }

  String _getStepTitle(AppTranslations? appTrans) {
    switch (_currentStep) {
      case 1:
        return appTrans?.text('page.enter_property_details') ?? 'أدخل تفاصيل العقار';
      case 2:
        return appTrans?.text('review.images') ?? 'الوصف والوسائط';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final appTrans = AppTranslations.of(context);

    return BlocConsumer<RealstateformCubit, RealstateformState>(
      listener: (context, state) {
        if (state is RealstateformCountriesLoaded) {
          _imageManager.cachedCountries = state.countries;
          setState(() {});
        }

        if (state is RealstateformStatesLoaded) {
          _imageManager.cachedStates = state.states;
          setState(() {});
        }

        if (state is RealstateformDetailsLoaded) {
          _loadPropertyDetails(state);
        }

        if (state is RealstateformSuccess) {
          _submissionHandler.handleSuccess(context, state);
        }

        if (state is RealstateformError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is RealstateformLoading ||
            state is RealstateformLoadingCountries ||
            state is RealstateformLoadingStates;

        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/add_ad_details.png'),
              ),
            ),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(appTrans),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      _getStepTitle(appTrans),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.start,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Expanded(
                    child: Stack(
                      children: [
                        _buildFormContent(appTrans),
                        if (_isLoading || isLoading)
                          Container(
                            color: Colors.black.withValues(alpha: 0.5),
                            alignment: Alignment.center,
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 4,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: NavigationButtons(
            currentStep: _currentStep,
            totalSteps: _totalSteps,
            isEditing: _isEditing,
            isValid: _isCurrentStepValid(),
            onNext: _handleNextStep,
          ),
        );
      },
    );
  }

  Widget _buildHeader(AppTranslations? appTrans) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xffe8e8e9),
                borderRadius: BorderRadius.circular(25),
              ),
              padding: const EdgeInsets.all(6),
              child: Icon(Icons.arrow_back, color: AppColors.primary, size: 24),
            ),
          ),
          const Spacer(),
          ...StepIndicator.buildIndicators(
            currentStep: _currentStep,
            totalSteps: _totalSteps,
            onStepTap: (step) => setState(() => _currentStep = step),
          ),
        ],
      ),
    );
  }

  Widget _buildFormContent(AppTranslations? appTrans) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      children: [
        if (_currentStep == 1)
          BasicInfoFields(
            titleCtrl: _titleCtrl,
            priceCtrl: _priceCtrl,
            areaCtrl: _areaCtrl,
            countryId: _countryId,
            stateId: _stateId,
            rooms: _rooms,
            baths: _baths,
            floor: _floor,
            selectedCountryId: _selectedCountryId,
            cachedCountries: _imageManager.cachedCountries,
            cachedStates: _imageManager.cachedStates,
            onFieldUpdate: _updateField,
            onIdUpdate: _updateIds,
          ),
        if (_currentStep == 2)
          DescriptionMediaFields(
            descCtrl: _descCtrl,
            imageManager: _imageManager,
          ),
        const SizedBox(height: 24),
      ],
    );
  }

  Future<void> _handleNextStep() async {
    final appTrans = AppTranslations.of(context);

    if (_currentStep < _totalSteps) {
      setState(() => _currentStep++);
      return;
    }

    final sections = ReviewBuilder.buildReviewSections(
      appTrans: appTrans,
      titleCtrl: _titleCtrl,
      priceCtrl: _priceCtrl,
      areaCtrl: _areaCtrl,
      descCtrl: _descCtrl,
      rooms: _rooms,
      baths: _baths,
      floor: _floor,
      countryId: _countryId,
      stateId: _stateId,
      mainImage: _imageManager.mainImage,
      images: _imageManager.images,
    );

    await _submissionHandler.handleReview(context, sections);
  }

  void _loadPropertyDetails(RealstateformDetailsLoaded state) {
    _titleCtrl.text = state.details.title;
    _descCtrl.text = state.details.description;
    _addressCtrl.text = state.details.address;
    _priceCtrl.text = state.details.price;
    _areaCtrl.text = state.details.area;
    _rooms = state.details.rooms;
    _baths = state.details.bathrooms;
    _floor = state.details.floor;
    _estateType = state.details.type == 'residential' ? 'سكني' : 'تجاري';
    _countryId = state.details.stateName;
    _stateId = state.details.cityName;
    _selectedCountryId = state.details.stateId;
    _selectedStateId = state.details.cityId;

    _imageManager.loadDetailsImages(state.details);
    setState(() {});
  }
}
