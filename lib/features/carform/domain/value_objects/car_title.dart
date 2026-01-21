import 'package:meta/meta.dart';

@immutable
class CarTitle {
  const CarTitle(this.value);

  final String value;

  /// Returns the trimmed value.
  String get normalized => value.trim();

  /// Title must be at least 3 non-space characters.
  bool get isValid => normalized.length >= 3;

  @override
  String toString() => normalized;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is CarTitle && other.normalized == normalized);

  @override
  int get hashCode => normalized.hashCode;
}
