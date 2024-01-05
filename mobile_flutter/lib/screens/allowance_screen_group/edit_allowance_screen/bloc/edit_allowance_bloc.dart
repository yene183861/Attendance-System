import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import 'package:firefly/data/arguments/edit_allowance_arguments.dart';
import 'package:firefly/data/enum_type/by_time.dart';
import 'package:firefly/data/model/allowance_model.dart';

import 'package:firefly/services/api/barrel_api.dart';
import 'package:firefly/services/repository/allowance_repository.dart';

part 'edit_allowance_event.dart';
part 'edit_allowance_state.dart';

class EditAllowanceBloc extends Bloc<EditAllowanceEvent, EditAllowanceState> {
  EditAllowanceBloc(
      {EditAllowanceArgument? editAllowanceArgument, ByTime? byTime})
      : super(
          EditAllowanceState(
            status: FormzStatus.pure,
            editAllowanceArgument: editAllowanceArgument,
            byTime: byTime ?? ByTime.MONTH,
          ),
        ) {
    on<CreateAllowanceEvent>(_onCreateAllowanceEvent);
    on<UpdateAllowanceEvent>(_onUpdateAllowanceEvent);
    on<DeleteAllowanceEvent>(_onDeleteAllowanceEvent);
    on<SelectByTimeEvent>(_onSelectByTimeEvent);
  }
  final allowanceRepository = AllowanceRepository();

  void _onCreateAllowanceEvent(
      CreateAllowanceEvent event, Emitter<EditAllowanceState> emit) async {
    emit(state.copyWith(
      status: FormzStatus.submissionInProgress,
      message: '',
    ));
    try {
      await allowanceRepository.addAllowance(model: event.allowanceModel);
      print('DONE 1');
      emit(state.copyWith(
          status: FormzStatus.submissionSuccess,
          message: 'Thêm khoản phụ cấp thành công'.tr()));
    } on ErrorFromServer catch (e) {
      emit(
        state.copyWith(
          status: FormzStatus.submissionFailure,
          message: e.message,
        ),
      );
    }
  }

  void _onUpdateAllowanceEvent(
      UpdateAllowanceEvent event, Emitter<EditAllowanceState> emit) async {
    emit(state.copyWith(
      status: FormzStatus.submissionInProgress,
      message: '',
    ));
    try {
      await allowanceRepository.updateAllowance(
          model: event.allowanceModel,
          id: state.editAllowanceArgument!.allowanceModel!.id!);
      print('DONE');
      emit(state.copyWith(
          status: FormzStatus.submissionSuccess,
          message: 'Cập nhật thành công'.tr()));
    } on ErrorFromServer catch (e) {
      emit(
        state.copyWith(
          status: FormzStatus.submissionFailure,
          message: e.message,
        ),
      );
    }
  }

  void _onDeleteAllowanceEvent(
      DeleteAllowanceEvent event, Emitter<EditAllowanceState> emit) async {
    emit(state.copyWith(
      status: FormzStatus.submissionInProgress,
      message: '',
    ));
    try {
      await allowanceRepository.deleteAllowance(
          id: state.editAllowanceArgument!.allowanceModel!.id!);
      emit(
        state.copyWith(
          status: FormzStatus.submissionSuccess,
          message: 'Xóa khoản phụ cấp thành công'.tr(),
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

  void _onSelectByTimeEvent(
      SelectByTimeEvent event, Emitter<EditAllowanceState> emit) {
    emit(
      state.copyWith(byTime: event.byTime, message: ''),
    );
  }
}

extension BlocExt on BuildContext {
  EditAllowanceBloc get editAllowanceBloc => read<EditAllowanceBloc>();
}
