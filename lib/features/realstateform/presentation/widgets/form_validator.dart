// utils/form_validator.dart
import 'package:flutter/material.dart';
import 'package:oreed_clean/features/realstateform/data/models/properity_form_wizerd_state.dart';

class FormValidator {
  final TextEditingController titleCtrl;
  final TextEditingController priceCtrl;
  final TextEditingController areaCtrl;
  final TextEditingController descCtrl;
  final String? Function() getRooms;
  final String? Function() getBaths;
  final String? Function() getFloor;
  final int? Function() getCountryId;
  final int? Function() getStateId;
  final ImageSlot? Function() getMainImage;
  final List<ImageSlot> Function() getImages;

  FormValidator({
    required this.titleCtrl,
    required this.priceCtrl,
    required this.areaCtrl,
    required this.descCtrl,
    required this.getRooms,
    required this.getBaths,
    required this.getFloor,
    required this.getCountryId,
    required this.getStateId,
    required this.getMainImage,
    required this.getImages,
  });

  bool _isPositiveNumber(String? v) {
    if (v == null) return false;
    final t = v.trim();
    if (t.isEmpty) return false;
    final n = num.tryParse(t.replaceAll(',', ''));
    return n != null && n > 0;
  }

  bool validateStep1() {
    final okTitle = titleCtrl.text.trim().length >= 5;
    final okPrice = _isPositiveNumber(priceCtrl.text);
    final okCountry = getCountryId() != null;
    final okState = getStateId() != null;
    final okRooms = getRooms() != null && getRooms()!.trim().isNotEmpty;
    final okBaths = getBaths() != null && getBaths()!.trim().isNotEmpty;
    final area = int.tryParse(areaCtrl.text.trim());
    final okArea = area != null && area > 0;
    final okFloor = getFloor() != null && getFloor()!.trim().isNotEmpty;

    return okTitle &&
        okPrice &&
        okCountry &&
        okState &&
        okRooms &&
        okBaths &&
        okArea &&
        okFloor;
  }

  bool validateStep2(bool isEditing) {
    final okDesc = descCtrl.text.trim().length >= 20;
    final hasAnyImage =
        getMainImage()?.file != null ||
        getMainImage()?.url != null ||
        getImages().any((s) => s.file != null || s.url != null);
    return okDesc && (hasAnyImage || isEditing);
  }

  List<String> validateAllFields() {
    final errs = <String>[];

    if (titleCtrl.text.trim().isEmpty || titleCtrl.text.trim().length < 5) {
      errs.add('title');
    }
    if (!_isPositiveNumber(priceCtrl.text)) {
      errs.add('price');
    }

    if (getRooms() == null || getRooms()!.trim().isEmpty) errs.add('rooms');
    if (getBaths() == null || getBaths()!.trim().isEmpty) errs.add('baths');

    if (areaCtrl.text.trim().isEmpty) {
      errs.add('area');
    } else {
      final area = int.tryParse(areaCtrl.text.trim());
      if (area == null || area <= 0) errs.add('area');
    }

    if (getFloor() == null || getFloor()!.trim().isEmpty) errs.add('floor');

    if (descCtrl.text.trim().isEmpty) {
      errs.add('description');
    }

    if (getCountryId() == null) errs.add('country');
    if (getStateId() == null) errs.add('state');

    if (getMainImage()?.file == null && getImages().isEmpty) errs.add('images');

    return errs;
  }
}
