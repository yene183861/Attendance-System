import 'package:equatable/equatable.dart';
import 'package:firefly/data/request_param/change_password_param.dart';
import 'package:firefly/services/repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import 'package:firefly/services/api/barrel_api.dart';

part 'change_password_event.dart';
part 'change_password_state.dart';

class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  ChangePasswordBloc() : super(const ChangePasswordState()) {
    on<SubmitPasswordEvent>(_onSubmitPasswordEvent);
  }
  final authRepo = AuthRepository();

  void _onSubmitPasswordEvent(
      SubmitPasswordEvent event, Emitter<ChangePasswordState> emit) async {
    emit(state.copyWith(
      status: FormzStatus.pure,
      message: '',
    ));
    try {
      await authRepo.changePassword(event.param);

      emit(state.copyWith(
        status: FormzStatus.submissionSuccess,
        message: 'Thay đổi mật khẩu thành công.\nVui lòng đăng nhập lại.',
      ));
    } on ErrorFromServer catch (e) {
      emit(
        state.copyWith(
          status: FormzStatus.submissionFailure,
          message: e.message,
        ),
      );
    }
  }
}

extension BlocExt on BuildContext {
  ChangePasswordBloc get changePasswordBloc => read<ChangePasswordBloc>();
}
