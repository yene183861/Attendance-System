import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:firefly/data/arguments/edit_branch_argument.dart';
import 'package:firefly/data/model/branch_office_model.dart';
import 'package:firefly/services/api/error_from_server.dart';
import 'package:firefly/services/repository/branch_office_repository.dart';

part 'edit_branch_office_state.dart';
part 'edit_branch_office_event.dart';

class EditBranchOfficeBloc
    extends Bloc<EditBranchEvent, EditBranchOfficeState> {
  EditBranchOfficeBloc({required EditBranchArgument arg})
      : super(EditBranchOfficeState(editBranchArgument: arg)) {
    on<CreateBranchEvent>(_onCreateBranchEvent);
    on<UpdateBranchEvent>(_onUpdateBranchEvent);
    on<DeleteBranchEvent>(_onDeleteBranchEvent);
  }

  final branchRep = BranchOfficeRepository();

  Future<void> _onCreateBranchEvent(
      CreateBranchEvent event, Emitter<EditBranchOfficeState> emit) async {
    emit(state.copyWith(
      status: FormzStatus.submissionInProgress,
      message: '',
    ));
    try {
      await branchRep.addBranch(branchModel: event.branch);
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
      UpdateBranchEvent event, Emitter<EditBranchOfficeState> emit) async {
    emit(state.copyWith(
      status: FormzStatus.submissionInProgress,
      message: '',
    ));
    try {
      await branchRep.updateBranch(
          branchModel: event.branch,
          id: state.editBranchArgument.branchModel!.id!);

      emit(
        state.copyWith(
          status: FormzStatus.submissionSuccess,
          message: 'msg_update_info_success'.tr(),
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

  Future<void> _onDeleteBranchEvent(
      DeleteBranchEvent event, Emitter<EditBranchOfficeState> emit) async {
    emit(state.copyWith(
      status: FormzStatus.submissionInProgress,
      message: '',
    ));
    try {
      await branchRep.deleteBranch(id: event.id);

      emit(
        state.copyWith(
          status: FormzStatus.submissionSuccess,
          message: 'msg_delete_branch_success'.tr(),
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
}

extension BlocExt on BuildContext {
  EditBranchOfficeBloc get editBranchOfficeBloc => read<EditBranchOfficeBloc>();
}
