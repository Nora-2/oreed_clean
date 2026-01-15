import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'ads_state.dart';

class AdsCubit extends Cubit<AdsState> {
  AdsCubit() : super(AdsInitial());
}
