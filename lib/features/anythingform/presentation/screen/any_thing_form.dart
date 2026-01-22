// ignore_for_file: prefer_interpolation_to_compose_strings, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oreed_clean/core/utils/appimage/app_images.dart';
import 'package:oreed_clean/features/anythingform/presentation/widgets/form_body_widget.dart';
import 'package:oreed_clean/features/anythingform/presentation/widgets/form_validator.dart';
import 'package:oreed_clean/features/anythingform/presentation/widgets/image_picker_handler.dart';
import 'package:oreed_clean/features/anythingform/presentation/widgets/remote_image_deleter.dart';
import 'package:oreed_clean/features/anythingform/presentation/widgets/review_builder.dart';
import 'package:oreed_clean/features/anythingform/presentation/widgets/state_manager.dart';
import 'package:oreed_clean/features/anythingform/presentation/widgets/submit_handler.dart';
import '../cubit/create_anything_cubit.dart';
import '../cubit/create_anything_state.dart';
import 'package:oreed_clean/features/dynamicfields/presentation/cubit/dynamicfields_cubit.dart';
import 'package:oreed_clean/injection_container.dart';

class AnythingForm extends StatefulWidget {
  const AnythingForm({
    super.key,
    required this.sectionId,
    required this.categoryId,
    required this.supCategoryId,
    this.adId,
    this.companyId,
    this.companyTypeId,
  });

  final int sectionId;
  final int categoryId;
  final int supCategoryId;
  final int? adId;
  final int? companyId;
  final int? companyTypeId;

  @override
  State<AnythingForm> createState() => _AnythingFormState();
}

class _AnythingFormState extends State<AnythingForm> {
  late final AnythingFormStateManager _stateManager;
  late final AnythingImagePickerHandler _imagePickerHandler;
  late final AnythingRemoteImageDeleter _remoteImageDeleter;
  late final AnythingReviewBuilder _reviewBuilder;
  late final AnythingFormValidator _validator;
  late final AnythingSubmitHandler _submitHandler;

  @override
  void initState() {
    super.initState();
    _stateManager = AnythingFormStateManager();
    _imagePickerHandler = AnythingImagePickerHandler(
      stateManager: _stateManager,
      onUpdate: () => setState(() {}),
    );
    _remoteImageDeleter = AnythingRemoteImageDeleter(
      stateManager: _stateManager,
      onUpdate: () => setState(() {}),
    );
    _reviewBuilder = AnythingReviewBuilder(stateManager: _stateManager);
    _validator = AnythingFormValidator(stateManager: _stateManager);
    _submitHandler = AnythingSubmitHandler(
      stateManager: _stateManager,
      widget: widget,
      onLoadingChanged: (loading) => setState(() {}),
    );
  }

  @override
  void dispose() {
    _stateManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            final cubit = sl<CreateAnythingCubit>();
            cubit.fetchCountries();
            if (_stateManager.isEditing(widget.adId) && widget.adId != null) {
              cubit.loadDetails(widget.adId!, widget.sectionId);
            }
            return cubit;
          },
        ),
        BlocProvider(
          create: (context) => sl<DynamicFieldsCubit>(),
        ),
      ],
      child: BlocConsumer<CreateAnythingCubit, CreateAnythingState>(
        listener: (context, state) {
          _stateManager.handleBlocStateChange(context, state);
        },
        builder: (context, state) {
          return Scaffold(
            body: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(Appimage.addAdDetails),
                ),
              ),
              child: SafeArea(
                child: AnythingFormBody(
                  stateManager: _stateManager,
                  widget: widget,
                  imagePickerHandler: _imagePickerHandler,
                  remoteImageDeleter: _remoteImageDeleter,
                  reviewBuilder: _reviewBuilder,
                  validator: _validator,
                  submitHandler: _submitHandler,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
