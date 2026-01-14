import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:oreed_clean/features/addetails/domain/entities/ad_detiles_entity.dart';
import 'package:oreed_clean/features/addetails/domain/usecases/get_ad_detailes_usecase.dart';
part 'addetails_state.dart';

class AddetailsCubit extends Cubit<AddetailsState> {
  final GetAdDetailsUseCase getAdDetailsUseCase;

  AddetailsCubit(this.getAdDetailsUseCase) : super(AddetailsInitial());

  Future<void> fetchAd(int adId, int sectionId) async {
    emit(AddetailsLoading());

    try {
      final ad = await getAdDetailsUseCase(adId, sectionId);
      emit(AddetailsLoaded(ad));
    } catch (e, st) {
      log('❌ Failed to load ad: $e', stackTrace: st);
      emit(AddetailsError(e.toString()));
    }
  }
}
