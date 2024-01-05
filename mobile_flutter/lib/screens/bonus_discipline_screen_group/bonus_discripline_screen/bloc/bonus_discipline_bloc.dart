import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:firefly/data/arguments/common_argument.dart';
import 'package:firefly/data/enum_type/user_type.dart';
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
import 'package:firefly/utils/singleton.dart';

part 'bonus_discipline_event.dart';
part 'bonus_discipline_state.dart';

class BonusDisciplineBloc
    extends Bloc<BonusDisciplineEvent, BonusDisciplineState> {
  BonusDisciplineBloc({CommonArgument? commonArgument})
      : super(BonusDisciplineState(
          month: DateTime.now().lastDateOfMonth,
          organizationsList: commonArgument?.organizationsList,
          branchList: commonArgument?.branchList,
          departmentList: commonArgument?.departmentList,
          teamList: commonArgument?.teamList,
          selectedOrganization: commonArgument?.selectedOrganization,
          selectedBranch: commonArgument?.selectedBranch,
          selectedDepartment: commonArgument?.selectedDepartment,
          selectedTeam: commonArgument?.selectedTeam,
        )) {
    on<InitEvent>(_onInitEvent);
    on<GetBonusDisciplineEvent>(_onGetBonusDisciplineEvent);
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
    on<FilterByMonthEvent>(_onFilterByMonthEvent);
    on<ChangeTabEvent>(_onChangeTabEvent);
    on<CopyStateEvent>(_onCopyStateEvent);
  }
  final orgRepository = OrganizationRepository();
  final branchRepository = BranchOfficeRepository();
  final departmentRepository = DepartmentRepository();
  final teamRepository = TeamRepository();
  final bonusDisciplineRepository = BonusDisciplineRepository();
  final userWorkRepo = UserWorkRepository();

  void _onInitEvent(InitEvent event, Emitter<BonusDisciplineState> emit) async {
    final userType = Singleton.instance.userType;
    if (userType != UserType.ADMIN) {
      final userWork = Singleton.instance.userWork!;
      final org = userWork.organization;
      emit(
          state.copyWith(selectedOrganization: org, organizationsList: [org!]));
      if (userType == UserType.CEO) {
        add(GetBonusDisciplineEvent());
      } else {
        final userWork = Singleton.instance.userWork!;
        emit(
          state.copyWith(
            selectedUser: userWork,
          ),
        );
        add(GetBonusDisciplineEvent());
      }
    } else {
      try {
        final res = await orgRepository.getOrganization();
        emit(state.copyWith(
          status: FormzStatus.submissionSuccess,
          message: '',
          organizationsList: res?.data,
        ));
        if (res?.data != null && res!.data!.isNotEmpty) {
          emit(state.copyWith(selectedOrganization: res.data![0]));
          add(GetBonusDisciplineEvent());
        }
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

  void _onGetBonusDisciplineEvent(
      GetBonusDisciplineEvent event, Emitter<BonusDisciplineState> emit) async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress, message: ''));
    try {
      final param = GetRewardAndDisciplineParam(
        userId: state.selectedUser?.user?.id,
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
        rewardList: rewards,
        disciplineList: discipline,
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

  void _onGetOrganizationEvent(
      GetOrganizationEvent event, Emitter<BonusDisciplineState> emit) async {
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
      ChangeOrganizationEvent event, Emitter<BonusDisciplineState> emit) {
    if (state.selectedOrganization?.id != event.model.id) {
      emit(state.copyWith(
        selectedOrganization: event.model,
      ));
      add(GetBranchOfficeEvent());
    }
  }

  void _onGetBranchOfficeEvent(
      GetBranchOfficeEvent event, Emitter<BonusDisciplineState> emit) async {
    if (state.selectedOrganization != null &&
        state.selectedOrganization?.id != null) {
      emit(state.copyWith(
          status: FormzStatus.submissionInProgress, message: ''));
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
    } else {
      emit(
        state.copyWith(
          status: FormzStatus.submissionSuccess,
          message: '',
          branchList: [],
        ),
      );
    }
  }

  void _onChangeBranchOfficeEvent(
      ChangeBranchOfficeEvent event, Emitter<BonusDisciplineState> emit) async {
    emit(state.copyWith(selectedBranch: event.model));
    add(GetDepartmentEvent());
  }

  void _onGetDepartmentEvent(
      GetDepartmentEvent event, Emitter<BonusDisciplineState> emit) async {
    if (state.selectedBranch != null && state.selectedBranch?.id != null) {
      emit(state.copyWith(
          status: FormzStatus.submissionInProgress, message: ''));
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
    } else {
      emit(
        state.copyWith(
          status: FormzStatus.submissionSuccess,
          message: '',
          departmentList: [],
        ),
      );
    }
  }

  void _onChangeDepartmentEvent(
      ChangeDepartmentEvent event, Emitter<BonusDisciplineState> emit) {
    emit(state.copyWith(selectedDepartment: event.model));
    add(GetTeamEvent());
  }

  void _onChangeTeamEvent(
      ChangeTeamEvent event, Emitter<BonusDisciplineState> emit) async {
    emit(state.copyWith(selectedTeam: event.model));
  }

  void _onGetTeamEvent(
      GetTeamEvent event, Emitter<BonusDisciplineState> emit) async {
    if (state.selectedDepartment != null &&
        state.selectedDepartment?.id != null) {
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
    } else {
      emit(
        state.copyWith(
          status: FormzStatus.submissionSuccess,
          message: '',
          teamList: [],
        ),
      );
    }
  }

  void _onSearchUserEvent(
      SearchUserEvent event, Emitter<BonusDisciplineState> emit) async {
    if (event.text.isEmpty) return;
    emit(state.copyWith(
      status: FormzStatus.pure,
      message: '',
    ));
    try {
      final res = await userWorkRepo.searchUserWorkByName(name: event.text);
      emit(state.copyWith(
        status: FormzStatus.submissionSuccess,
        message: '',
        users: res?.data,
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
      SelectUserEvent event, Emitter<BonusDisciplineState> emit) async {
    if (state.selectedUser?.id != event.user.id) {
      emit(state.copyWith(selectedUser: event.user));
      add(GetBonusDisciplineEvent());
    }
  }

  void _onDeleteBonusEvent(
      DeleteBonusEvent event, Emitter<BonusDisciplineState> emit) async {
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

  Future<void> _onFilterByMonthEvent(
      FilterByMonthEvent event, Emitter<BonusDisciplineState> emit) async {
    if (state.month != event.month.lastDateOfMonth) {
      emit(state.copyWith(month: event.month.lastDateOfMonth));
      add(GetBonusDisciplineEvent());
    }
  }

  Future<void> _onChangeTabEvent(
      ChangeTabEvent event, Emitter<BonusDisciplineState> emit) async {
    emit(state.copyWith(isReward: event.isReward));
  }

  void _onCopyStateEvent(
      CopyStateEvent event, Emitter<BonusDisciplineState> emit) {
    emit(state.copyWith(
      organizationsList: event.arg.organizationsList,
      branchList: event.arg.branchList,
      departmentList: event.arg.departmentList,
      teamList: event.arg.teamList,
      selectedOrganization: event.arg.selectedOrganization?.id != null
          ? event.arg.selectedOrganization
          : OrganizationModel(),
      selectedBranch: event.arg.selectedBranch?.id != null
          ? event.arg.selectedBranch
          : BranchOfficeModel(),
      selectedDepartment: event.arg.selectedDepartment?.id != null
          ? event.arg.selectedDepartment
          : DepartmentModel(),
      selectedTeam: event.arg.selectedTeam?.id != null
          ? event.arg.selectedTeam
          : TeamModel(),
    ));
    add(GetBonusDisciplineEvent());
  }
}

extension BlocExt on BuildContext {
  BonusDisciplineBloc get bonusDisciplineBloc => read<BonusDisciplineBloc>();
}
