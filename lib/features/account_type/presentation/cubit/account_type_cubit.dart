import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'account_type_state.dart';

class AccountTypeCubit extends Cubit<AccountTypeState> {
  AccountTypeCubit() : super(AccountTypeInitial());
}
