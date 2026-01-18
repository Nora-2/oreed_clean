import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'forms_state.dart';

class FormsCubit extends Cubit<FormsState> {
  FormsCubit() : super(FormsInitial());
}
