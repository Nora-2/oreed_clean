
import 'package:oreed_clean/features/carform/presentation/widgets/car_form_validator.dart';

import '../value_objects/car_title.dart';
import '../value_objects/price.dart';
import '../value_objects/year.dart';
import '../value_objects/kilometers.dart';
import '../value_objects/engine_cc.dart';

class ValidationResult {
  final bool isValid;
  final Map<String, String> errors;
  const ValidationResult(this.isValid, this.errors);
}

class ValidateCarFormUseCase {
  ValidationResult call({
    required CarTitle title,
    required Price price,
    required Year year,
    required Kilometers kilometers,
    required EngineCc engineCc,
  }) {
    final errors = CarFormValidator.validate(
      title: title,
      price: price,
      year: year,
      kilometers: kilometers,
      engineCc: engineCc,
    );
    return ValidationResult(errors.isEmpty, errors);
  }
}

