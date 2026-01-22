// car_form_ui.dart (Updated for Cubit)
// ignore_for_file: unused_field

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/core/utils/appicons/app_icons.dart';
import 'package:oreed_clean/core/utils/appimage/app_images.dart';
import 'package:oreed_clean/core/utils/bottomsheets/option_sheet_register_grid_model.dart';
import 'package:oreed_clean/core/utils/bottomsheets/option_sheet_register_list.dart';
import 'package:oreed_clean/core/utils/option_item_register.dart';
import 'package:oreed_clean/features/carform/data/models/brand.dart';
import 'package:oreed_clean/features/carform/data/models/carmodel.dart';
import 'package:oreed_clean/features/carform/domain/entities/brand_entity.dart';
import 'package:oreed_clean/features/carform/domain/entities/car_details_entity.dart';
import 'package:oreed_clean/features/carform/domain/entities/car_model_entity.dart';
import 'package:oreed_clean/features/carform/presentation/cubit/carform_cubit.dart';
import 'package:oreed_clean/features/carform/presentation/widgets/brand_picker_sheet.dart';
import 'package:oreed_clean/features/carform/presentation/widgets/car_form_helpers.dart';
import 'package:oreed_clean/features/carform/presentation/widgets/car_form_image_picker_mixin.dart';
import 'package:oreed_clean/features/carform/presentation/widgets/car_form_submission_mixin%20(1).dart';
import 'package:oreed_clean/features/carform/presentation/widgets/car_form_validation_mixin.dart';
import 'package:oreed_clean/features/carform/presentation/widgets/color_grid_sheet.dart';
import 'package:oreed_clean/features/carform/presentation/widgets/open_color_picker.dart';
import 'package:oreed_clean/features/carform/presentation/widgets/open_year_sheet.dart';
import 'package:oreed_clean/features/technicalforms/domain/entities/state_entity.dart';
import 'package:oreed_clean/features/technicalforms/domain/entities/city_entity.dart';
import '../widgets/car_form_header.dart';
import '../widgets/car_form_navigation.dart';
import '../widgets/car_form_step_one.dart';
import '../widgets/car_form_step_two.dart';
import '../widgets/car_form_step_three.dart';

