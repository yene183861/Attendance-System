import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:firefly/services/api/error_from_server.dart';
import 'package:firefly/services/repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBloc() : super(const ForgotPasswordState()) {
    on<ChangeStateEmailEvent>(_onChangeStateEmailEvent);
    on<SubmitResetPassEvent>(_onSubmitResetPassEvent);
  }
  final authRepository = AuthRepository();

  void _onChangeStateEmailEvent(
      ChangeStateEmailEvent event, Emitter<ForgotPasswordState> emit) {
    emit(state.copyWith(isValidEmail: event.isValid, message: ''));
  }

  Future<void> _onSubmitResetPassEvent(
      SubmitResetPassEvent event, Emitter<ForgotPasswordState> emit) async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress, message: ''));

    try {
      final res = await authRepository.resetPassword(
        email: event.email,
      );

      emit(state.copyWith(
          status: FormzStatus.submissionSuccess, message: res.message));
    } on ErrorFromServer catch (e) {
      emit(state.copyWith(
        status: FormzStatus.submissionFailure,
        message: e.message ?? "please_try_again".tr(),
      ));
    }
  }
}

extension BlocExt on BuildContext {
  ForgotPasswordBloc get forgotPasswordBloc => read<ForgotPasswordBloc>();
}
