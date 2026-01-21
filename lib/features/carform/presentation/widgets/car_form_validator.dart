import 'package:oreed_clean/features/carform/domain/value_objects/car_title.dart';
import 'package:oreed_clean/features/carform/domain/value_objects/engine_cc.dart';
import 'package:oreed_clean/features/carform/domain/value_objects/kilometers.dart';
import 'package:oreed_clean/features/carform/domain/value_objects/price.dart';
import 'package:oreed_clean/features/carform/domain/value_objects/year.dart';
class CarFormValidator {
  static const String kTitleRequired = 'car.title_required';
  static const String kPriceInvalid = 'car.price_invalid';
  static const String kYearInvalid = 'car.year_invalid';
  static const String kKmInvalid = 'car.km_invalid';
  static const String kEngineCcInvalid = 'car.engine_cc_invalid';

  // --- Local safe checks (do not depend on VO internal APIs) ---
  static bool _hasContent(Object o) => o.toString().trim().isNotEmpty;
  static bool _validNumber(Object o, {num min = 0, num? max}) {
    final s = o.toString().trim();
    final n = num.tryParse(s);
    if (n == null) return false;
    if (n < min) return false;
    if (max != null && n > max) return false;
    return true;
  }

  /// Classic validator (existing behavior preserved)
  static Map<String, String> validate({
    required CarTitle title,
    required Price price,
    required Year year,
    required Kilometers kilometers,
    required EngineCc engineCc,
  }) {
    final errors = <String, String>{};
    if (!_hasContent(title)) {
      errors['title'] = kTitleRequired;
    }
    if (!_validNumber(price, min: 0)) {
      errors['price'] = kPriceInvalid;
    }
    // Year: assume reasonable range 1900..currentYear
    final currentYear = DateTime.now().year;
    if (!_validNumber(year, min: 1900, max: currentYear)) {
      errors['year'] = kYearInvalid;
    }
    if (!_validNumber(kilometers, min: 0)) {
      errors['kilometers'] = kKmInvalid;
    }
    if (!_validNumber(engineCc, min: 0)) {
      errors['engineCc'] = kEngineCcInvalid;
    }
    return errors;
  }

  /// Step-aware validation to support multi-step forms.
  /// Step 1: title, price, year
  /// Step 2: kilometers, engineCc
  /// Step 3: (currently none; extend if needed)
  static Map<String, String> validateStep(
    int step, {
    required CarTitle title,
    required Price price,
    required Year year,
    required Kilometers kilometers,
    required EngineCc engineCc,
  }) {
    final errors = <String, String>{};
    final currentYear = DateTime.now().year;
    switch (step) {
      case 1:
        if (!_hasContent(title)) {
          errors['title'] = kTitleRequired;
        }
        if (!_validNumber(price, min: 0)) {
          errors['price'] = kPriceInvalid;
        }
        if (!_validNumber(year, min: 1900, max: currentYear)) {
          errors['year'] = kYearInvalid;
        }
        break;
      case 2:
        if (!_validNumber(kilometers, min: 0)) {
          errors['kilometers'] = kKmInvalid;
        }
        if (!_validNumber(engineCc, min: 0)) {
          errors['engineCc'] = kEngineCcInvalid;
        }
        break;
      case 3:
        // No mandatory fields for step 3 by default.
        // Add checks here if step 3 requires validation.
        break;
      default:
        // Fallback to full validation if an unknown step is provided.
        return validate(
          title: title,
          price: price,
          year: year,
          kilometers: kilometers,
          engineCc: engineCc,
        );
    }
    return errors;
  }

  /// Utility helper to check if the result has errors.
  static bool hasErrors(Map<String, String> errors) => errors.isNotEmpty;
}
