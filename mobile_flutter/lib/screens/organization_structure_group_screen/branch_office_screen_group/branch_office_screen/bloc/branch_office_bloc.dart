import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:firefly/data/model/branch_office_model.dart';
import 'package:firefly/services/api/error_from_server.dart';
import 'package:firefly/services/repository/branch_office_repository.dart';

part 'branch_office_state.dart';
part 'branch_office_event.dart';

class BranchOfficeBloc extends Bloc<BranchOfficeEvent, BranchOfficeState> {
  BranchOfficeBloc({required int orgId})
      : super(BranchOfficeState(organizationId: orgId)) {
    on<GetBranchOfficeEvent>(_onGetBranchOfficeEvent);
    on<DeleteBranchOfficeEvent>(_onDeleteBranchOfficeEvent);
    on<UpdateBranchEvent>(_onUpdateBranchEvent);
    on<CreateBranchEvent>(_onCreateBranchEvent);
  }

  final branchRepo = BranchOfficeRepository();

  Future<void> _onGetBranchOfficeEvent(
      GetBranchOfficeEvent event, Emitter<BranchOfficeState> emit) async {
    emit(
      state.copyWith(
        status: FormzStatus.submissionInProgress,
        message: '',
      ),
    );
    try {
      final res =
          await branchRepo.getBranches(organizationId: state.organizationId);
      emit(
        state.copyWith(
          status: FormzStatus.submissionSuccess,
          branchesList: res?.data,
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

  Future<void> _onDeleteBranchOfficeEvent(
      DeleteBranchOfficeEvent event, Emitter<BranchOfficeState> emit) async {
    emit(
      state.copyWith(
        status: FormzStatus.submissionInProgress,
        message: '',
      ),
    );
    try {
      await branchRepo.deleteBranch(id: event.id);
      emit(
        state.copyWith(
          status: FormzStatus.submissionSuccess,
          message: 'msg_delete_branch_success'.tr(),
        ),
      );
      add(GetBranchOfficeEvent());
    } on ErrorFromServer catch (e) {
      emit(
        state.copyWith(
          status: FormzStatus.submissionFailure,
          message: e.message,
        ),
      );
    }
  }

  Future<void> _onCreateBranchEvent(
      CreateBranchEvent event, Emitter<BranchOfficeState> emit) async {
    emit(state.copyWith(
      status: FormzStatus.submissionInProgress,
      message: '',
    ));
    try {
      await branchRepo.addBranch(branchModel: event.branch);
      emit(
        state.copyWith(
            status: FormzStatus.submissionSuccess,
            message: 'msg_add_branch_success'.tr()),
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

  Future<void> _onUpdateBranchEvent(
      UpdateBranchEvent event, Emitter<BranchOfficeState> emit) async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress, message: ''));
    try {
      await branchRepo.updateBranch(
        branchModel: event.branch,
        id: event.id,
      );

      emit(
        state.copyWith(
            status: FormzStatus.submissionSuccess,
            message: 'msg_update_info_success'.tr()),
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
}

extension BlocExt on BuildContext {
  BranchOfficeBloc get branchOfficeBloc => read<BranchOfficeBloc>();
}
