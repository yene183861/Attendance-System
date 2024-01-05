import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:firefly/data/request_param/login_param.dart';
import 'package:firefly/services/api/error_from_server.dart';
import 'package:firefly/services/repository/auth_repository.dart';

import '../../../../utils/session_manager.dart';
import '../../../../utils/singleton.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc()
      : super(const LoginState(
          status: FormzStatus.pure,
        )) {
    on<ChangeStateEmailTextFieldEvent>(_changeStateEmailTextFieldEvent);
    on<SubmitLoginEvent>(_submitLoginToState);
  }
  final authRepository = AuthRepository();

  void _changeStateEmailTextFieldEvent(
      ChangeStateEmailTextFieldEvent event, Emitter<LoginState> emit) {
    emit(state.copyWith(
      isValidEmail: event.isValid,
      status: FormzStatus.pure,
    ));
  }

  Future<void> _submitLoginToState(
      SubmitLoginEvent event, Emitter<LoginState> emit) async {
    emit(state.copyWith(
      status: FormzStatus.submissionInProgress,
    ));
    try {
      final response = await authRepository.login(event.loginParams);

      Singleton.instance.tokenLogin = response?.token;
      Singleton.instance.userProfile = response?.user;
      Singleton.instance.userWork = response?.userWork;
      Singleton.instance.userType = response?.user.userType;

      await SessionManager.share.saveToken(token: response!.token);
      await SessionManager.share.saveUserProfile(userProfile: response.user);
      await SessionManager.share
          .saveOrganization(organizationModel: response.userWork?.organization);

      await SessionManager.share
          .saveBranchOffice(branchModel: response.userWork?.branchOffice);
      await SessionManager.share
          .saveDepartment(departmentModel: response.userWork?.department);
      await SessionManager.share.saveTeam(teamModel: response.userWork?.team);

      final t = await SessionManager.share.getOrganization();
      print(' qqqqqqqqqqqqqqq');
      log('$t');

      print('\n');

      emit(state.copyWith(
        status: FormzStatus.submissionSuccess,
      ));
    } on ErrorFromServer catch (e) {
      emit(state.copyWith(
        status: FormzStatus.submissionFailure,
        message: e.message ?? "please_try_again".tr(),
      ));
    }
  }
}

extension BlocExt on BuildContext {
  LoginBloc get loginBloc => read<LoginBloc>();
}
