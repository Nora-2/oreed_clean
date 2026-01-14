import 'package:bloc/bloc.dart';
import 'package:oreed_clean/features/chooseplane/domain/usecases/get_package_by_type_usecase.dart';
import 'package:oreed_clean/features/chooseplane/presentation/cubit/chooseplane_state.dart';

class PackagesCubit extends Cubit<PackagesState> {
  final GetPackagesByTypeUseCase getPackagesByTypeUseCase;

  PackagesCubit(this.getPackagesByTypeUseCase) : super(const PackagesState());

  Future<void> fetchPackages(String type) async {
    // 1. Emit loading state
    emit(state.copyWith(status: PackagesStatus.loading));

    try {
      // 2. Call UseCase
      final packages = await getPackagesByTypeUseCase(type);
      
      // 3. Emit success state with data
      emit(state.copyWith(
        status: PackagesStatus.success,
        packages: packages,
      ));
    } catch (e) {
      // 4. Emit error state
      emit(state.copyWith(
        status: PackagesStatus.error,
        error: e.toString(),
      ));
    }
  }
}