class CarFormUI extends StatefulWidget {
  const CarFormUI({
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
  State<CarFormUI> createState() => _CarFormUIState();
}

class _CarFormUIState extends State<CarFormUI>
    with
        CarFormValidationMixin,
        CarFormImagePickerMixin,
        CarFormSubmissionMixin {
  final _titleCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _colorCtrl = TextEditingController();
  final _yearCtrl = TextEditingController();
  final _kmCtrl = TextEditingController();
  final _engineCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  final List<File> _images = [];
  final List<File> _certImages = [];
  File? _mainImage;
  String? _mainImageUrl;
  String? carDocuments;

  // Remote images from API (edit mode)
  List<String> _galleryUrls = [];
  List<int> _galleryIds = [];
  List<String> _certImageUrls = [];
  List<int> _certImageIds = [];

  // Scroll controller
  final _scrollController = ScrollController();

  // Selected values
  Brand? _brand;
  CarModel? _model;
  int? _brandIdSelected;
  int? _modelIdSelected;

  String? _condition;
  String? _fuel;
  String? _gear;
  String? _paint;
  String? _colorName;
  Color? _colorValue;
  String? _yearSelected;
  String? _engineCc;

  String? _governorateId;
  String? _cityId;
  StateEntity? _selectedState;
  CityEntity? _selectedCity;

  // Step management
  int _currentStep = 1;
  final int _totalSteps = 3;

  bool _isLoading = false;
  bool get _isEditing => widget.adId != null;

  // Cache lists from cubit states
  List<BrandEntity> _brands = [];
  List<CarModelEntity> _models = [];
  List<StateEntity> _states = [];
  List<CityEntity> _cities = [];

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  void _initializeForm() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final cubit = context.read<CarformCubit>();
      await Future.wait([
        cubit.fetchStates(),
        cubit.fetchBrands(widget.sectionId),
      ]);

      if (_isEditing) {
        await cubit.fetchCarDetails(widget.adId!);
      }
    });
  }

  void _handleStateUpdate(CarformState state) {
    if (state is CarformBrandsLoaded) {
      _brands = state.brands;
    } else if (state is CarformModelsLoaded) {
      _models = state.models;
    } else if (state is CarformStatesLoaded) {
      _states = state.states;
    } else if (state is CarformCitiesLoaded) {
      _cities = state.cities;
    } else if (state is CarformDetailsLoaded) {
      _loadEditModeData(state.details);
    }
  }

  void _loadEditModeData(CarDetailsEntity d) {
    _titleCtrl.text = d.titleAr;
    _descCtrl.text = d.descriptionAr;
    _priceCtrl.text = d.price;
    _kmCtrl.text = d.kilometers;
    _engineCtrl.text = d.engineSize;
    _yearCtrl.text = d.year;

    _colorName = d.color;
    _yearSelected = d.year;
    _engineCc = d.engineSize;
    _condition = d.condition;
    _fuel = d.fuelType.toLowerCase();
    _gear = d.transmission.toLowerCase();
    _paint = d.paintCondition;

    _brandIdSelected = d.brandId;
    _modelIdSelected = d.carModelId;

    // Load brand and model data
    final cubit = context.read<CarformCubit>();
    cubit.fetchBrands(d.sectionId);
    cubit.fetchModels(d.brandId);

    final brandEntity = _brands.firstWhere(
      (b) => b.id == d.brandId,
      orElse: () =>
          BrandEntity(id: d.brandId, name: d.brandId.toString(), image: ''),
    );
    _brand = Brand(
      id: brandEntity.id.toString(),
      name: brandEntity.name,
      imageUrl: brandEntity.image,
    );

    final modelEntity = _models.firstWhere(
      (m) => m.id == d.carModelId,
      orElse: () =>
          CarModelEntity(id: d.carModelId, name: d.carModelId.toString()),
    );
    _model = CarModel(id: modelEntity.id.toString(), name: modelEntity.name);

    _selectedState = StateEntity(id: d.stateId, name: d.stateName!);
    cubit.fetchCities(d.stateId);
    _selectedCity = CityEntity(id: d.cityId, name: d.cityName!);
    _governorateId = d.stateName ?? '';
    _cityId = d.cityName ?? '';

    _mainImageUrl = d.mainImageUrl;
    carDocuments = d.carDocuments;
    _galleryUrls = d.galleryImageUrls;
    _galleryIds = d.galleryImageIds;
    _certImageUrls = d.certImageUrls;
    _certImageIds = d.certImageIds;

    setState(() {});
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _priceCtrl.dispose();
    _colorCtrl.dispose();
    _yearCtrl.dispose();
    _kmCtrl.dispose();
    _engineCtrl.dispose();
    _descCtrl.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appTrans = AppTranslations.of(context);

    return BlocListener<CarformCubit, CarformState>(
      listener: (context, state) {
        _handleStateUpdate(state);

        if (state is CarformError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: BlocBuilder<CarformCubit, CarformState>(
        builder: (context, state) {
          final isModelsLoading = state is CarformModelsLoading;

          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              body: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(Appimage.addAdDetails),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    CarFormHeader(
                      currentStep: _currentStep,
                      totalSteps: _totalSteps,
                      onBack: () {
                        if (_currentStep > 1) {
                          setState(() => _currentStep--);
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      onStepTap: (step) {
                        if (step < _currentStep) {
                          setState(() => _currentStep = step);
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildStepTitle(appTrans),
                    Expanded(
                      child: _buildStepContent(isModelsLoading, appTrans),
                    ),
                  ],
                ),
              ),
              bottomNavigationBar: CarFormNavigation(
                currentStep: _currentStep,
                totalSteps: _totalSteps,
                isLoading: _isLoading,
                isEditing: _isEditing,
                onNext: () => _handleNavigation(appTrans),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStepTitle(AppTranslations? appTrans) {
    String title;
    switch (_currentStep) {
      case 1:
        title =
            appTrans?.text('page.enter_car_details') ?? 'Basic car information';
        break;
      case 2:
        title =
            appTrans?.text('page.car_specs_price') ??
            'Specifications and Price';
        break;
      default:
        title =
            appTrans?.text('page.car_desc_media') ?? 'Description and Media';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent(bool isModelsLoading, AppTranslations? appTrans) {
    return ListView(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      children: [
        if (_currentStep == 1) _buildStepOne(isModelsLoading, appTrans),
        if (_currentStep == 2) _buildStepTwo(appTrans),
        if (_currentStep == 3) _buildStepThree(appTrans),
      ],
    );
  }

  // Step builders with handler methods
  Widget _buildStepOne(bool isModelsLoading, AppTranslations? appTrans) {
    return CarFormStepOne(
      titleCtrl: _titleCtrl,
      brandName: _brand?.name,
      modelName: _model?.name,
      yearSelected: _yearSelected,
      colorName: _colorName,
      governorateId: _governorateId,
      cityId: _cityId,
      isLoadingModels: isModelsLoading,
      onTapBrand: _handleBrandSelection,
      onTapModel: () => _handleModelSelection(appTrans),
      onTapYear: _handleYearSelection,
      onTapColor: _handleColorSelection,
      onTapState: () => _handleStateSelection(appTrans),
      onTapCity: () => _handleCitySelection(appTrans),
    );
  }

  Widget _buildStepTwo(AppTranslations? appTrans) {
    return CarFormStepTwo(
      priceCtrl: _priceCtrl,
      kmCtrl: _kmCtrl,
      engineCc: _engineCc,
      gear: _gear,
      fuel: _fuel,
      condition: _condition,
      paint: _paint,
      onTapEngine: () => _handleEngineSelection(appTrans),
      onGearChanged: (val) => setState(() => _gear = val),
      onFuelChanged: (val) => setState(() => _fuel = val),
      onConditionChanged: (val) => setState(() => _condition = val),
      onPaintChanged: (val) => setState(() => _paint = val),
    );
  }

  Widget _buildStepThree(AppTranslations? appTrans) {
    return CarFormStepThree(
      descCtrl: _descCtrl,
      mainImage: _mainImage,
      mainImageUrl: _mainImageUrl,
      galleryUrls: _galleryUrls,
      galleryIds: _galleryIds,
      galleryImages: _images,
      certImageUrls: _certImageUrls,
      certImageIds: _certImageIds,
      certImages: _certImages,
      carDocumentsPlaceholder: carDocuments,
      onMainImagePick: _handleMainImagePick,
      onMainImageRemove: () => setState(() {
        _mainImage = null;
        _mainImageUrl = null;
      }),
      onGalleryPick: () =>
          chooseImageSourceAndPick(context: context, target: _images),
      onGalleryLocalRemove: (index) => setState(() => _images.removeAt(index)),
      onGalleryRemoteRemove: (index, imageId) =>
          _handleRemoteImageDelete(appTrans, index, imageId, isGallery: true),
      onCertPick: _handleCertImagePick,
      onCertRemove: () => setState(() => _certImages.clear()),
      onCertRemoteRemove: () => setState(() {
        _certImages.clear();
        _certImageUrls.clear();
        _certImageIds.clear();
      }),
    );
  }

  Future<void> _handleNavigation(AppTranslations? appTrans) async {
    if (_isLoading) return;

    if (_currentStep < _totalSteps) {
      final errors = validateCurrentStep(
        step: _currentStep,
        titleCtrl: _titleCtrl,
        priceCtrl: _priceCtrl,
        descCtrl: _descCtrl,
        brandIdSelected: _brandIdSelected,
        modelIdSelected: _modelIdSelected,
        selectedState: _selectedState,
        selectedCity: _selectedCity,
        mainImage: _mainImage,
        mainImageUrl: _mainImageUrl,
        isEditing: _isEditing,
      );

      if (errors.isNotEmpty) {
        showFillAllFieldsSnack(context, appTrans);
        return;
      }

      setState(() => _currentStep++);
      return;
    }

    // Validate all fields
    final errors = validateAllFields(
      titleCtrl: _titleCtrl,
      priceCtrl: _priceCtrl,
      brandIdSelected: _brandIdSelected,
      modelIdSelected: _modelIdSelected,
      selectedState: _selectedState,
      selectedCity: _selectedCity,
      mainImage: _mainImage,
      mainImageUrl: _mainImageUrl,
      images: _images,
    );

    if (errors.isNotEmpty && !_isEditing) {
      showFillAllFieldsSnack(context, appTrans);
      return;
    }

    // Check optional specs
    final hasSpecs = hasAnySpecsFilled(
      yearSelected: _yearSelected,
      kmCtrl: _kmCtrl,
      engineCc: _engineCc,
      condition: _condition,
      gear: _gear,
      fuel: _fuel,
      paint: _paint,
      colorName: _colorName,
    );

    final ok = await confirmOptionalSpecs(context, appTrans, hasSpecs);
    if (!ok) {
      setState(() => _currentStep = 2);
      return;
    }

    // Final submission
    await handleFinalSubmission(
      context: context,
      appTrans: appTrans,
      widget: widget,
      titleCtrl: _titleCtrl,
      priceCtrl: _priceCtrl,
      kmCtrl: _kmCtrl,
      descCtrl: _descCtrl,
      engineCtrl: _engineCtrl,
      brand: _brand,
      model: _model,
      brandIdSelected: _brandIdSelected,
      modelIdSelected: _modelIdSelected,
      selectedState: _selectedState,
      selectedCity: _selectedCity,
      condition: _condition,
      fuel: _fuel,
      gear: _gear,
      paint: _paint,
      colorName: _colorName,
      yearSelected: _yearSelected,
      engineCc: _engineCc,
      governorateId: _governorateId,
      cityId: _cityId,
      mainImage: _mainImage,
      mainImageUrl: _mainImageUrl,
      galleryUrls: _galleryUrls,
      galleryImages: _images,
      certImageUrls: _certImageUrls,
      certImages: _certImages,
      isEditing: _isEditing,

      setCurrentStep: (step) => setState(() => _currentStep = step),
    );
  }

  // ========== Handler Methods ==========

  Future<void> _handleBrandSelection() async {
    final cubit = context.read<CarformCubit>();
    final picked = await showBrandPickerSheet(
      context: context,
      loadBrands: () => _loadBrands(),
      accentColor: AppColors.primary,
      selectedId: _brand?.id,
    );

    if (picked != null) {
      final newBrandId = int.tryParse(picked.id);
      setState(() {
        _brand = picked;
        _model = null;
        _modelIdSelected = null;
        _brandIdSelected = newBrandId;
      });

      if (newBrandId != null) {
        cubit.clearModels();
        await cubit.fetchModels(newBrandId);
      }
    }
  }

  Future<List<Brand>> _loadBrands() async {
    if (_brands.isEmpty) {
      await Future.delayed(Duration.zero);
      final cubit = context.read<CarformCubit>();
      await cubit.fetchBrands(widget.sectionId);
    }

    return _brands
        .map((e) => Brand(id: e.id.toString(), name: e.name, imageUrl: e.image))
        .toList();
  }

  Future<void> _handleModelSelection(AppTranslations? appTrans) async {
    if (_brand == null || _brandIdSelected == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            appTrans?.text('select_brand_first') ?? 'Please select brand first',
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (_models.isEmpty) {
      final cubit = context.read<CarformCubit>();
      await cubit.fetchModels(_brandIdSelected!);
    }

    if (!mounted) return;

    if (_models.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            appTrans?.text('error.no_models') ??
                'No models available for this brand',
          ),
        ),
      );
      return;
    }

    final options = _models
        .map((m) => OptionItemregister(label: m.name, colorTag: 4))
        .toList();

    final pickedName = await showAppOptionSheetregistergridmodel(
      context: context,
      title: appTrans?.text('select.choose_model') ?? 'Select Model',
      subtitle:
          appTrans?.text('subtitle.select_model') ??
          'Select the model that fits your brand to complete details.',
      options: options,
      current: _model?.name,
    );

    if (!mounted || pickedName == null || pickedName.isEmpty) return;

    try {
      final selectedEntity = _models.firstWhere((e) => e.name == pickedName);

      setState(() {
        _model = CarModel(
          id: selectedEntity.id.toString(),
          name: selectedEntity.name,
        );
        _modelIdSelected = selectedEntity.id;
      });
    } catch (e) {
      debugPrint("Error finding model: $e");
    }
  }

  Future<void> _handleYearSelection() async {
    final selected = await openYearSheet(context, '2026');
    if (selected != null) {
      setState(() {
        _yearSelected = selected;
        _yearCtrl.text = selected;
      });
    }
  }

  Future<void> _handleColorSelection() async {
    final sections = colorsections(context);
    final result = await showColorGridSheet(
      context: context,
      sections: sections,
      currentId: '1',
    );

    if (result != null) {
      setState(() {
        _colorName = result.label;
        _colorValue = result.iconColor;
      });
    }
  }

  Future<void> _handleStateSelection(AppTranslations? appTrans) async {
    if (_states.isEmpty) {
      final cubit = context.read<CarformCubit>();
      await cubit.fetchStates();
    }

    final options = List.generate(_states.length, (i) {
      return OptionItemregister(
        label: _states[i].name,
        icon: AppIcons.locationCountry,
        colorTag: i,
      );
    });

    final chosen = await showAppOptionSheetregister(
      context: context,
      title: appTrans?.text('select.choose_state') ?? 'Select Governorate',
      hint: appTrans?.text('hint.search_state') ?? 'Search for governorate',
      subtitle:
          appTrans?.text('subtitle.select_state') ??
          'Select your governorate to show ads and services.',
      options: options,
      tagColor: CarFormHelpers.tagColor,
      current: _governorateId,
    );

    if (chosen != null) {
      final stateObj = _states.firstWhere(
        (s) => s.name == chosen,
        orElse: () => _states.first,
      );
      setState(() {
        _selectedState = stateObj;
        _governorateId = stateObj.name;
        _selectedCity = null;
        _cityId = null;
      });

      final cubit = context.read<CarformCubit>();
      await cubit.fetchCities(stateObj.id);
      if (mounted) setState(() {});
    }
  }

  Future<void> _handleCitySelection(AppTranslations? appTrans) async {
    if (_selectedState == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            appTrans?.text('error.select_state_first') ??
                'Please select governorate first',
          ),
        ),
      );
      return;
    }

    if (_cities.isEmpty) {
      final cubit = context.read<CarformCubit>();
      await cubit.fetchCities(_selectedState!.id);
    }

    if (_cities.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              appTrans?.text('error.no_cities_for_state') ??
                  'No cities available for this governorate',
            ),
          ),
        );
      }
      return;
    }

    final options = List.generate(_cities.length, (i) {
      return OptionItemregister(
        label: _cities[i].name,
        icon:AppIcons.location,
        colorTag: i,
      );
    });

    final chosen = await showAppOptionSheetregister(
      context: context,
      title: appTrans?.text('select.choose_city') ?? 'Select City',
      hint: appTrans?.text('hint.search_city') ?? 'Search for city',
      subtitle:
          appTrans?.text('subtitle.select_city') ??
          'Select your area to show ads and services.',
      options: options,
      tagColor: CarFormHelpers.tagColor,
      current: _cityId,
    );

    if (chosen != null) {
      final cityObj = _cities.firstWhere(
        (c) => c.name == chosen,
        orElse: () => _cities.first,
      );
      setState(() {
        _selectedCity = cityObj;
        _cityId = cityObj.name;
      });
    }
  }

  Future<void> _handleEngineSelection(AppTranslations? appTrans) async {
    final unit = appTrans?.text('unit_cc') ?? 'سي سي';
    final values = CarFormHelpers.getEngineCcValues();
    final labels = List<String>.from(values);
    final options = CarFormHelpers.toOptionItems(labels);
    final titleWithUnit =
        '${appTrans?.text('select.choose_engine') ?? 'Select Engine'} $unit';

    final chosen = await showAppOptionSheetregistergridmodel(
      context: context,
      title: titleWithUnit,
      options: options,
      current: _engineCc,
      subtitle:
          appTrans?.text('select.choose_engine_subtitel') ??
          'Engine size shows the car power for buyers.',
    );

    if (chosen != null) {
      setState(() {
        _engineCc = chosen;
        _engineCtrl.text = chosen;
      });
    }
  }

  Future<void> _handleMainImagePick() async {
    final file = await chooseImageSourceAndPickSingle(context);
    if (file != null) {
      setState(() {
        _mainImageUrl = null;
        _mainImage = file;
      });
    }
  }

  Future<void> _handleCertImagePick() async {
    await chooseImageSourceAndPick(
      context: context,
      target: _certImages,
      replaceCert: true,
    );

    if (_certImages.isNotEmpty &&
        _certImageIds.isNotEmpty &&
        widget.adId != null) {
      final id = _certImageIds.first;
      final cubit = context.read<CarformCubit>();
      await cubit.deleteAdImage(adId: widget.adId!, imageId: id);
      _applyLoadedDetailsFromCubit();
    }
  }

  Future<void> _handleRemoteImageDelete(
    AppTranslations? appTrans,
    int index,
    int imageId, {
    required bool isGallery,
  }) async {
    if (widget.adId == null) return;

    final cubit = context.read<CarformCubit>();
    final ok = await cubit.deleteAdImage(adId: widget.adId!, imageId: imageId);

    if (ok) {
      setState(() {
        if (isGallery) {
          _galleryUrls.removeAt(index);
          _galleryIds.removeAt(index);
        } else {
          _certImageUrls.removeAt(index);
          _certImageIds.removeAt(index);
        }
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              appTrans?.text('image_deleted') ?? 'تم حذف الصورة بنجاح',
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              appTrans?.text('error.delete_image') ?? 'فشل حذف الصورة',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _applyLoadedDetailsFromCubit() {
    final cubit = context.read<CarformCubit>();
    final state = cubit.state;

    if (state is CarformDetailsLoaded) {
      final d = state.details;
      setState(() {
        _mainImageUrl = d.mainImageUrl;
        _galleryUrls = d.galleryImageUrls;
        _galleryIds = d.galleryImageIds;
        _certImageUrls = d.certImageUrls;
        _certImageIds = d.certImageIds;
      });
    }
  }
}
