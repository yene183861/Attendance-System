import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:firefly/data/arguments/edit_contract_argument.dart';
import 'package:firefly/data/enum_type/contract_type.dart';
import 'package:firefly/data/model/contract_model.dart';
import 'package:firefly/services/repository/contract_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import 'package:firefly/data/model/user_work_model.dart';

import 'package:firefly/services/api/barrel_api.dart';

import 'package:firefly/services/repository/user_work_repository.dart';

part 'edit_contract_event.dart';
part 'edit_contract_state.dart';

class EditContractBloc extends Bloc<EditContractEvent, EditContractState> {
  EditContractBloc({required EditContractArgument? arg})
      : super(EditContractState(
          startDate: arg?.contractModel != null
              ? arg!.contractModel!.startDate
              : DateTime.now(),
          endDate: arg?.contractModel != null
              ? arg!.contractModel!.endDate
              : DateTime.now().add(
                  const Duration(days: 60),
                ),
          signDate: arg?.contractModel != null
              ? arg!.contractModel!.signDate
              : DateTime.now(),
          contractModel: arg?.contractModel,
          selectedUser: arg?.selectedUser,
        )) {
    on<SearchUserEvent>(_onSearchUserEvent);
    on<SelectUserEvent>(_onSelectUserEvent);

    on<DeleteContractEvent>(_onDeleteContractEvent);
    on<AddContractEvent>(_onAddContractEvent);
    on<UpdateContractEvent>(_onUpdateContractEvent);

    // on<ChangeUserList>(_onChangeUserList);
    on<ChangeStartDateEvent>(_onChangeStartDateEvent);
    on<ChangeEndDateEvent>(_onChangeEndDateEvent);
    on<ChangeSignDateEvent>(_onChangeSignDateEvent);

    on<ChangeContractTypeEvent>(_onChangeContractTypeEvent);
  }
  final contractRepo = ContractRepository();
  final userWorkRepo = UserWorkRepository();

