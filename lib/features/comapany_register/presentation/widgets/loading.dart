

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oreed_clean/features/comapany_register/presentation/cubit/comapany_register_cubit.dart';
import 'package:oreed_clean/features/comapany_register/presentation/cubit/comapany_register_state.dart';
import 'package:oreed_clean/features/login/presentation/cubit/login_cubit.dart';
import 'package:oreed_clean/features/login/presentation/cubit/login_state.dart';

class Loading extends StatelessWidget {
  const Loading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, auth) {
        return BlocBuilder<CompanyRegisterCubit, CompanyRegisterState>(
          builder: (context, reg) {
            if (auth.status == AuthStatus.loading ||
                reg.status == RegisterStatus.loading) {
              return Container(
                color: Colors.black12,
                child: const Center(child: CircularProgressIndicator()),
              );
            }
            return const SizedBox.shrink();
          },
        );
      },
    );
  }
}