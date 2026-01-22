import 'package:equatable/equatable.dart';
import '../../domain/entities/dynamic_field_entity.dart';

enum DynamicFieldsStatus { idle, loading, success, error }

class DynamicFieldsState extends Equatable {
  final DynamicFieldsStatus status;
  final List<DynamicFieldEntity> fields;
  final String? error;

  const DynamicFieldsState({
    this.status = DynamicFieldsStatus.idle,
    this.fields = const [],
    this.error,
  });

  DynamicFieldsState copyWith({
    DynamicFieldsStatus? status,
    List<DynamicFieldEntity>? fields,
    String? error,
  }) {
    return DynamicFieldsState(
      status: status ?? this.status,
      fields: fields ?? this.fields,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, fields, error];
}
