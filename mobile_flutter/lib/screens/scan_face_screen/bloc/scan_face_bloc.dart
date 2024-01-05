import 'dart:developer';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:firefly/data/model/user_model.dart';
import 'package:firefly/data/request_param/register_face_param.dart';
import 'package:firefly/services/api/error_from_server.dart';
import 'package:firefly/services/repository/face_repository.dart';

part 'scan_face_event.dart';
part 'scan_face_state.dart';

class ScanFaceBloc extends Bloc<ScanFaceEvent, ScanFaceState> {
  ScanFaceBloc({UserModel? user})
      : super(ScanFaceState(
          status: FormzStatus.pure,
          user: user,
        )) {
    on<RegisterFaceEvent>(_onRegisterFaceEvent);
  }
  final faceRepo = FaceRepository();

  void _onRegisterFaceEvent(
      RegisterFaceEvent event, Emitter<ScanFaceState> emit) async {
    emit(state.copyWith(
      status: FormzStatus.submissionInProgress,
      message: 'Đang tiến hành đăng ký với hệ thống, vui lòng chờ một chút',
    ));
    try {
      if (event.video != null) {
        log('sdsdsd: userId: ${state.user}');
        await faceRepo.registerFace(
            registerFaceParam: RegisterFaceParam(
                userId: state.user!.id!, videoFile: event.video!));
        // final user = res?.data?.user;/
        emit(state.copyWith(
          status: FormzStatus.submissionSuccess,
          message:
              '${state.user!.fullname} đã được đăng ký gương mặt thành công',
        ));
        log('ĐĂNG KÝ THÀNH CÔNG RỒI');
      } else {
        emit(state.copyWith(
          status: FormzStatus.submissionFailure,
          message: 'Quá trình xử lý xảy ra chút vấn đề, xin hãy thử lại!',
        ));
      }
    } on ErrorFromServer catch (e) {
      emit(state.copyWith(
          status: FormzStatus.submissionFailure, message: e.message));
    }
  }

  // void _onCheckUserEvent(
  //     CheckUserEvent event, Emitter<ScanFaceState> emit) async {
  //   emit(state.copyWith(
  //     status: FormzStatus.submissionInProgress,
  //     message: '',
  //   ));
  //   try {
  //     final res = await userRepo.searchUserWorkByEmail(email: event.email);
  //     emit(state.copyWith(
  //       status: FormzStatus.submissionSuccess,
  //       users: res?.data,
  //       message: '',
  //     ));
  //   } on ErrorFromServer catch (e) {
  //     emit(state.copyWith(
  //         status: FormzStatus.submissionFailure, message: e.message));
  //   }
  // }
}

extension BlocExt on BuildContext {
  ScanFaceBloc get scanFaceBloc => read<ScanFaceBloc>();
}
