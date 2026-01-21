import 'package:meta/meta.dart';

@immutable
class EngineCc {
  final int? value;
  const EngineCc(this.value);

  bool get isValid => value == null || value! > 0;
}