  void _onSearchUserEvent(
      SearchUserEvent event, Emitter<EditContractState> emit) async {
    emit(state.copyWith(
      status: FormzStatus.pure,
      message: '',
    ));
    try {
      if (event.text.isEmpty) {
        emit(state.copyWith(
          status: FormzStatus.submissionSuccess,
          message: '',
          users: [],
        ));
        return;
      }
      final res = await userWorkRepo.searchUserWorkByName(name: event.text);

      emit(state.copyWith(
        status: FormzStatus.submissionSuccess,
        message: '',
        users: res?.data ?? [],
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

  void _onSelectUserEvent(
      SelectUserEvent event, Emitter<EditContractState> emit) async {
    if (state.selectedUser?.id != event.user.id) {
      emit(state.copyWith(selectedUser: event.user));
    }
  }

  void _onDeleteContractEvent(
      DeleteContractEvent event, Emitter<EditContractState> emit) async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress, message: ''));
    try {
      await contractRepo.deleteContract(id: event.id);
      emit(state.copyWith(
        status: FormzStatus.submissionSuccess,
        message: 'delete_sucess',
      ));
    } on ErrorFromServer catch (e) {
      emit(state.copyWith(
        status: FormzStatus.submissionFailure,
        message: e.message ?? "please_try_again".tr(),
      ));
    }
  }

  void _onUpdateContractEvent(
      UpdateContractEvent event, Emitter<EditContractState> emit) async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress, message: ''));
    try {
      await contractRepo.updateContract(
          model: event.model, id: state.contractModel!.id!);
      emit(state.copyWith(
        status: FormzStatus.submissionSuccess,
        message: 'update_success',
      ));
    } on ErrorFromServer catch (e) {
      emit(state.copyWith(
        status: FormzStatus.submissionFailure,
        message: e.message ?? "please_try_again".tr(),
      ));
    }
  }

  void _onAddContractEvent(
      AddContractEvent event, Emitter<EditContractState> emit) async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress, message: ''));
    try {
      await contractRepo.addContract(model: event.model);
      emit(state.copyWith(
        status: FormzStatus.submissionSuccess,
        message: 'create_success',
      ));
    } on ErrorFromServer catch (e) {
      emit(state.copyWith(
        status: FormzStatus.submissionFailure,
        message: e.message ?? "please_try_again".tr(),
      ));
    }
  }

  void _onChangeStartDateEvent(
      ChangeStartDateEvent event, Emitter<EditContractState> emit) async {
    final startDate = event.startDate;

    if (state.contractType == ContractType.INDEFINITE_TERM_LABOR_CONTRACT) {
      emit(state.copyWith(startDate: startDate));
    } else {
      if (state.endDate == null || startDate.isAfter(state.endDate!)) {
        emit(
          state.copyWith(
            startDate: startDate,
            endDate: startDate.add(
              Duration(
                  days: state.contractType == ContractType.SEASONAL_CONTRACT
                      ? 60
                      : 365),
            ),
          ),
        );
      } else {
        final diff = state.endDate!.difference(startDate).inDays;

        if (state.contractType == ContractType.SEASONAL_CONTRACT) {
          if (diff < 60) {
            emit(
              state.copyWith(
                startDate: startDate,
                endDate: startDate.add(
                  const Duration(days: 60),
                ),
              ),
            );
          } else {
            emit(
              state.copyWith(startDate: startDate),
            );
          }
        } else {
          if (diff < 365) {
            emit(
              state.copyWith(
                startDate: startDate,
                endDate: startDate.add(
                  const Duration(days: 365),
                ),
              ),
            );
          } else if (diff > 1095) {
            emit(state.copyWith(
              startDate: startDate,
              endDate: startDate.add(
                const Duration(days: 1095),
              ),
            ));
          } else {
            emit(
              state.copyWith(startDate: startDate),
            );
          }
        }
      }
    }
    print('doneeeee 1');
  }

  void _onChangeEndDateEvent(
      ChangeEndDateEvent event, Emitter<EditContractState> emit) async {
    final endDate = event.endDate;
    emit(state.copyWith(status: FormzStatus.pure, message: ''));
    if (state.contractType != ContractType.INDEFINITE_TERM_LABOR_CONTRACT) {
      if (endDate.isBefore(state.startDate)) {
        emit(state.copyWith(
            status: FormzStatus.submissionFailure,
            message: 'Ngày kết thúc phải sau ngày bắt đầu'));
        return;
      }
      final dif = endDate.difference(state.startDate).inDays;

      if (state.contractType == ContractType.SEASONAL_CONTRACT &&
          (dif < 60 || dif > 365)) {
        emit(state.copyWith(
            status: FormzStatus.submissionFailure,
            message:
                'Hợp đồng thời vụ phải kéo dài ít nhất 2 tháng và nhiều nhất không quá 12 tháng'));
        return;
      }
      if (state.contractType == ContractType.FIXED_TERM_LABOR_CONTRACT &&
          (dif < 365 || dif > 1080)) {
        emit(state.copyWith(
            status: FormzStatus.submissionFailure,
            message:
                'Hợp đồng có thời hạn phải kéo dài ít nhất 1 năm và nhiều nhất không quá 3 năm'));
        return;
      }
    }
    print('doneeeee');
    emit(state.copyWith(
      status: FormzStatus.submissionSuccess,
      message: '',
      endDate: endDate,
    ));
  }

  void _onChangeContractTypeEvent(
      ChangeContractTypeEvent event, Emitter<EditContractState> emit) async {
    emit(state.copyWith(contractType: event.contractType));
    log('${state.contractType}');
  }

  void _onChangeSignDateEvent(
      ChangeSignDateEvent event, Emitter<EditContractState> emit) async {
    // emit(state.copyWith(users: event.users));
  }
}

extension BlocExt on BuildContext {
  EditContractBloc get editContractBloc => read<EditContractBloc>();
}
