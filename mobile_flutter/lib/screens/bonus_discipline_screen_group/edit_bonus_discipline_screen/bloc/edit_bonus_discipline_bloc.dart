import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:firefly/data/arguments/edit_bonus_param.dart';
import 'package:firefly/data/model/branch_office_model.dart';
import 'package:firefly/data/model/department_model.dart';
import 'package:firefly/data/model/organization_model.dart';
import 'package:firefly/data/model/reward_discipline_model.dart';
import 'package:firefly/data/model/team_model.dart';
import 'package:firefly/data/model/user_work_model.dart';
import 'package:firefly/data/request_param/get_reward_and_discipline_param.dart';
import 'package:firefly/services/api/barrel_api.dart';
import 'package:firefly/services/repository/bonus_discipline_repository.dart';
import 'package:firefly/services/repository/branch_office_repository.dart';
import 'package:firefly/services/repository/department_repository.dart';
import 'package:firefly/services/repository/organization_repository.dart';
import 'package:firefly/services/repository/team_repository.dart';
import 'package:firefly/services/repository/user_work_repository.dart';
import 'package:firefly/utils/date_time_ext.dart';

part 'edit_bonus_discipline_event.dart';
part 'edit_bonus_discipline_state.dart';

class EditBonusDisciplineBloc
    extends Bloc<EditBonusDisciplineEvent, EditBonusDisciplineState> {
  EditBonusDisciplineBloc({required EditBonusArgument arg})
      : super(EditBonusDisciplineState(
          organizationsList: arg.organizationsList,
          branchList: arg.branchList,
          departmentList: arg.departmentList,
          teamList: arg.teamList,
          selectedOrganization: arg.selectedOrganization,
          selectedBranch: arg.selectedBranch,
          selectedDepartment: arg.selectedDepartment,
          selectedTeam: arg.selectedTeam,
          isReward: arg.isReward,
          rewardOrDisModel: arg.rewardOrDisModel,
          month: arg.rewardOrDisModel != null
              ? arg.rewardOrDisModel!.month
              : DateTime.now().lastDateOfMonth,
        )) {
    on<InitEvent>(_onInitEvent);
    on<GetEditBonusDisciplineEvent>(_onGetEditBonusDisciplineEvent);
    on<GetOrganizationEvent>(_onGetOrganizationEvent);
    on<ChangeOrganizationEvent>(_onChangeOrganizationEvent);
    on<GetBranchOfficeEvent>(_onGetBranchOfficeEvent);
    on<ChangeBranchOfficeEvent>(_onChangeBranchOfficeEvent);
    on<GetDepartmentEvent>(_onGetDepartmentEvent);
    on<ChangeDepartmentEvent>(_onChangeDepartmentEvent);
    on<GetTeamEvent>(_onGetTeamEvent);
    on<ChangeTeamEvent>(_onChangeTeamEvent);
    on<SearchUserEvent>(_onSearchUserEvent);
    on<DeleteBonusEvent>(_onDeleteBonusEvent);
    on<SelectUserEvent>(_onSelectUserEvent);
    on<AddBonusEvent>(_onAddBonusEvent);
    on<UpdateBonusEvent>(_onUpdateBonusEvent);
    on<ChangeMonthEvent>(_onChangeMonthEvent);
    on<ChangeUserList>(_onChangeUserList);
  }
  final orgRepository = OrganizationRepository();
  final branchRepository = BranchOfficeRepository();
  final departmentRepository = DepartmentRepository();
  final teamRepository = TeamRepository();
  final bonusDisciplineRepository = BonusDisciplineRepository();
  final userWorkRepo = UserWorkRepository();

  void _onInitEvent(
      InitEvent event, Emitter<EditBonusDisciplineState> emit) async {}

  void _onGetEditBonusDisciplineEvent(GetEditBonusDisciplineEvent event,
      Emitter<EditBonusDisciplineState> emit) async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress, message: ''));
    try {
      final param = GetRewardAndDisciplineParam(
        userId: state.selectedUser?.id,
        organizationId: state.selectedOrganization?.id,
        branchOfficeId: state.selectedBranch?.id,
        departmentId: state.selectedDepartment?.id,
        teamId: state.selectedTeam?.id,
        month: state.month,
      );
      final res =
          await bonusDisciplineRepository.getBonusOrDiscipline(param: param);
      List<RewardOrDisciplineModel> rewards = [];
      List<RewardOrDisciplineModel> discipline = [];

      res?.data?.forEach((element) {
        if (element.isReward) {
          rewards.add(element);
        } else {
          discipline.add(element);
        }
      });

      emit(state.copyWith(
        status: FormzStatus.submissionSuccess,
        message: '',
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

  void _onGetOrganizationEvent(GetOrganizationEvent event,
      Emitter<EditBonusDisciplineState> emit) async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress, message: ''));
    try {
      final res = await orgRepository.getOrganization();
      emit(state.copyWith(
        status: FormzStatus.submissionSuccess,
        message: '',
        organizationsList: res?.data,
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

  void _onChangeOrganizationEvent(
      ChangeOrganizationEvent event, Emitter<EditBonusDisciplineState> emit) {
    if (state.selectedOrganization?.id != event.model.id) {
      emit(state.copyWith(
        selectedOrganization: event.model,
      ));
      add(GetDepartmentEvent());
    }
  }

  void _onGetBranchOfficeEvent(GetBranchOfficeEvent event,
      Emitter<EditBonusDisciplineState> emit) async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress, message: ''));
    try {
      final res = await branchRepository.getBranches(
          organizationId: state.selectedOrganization!.id!);
      emit(
        state.copyWith(
          status: FormzStatus.submissionSuccess,
          message: '',
          branchList: res?.data,
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

  void _onChangeBranchOfficeEvent(
      ChangeBranchOfficeEvent event, Emitter<EditBonusDisciplineState> emit) {
    emit(state.copyWith(selectedBranch: event.model));
  }

  void _onGetDepartmentEvent(
      GetDepartmentEvent event, Emitter<EditBonusDisciplineState> emit) async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress, message: ''));
    try {
      final res = await departmentRepository.getDepartments(
          branchId: state.selectedBranch!.id!);
      emit(
        state.copyWith(
          status: FormzStatus.submissionSuccess,
          message: '',
          departmentList: res?.data,
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

  void _onChangeDepartmentEvent(
      ChangeDepartmentEvent event, Emitter<EditBonusDisciplineState> emit) {
    emit(state.copyWith(selectedDepartment: event.model));
  }

  void _onChangeTeamEvent(
      ChangeTeamEvent event, Emitter<EditBonusDisciplineState> emit) async {
    emit(state.copyWith(selectedTeam: event.model));
  }

  void _onGetTeamEvent(
      GetTeamEvent event, Emitter<EditBonusDisciplineState> emit) async {
    emit(state.copyWith(
      status: FormzStatus.submissionInProgress,
      message: '',
    ));
    try {
      final res = await teamRepository.getTeams(
          departmentId: state.selectedDepartment!.id!);
      emit(state.copyWith(
        status: FormzStatus.submissionSuccess,
        message: '',
        teamList: res?.data,
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

  void _onSearchUserEvent(
      SearchUserEvent event, Emitter<EditBonusDisciplineState> emit) async {
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
      SelectUserEvent event, Emitter<EditBonusDisciplineState> emit) async {
    if (state.selectedUser?.id != event.user.id) {
      emit(state.copyWith(selectedUser: event.user));
      add(GetEditBonusDisciplineEvent());
    }
  }

  void _onDeleteBonusEvent(
      DeleteBonusEvent event, Emitter<EditBonusDisciplineState> emit) async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress, message: ''));
    try {
      await bonusDisciplineRepository.deleteBonusOrDiscipline(id: event.id);
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

  void _onUpdateBonusEvent(
      UpdateBonusEvent event, Emitter<EditBonusDisciplineState> emit) async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress, message: ''));
    try {
      await bonusDisciplineRepository.updateBonusOrDiscipline(
          model: event.model, id: state.rewardOrDisModel!.id!);
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

  void _onAddBonusEvent(
      AddBonusEvent event, Emitter<EditBonusDisciplineState> emit) async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress, message: ''));
    try {
      await bonusDisciplineRepository.addBonusOrDiscipline(model: event.model);
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

  void _onChangeMonthEvent(
      ChangeMonthEvent event, Emitter<EditBonusDisciplineState> emit) async {
    emit(state.copyWith(month: event.month.lastDateOfMonth));
  }

  void _onChangeUserList(
      ChangeUserList event, Emitter<EditBonusDisciplineState> emit) async {
    emit(state.copyWith(users: event.users));
  }
}

extension BlocExt on BuildContext {
  EditBonusDisciplineBloc get editBonusDisciplineBloc =>
      read<EditBonusDisciplineBloc>();
}
