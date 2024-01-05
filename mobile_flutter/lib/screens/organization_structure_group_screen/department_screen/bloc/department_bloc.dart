import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import 'package:firefly/data/model/department_model.dart';
import 'package:firefly/services/api/error_from_server.dart';

import 'package:firefly/services/repository/department_repository.dart';

part 'department_state.dart';
part 'department_event.dart';

class DepartmentBloc extends Bloc<DepartmentEvent, DepartmentState> {
  DepartmentBloc({required int branchId})
      : super(DepartmentState(branchId: branchId)) {
    on<GetDepartmentEvent>(_onGetDepartmentEvent);
    on<DeleteDepartmentEvent>(_onDeleteDepartmentEvent);
    on<UpdateDepartmentEvent>(_onUpdateDepartmentEvent);
    on<CreateDepartmentEvent>(_onCreateDepartmentEvent);
  }

  final departmentRepo = DepartmentRepository();

  Future<void> _onGetDepartmentEvent(
      GetDepartmentEvent event, Emitter<DepartmentState> emit) async {
    emit(
      state.copyWith(
        status: FormzStatus.submissionInProgress,
        message: '',
      ),
    );
    try {
      final res = await departmentRepo.getDepartments(branchId: state.branchId);
      emit(
        state.copyWith(
          status: FormzStatus.submissionSuccess,
          departmentsList: res?.data,
          message: '',
        ),
      );
    } on ErrorFromServer catch (e) {
      emit(
        state.copyWith(
          status: FormzStatus.submissionFailure,
          message: e.message,
        ),
      );
    }
  }

  Future<void> _onDeleteDepartmentEvent(
      DeleteDepartmentEvent event, Emitter<DepartmentState> emit) async {
    emit(
      state.copyWith(
        status: FormzStatus.submissionInProgress,
        message: '',
      ),
    );
    try {
      await departmentRepo.deleteDepartment(id: event.id);
      emit(
        state.copyWith(
          status: FormzStatus.submissionSuccess,
          message: 'msg_delete_success'.tr(),
        ),
      );
    } on ErrorFromServer catch (e) {
      emit(
        state.copyWith(
          status: FormzStatus.submissionFailure,
          message: e.message,
        ),
      );
    }
  }

  Future<void> _onCreateDepartmentEvent(
      CreateDepartmentEvent event, Emitter<DepartmentState> emit) async {
    emit(state.copyWith(
      status: FormzStatus.submissionInProgress,
      message: '',
    ));
    try {
      await departmentRepo.addDepartment(
          model: DepartmentModel(
              branchOfficeId: state.branchId, name: event.name));
      emit(
        state.copyWith(
            status: FormzStatus.submissionSuccess,
            message: 'msg_add_department_success'.tr()),
      );
    } on ErrorFromServer catch (e) {
      emit(
        state.copyWith(
          status: FormzStatus.submissionFailure,
          message: e.message,
        ),
      );
    }
  }

  Future<void> _onUpdateDepartmentEvent(
      UpdateDepartmentEvent event, Emitter<DepartmentState> emit) async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress, message: ''));
    try {
      await departmentRepo.updateDepartment(
        model:
            DepartmentModel(branchOfficeId: state.branchId, name: event.name),
        id: event.id,
      );

      emit(
        state.copyWith(
            status: FormzStatus.submissionSuccess,
            message: 'msg_update_info_success'.tr()),
      );
      add(GetDepartmentEvent());
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
  DepartmentBloc get departmentBloc => read<DepartmentBloc>();
}
