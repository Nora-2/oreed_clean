import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oreed_clean/features/dynamicfields/presentation/cubit/dynamicfields_state.dart';
import '../../domain/usecases/get_dynamic_fields_usecase.dart';

class DynamicFieldsCubit extends Cubit<DynamicFieldsState> {
  final GetDynamicFieldsUseCase getDynamicFieldsUseCase;

  DynamicFieldsCubit(this.getDynamicFieldsUseCase)
      : super(const DynamicFieldsState());

  Future<void> fetchDynamicFields(int sectionId) async {
    emit(state.copyWith(status: DynamicFieldsStatus.loading));

    try {
      final fields = await getDynamicFieldsUseCase(sectionId);

      emit(
        state.copyWith(
          status: DynamicFieldsStatus.success,
          fields: fields,
          error: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: DynamicFieldsStatus.error,
          error: e.toString(),
        ),
      );
    }
  }
}
