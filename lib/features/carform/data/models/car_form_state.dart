import 'package:meta/meta.dart';
import '../../domain/value_objects/car_title.dart';
import '../../domain/value_objects/price.dart';
import '../../domain/value_objects/year.dart';
import '../../domain/value_objects/kilometers.dart';
import '../../domain/value_objects/engine_cc.dart';

@immutable
class CarFormState {
  final CarTitle title;
  final Price price;
  final Year year;
  final Kilometers kilometers;
  final EngineCc engineCc;
  final bool isSubmitting;

  const CarFormState({
    required this.title,
    required this.price,
    required this.year,
    required this.kilometers,
    required this.engineCc,
    this.isSubmitting = false,
  });

  CarFormState copyWith({
    CarTitle? title,
    Price? price,
    Year? year,
    Kilometers? kilometers,
    EngineCc? engineCc,
    bool? isSubmitting,
  }) {
    return CarFormState(
      title: title ?? this.title,
      price: price ?? this.price,
      year: year ?? this.year,
      kilometers: kilometers ?? this.kilometers,
      engineCc: engineCc ?? this.engineCc,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }

  static CarFormState initial() => CarFormState(
        title: CarTitle(''),
        price: const Price(0),
        year: const Year(null),
        kilometers: const Kilometers(null),
        engineCc: const EngineCc(null),
      );
}

