import 'dart:developer';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:firefly/services/api/error_from_server.dart';
import 'package:firefly/services/repository/face_repository.dart';

part 'attendance_face_event.dart';
part 'attendance_face_state.dart';

class AttendanceFaceBloc
    extends Bloc<AttendanceFaceEvent, AttendanceFaceState> {
  AttendanceFaceBloc() : super(const AttendanceFaceState()) {
    on<AttendanceByFaceEvent>(_onAttendanceByFaceEvent);
  }
  final faceRepo = FaceRepository();

  void _onAttendanceByFaceEvent(
      AttendanceByFaceEvent event, Emitter<AttendanceFaceState> emit) async {
    emit(state.copyWith(
      status: FormzStatus.pure,
      message: '',
    ));
    try {
      if (event.files != null && event.files!.isNotEmpty) {
        final res = await faceRepo.attendanceFace(files: event.files!);
        print('\n');
        log('${res?.data?.user.fullname}');
        emit(state.copyWith(
          status: FormzStatus.submissionSuccess,
          message: 'Chấm công thành công\n${res?.data?.user.fullname}',
        ));
      } else {
        emit(state.copyWith(
            status: FormzStatus.submissionFailure,
            message: 'Cần cung cấp gương mặt'));
      }
    } on ErrorFromServer catch (e) {
      emit(state.copyWith(
          status: FormzStatus.submissionFailure, message: e.message));
    }
  }
}

extension BlocExt on BuildContext {
  AttendanceFaceBloc get attendanceFaceBloc => read<AttendanceFaceBloc>();
}
