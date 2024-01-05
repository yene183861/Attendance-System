import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:firefly/data/enum_type/gender.dart';
import 'package:firefly/data/request_param/update_profile_param.dart';
import 'package:firefly/services/api/error_from_server.dart';
import 'package:firefly/services/repository/user_repository.dart';

import 'package:firefly/services/repository/user_work_repository.dart';
import 'package:firefly/utils/session_manager.dart';
import 'package:firefly/utils/singleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

part 'update_profile_event.dart';
part 'update_profile_state.dart';

class UpdateProfileBloc extends Bloc<UpdateProfileEvent, UpdateProfileState> {
  UpdateProfileBloc()
      : super(
          UpdateProfileState(
            gender: Singleton.instance.userProfile?.gender ?? Gender.MALE,
            birthday: Singleton.instance.userProfile?.birthday,
            avatarPath: Singleton.instance.userProfile?.avatarThumb,
          ),
        ) {
    on<ChangeGender>(_onChangeGender);
    on<SaveProfileEvent>(_onSaveProfileEvent);
    on<ChangeBirthday>(_onChangeBirthday);
    on<ChangAvatarEvent>(_onChangAvatarEvent);
  }
  final userWorkRepo = UserWorkRepository();
  final userRepo = UserRepository();

  void _onChangeGender(
      ChangeGender event, Emitter<UpdateProfileState> emit) async {
    emit(state.copyWith(gender: event.gender));
  }

  void _onChangeBirthday(
      ChangeBirthday event, Emitter<UpdateProfileState> emit) async {
    emit(state.copyWith(birthday: event.birthday));
  }

  void _onChangAvatarEvent(
      ChangAvatarEvent event, Emitter<UpdateProfileState> emit) async {
    emit(state.copyWith(avatarSelected: event.avatarPath.path));
  }

  void _onSaveProfileEvent(
      SaveProfileEvent event, Emitter<UpdateProfileState> emit) async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress));

    try {
      final res = await userRepo.updateProfile(param: event.updateProfileParam);
      SessionManager.share.saveUserProfile(userProfile: res?.data);
      // SessionManager.share.saveToken(token: Singleton.instance.tokenLogin!);
      Singleton.instance.userProfile = res?.data;
      emit(state.copyWith(
          status: FormzStatus.submissionSuccess,
          message: 'Cập nhập thông tin cá nhân thành công'));
    } on ErrorFromServer catch (e) {
      emit(state.copyWith(
        status: FormzStatus.submissionFailure,
        message: e.message,
      ));
    }
  }
}

extension BlocExt on BuildContext {
  UpdateProfileBloc get updateProfileBloc => read<UpdateProfileBloc>();
}
