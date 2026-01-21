import 'package:meta/meta.dart';

@immutable
class Kilometers {
  final int? value;
  const Kilometers(this.value);

  bool get isValid => (value ?? 0) >= 0;
}

