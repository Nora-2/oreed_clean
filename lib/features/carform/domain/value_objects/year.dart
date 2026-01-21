import 'package:meta/meta.dart';

@immutable
class Year {
  final int? value;
  const Year(this.value);

  bool get isValid {
    if (value == null) return true;
    return value! >= 1950 && value! <= DateTime.now().year + 1;
  }
}

