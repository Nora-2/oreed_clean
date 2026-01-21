import 'package:meta/meta.dart';

@immutable
class Price {
  final double value;
  const Price(this.value);

  bool get isValid => value >= 0;
}

