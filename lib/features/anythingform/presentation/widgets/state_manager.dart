import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oreed_clean/features/anythingform/domain/entities/anything_details_entity.dart';
import 'package:oreed_clean/features/anythingform/presentation/cubit/create_anything_cubit.dart';
import 'package:oreed_clean/features/anythingform/presentation/cubit/create_anything_state.dart';

class AnythingFormStateManager {
  final titleCtrl = TextEditingController();
  final priceCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  
  int? selectedCountryId;
  int? selectedStateId;
  String? selectedCountryName;
  String? selectedStateName;

  File? mainImageFile;
  String? mainImageUrl;

  final List<MediaItem> galleryRemote = [];
  final List<File> galleryLocal = [];
  final Set<int> deletingRemote = {};

  bool isLoading = false;
  Map<String, dynamic> dynamicFieldValues = {};

  bool isEditing(int? adId) => adId != null;

  Map<String, dynamic> normalizeDynamicFields(dynamic raw) {
    if (raw == null) return {};
    if (raw is Map<String, dynamic>) return Map<String, dynamic>.from(raw);
    if (raw is Map) {
      return raw.map((k, v) => MapEntry(k.toString(), v));
    }
    if (raw is List) {
      if (raw.isEmpty) return {};
      return {'items': raw};
    }
    return {};
  }

  void handleBlocStateChange(BuildContext context, CreateAnythingState state) {
    if (state.loadedDetails != null && titleCtrl.text.isEmpty) {
      final d = state.loadedDetails!;
      titleCtrl.text = d.name;
      descCtrl.text = d.description;
      priceCtrl.text = d.price;
      selectedCountryId = d.stateId;
      selectedStateId = d.cityId;

      try {
        if (state.countries.isNotEmpty) {
          final found = state.countries.firstWhere(
            (c) => c.id == d.stateId,
          );
          selectedCountryName = found.name;
        } else {
          selectedCountryName = d.stateName;
        }
      } catch (_) {
        selectedCountryName = d.stateName;
      }

      if (state.states.isEmpty) {
        context.read<CreateAnythingCubit>().fetchStates(d.stateId);
      }
      try {
        if (state.states.isNotEmpty) {
          final foundState = state.states.firstWhere(
            (s) => s.id == d.cityId,
          );
          selectedStateName = foundState.name;
        } else {
          selectedStateName = d.cityName;
        }
      } catch (_) {
        selectedStateName = d.cityName;
      }

      dynamicFieldValues = normalizeDynamicFields(d.dynamicFields);
      if (mainImageFile == null) mainImageUrl = d.mainImage;
      galleryRemote.clear();
      galleryRemote.addAll(d.media);
    }
  }

  void dispose() {
    titleCtrl.dispose();
    priceCtrl.dispose();
    descCtrl.dispose();
    galleryRemote.clear();
    galleryLocal.clear();
  }
}
