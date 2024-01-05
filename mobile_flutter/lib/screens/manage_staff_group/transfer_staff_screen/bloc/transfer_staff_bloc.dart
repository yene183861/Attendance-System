import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:firefly/data/arguments/transfer_staff_argument.dart';
import 'package:firefly/services/repository/user_work_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:firefly/data/enum_type/user_type.dart';
import 'package:firefly/data/enum_type/work_status.dart';
import 'package:firefly/data/model/branch_office_model.dart';
import 'package:firefly/data/model/department_model.dart';
import 'package:firefly/data/model/organization_model.dart';
import 'package:firefly/data/model/team_model.dart';
import 'package:firefly/data/model/user_work_model.dart';
import 'package:firefly/data/request_model/create_user_param.dart';
import 'package:firefly/services/api/barrel_api.dart';
import 'package:firefly/services/repository/branch_office_repository.dart';
import 'package:firefly/services/repository/department_repository.dart';
import 'package:firefly/services/repository/organization_repository.dart';
import 'package:firefly/services/repository/team_repository.dart';
import 'package:firefly/services/repository/user_repository.dart';

part 'transfer_staff_event.dart';
part 'transfer_staff_state.dart';

class TransferStaffBloc extends Bloc<TransferStaffEvent, TransferStaffState> {
  TransferStaffBloc({required TransferStaffArgument arg})
      : super(TransferStaffState(
          userType: arg.userWorkModel.user!.userType,
          organizationsList: arg.organizationsList,
          branchsList: arg.branchList,
          departmentsList: arg.departmentList,
          teamsList: arg.teamList,
          selectedOrganization: arg.userWorkModel.organization,
          selectedBranch: arg.userWorkModel.branchOffice,
          selectedDepartment: arg.userWorkModel.department,
          selectedTeam: arg.userWorkModel.team,
          userWorkModel: arg.userWorkModel,
        )) {
    on<InitTransferStaffEvent>(_onInitTransferStaffEvent);
    on<GetOrganizationEvent>(_onGetOrganizationEvent);
    on<ChangeOrganizationEvent>(_onChangeOrganizationEvent);
    on<GetBranchOfficeEvent>(_onGetBranchOfficeEvent);
    on<ChangeBranchOfficeEvent>(_onChangeBranchOfficeEvent);
    on<GetDepartmentEvent>(_onGetDepartmentEvent);
    on<ChangeDepartmentEvent>(_onChangeDepartmentEvent);
    on<GetTeamEvent>(_onGetTeamEvent);
    on<ChangeTeamEvent>(_onChangeTeamEvent);
    on<ChangeUserTypeEvent>(_onChangeUserTypeEvent);
    on<ChangeWorkStatusEvent>(_onChangeWorkStatusEvent);
    on<TransferUserWorkEvent>(_onTransferUserWorkEvent);
  }
  final orgRepo = OrganizationRepository();
  final branchRepo = BranchOfficeRepository();
  final departmentRepos = DepartmentRepository();
  final temRepos = TeamRepository();
  final userRepos = UserRepository();
  final userWorkRepos = UserWorkRepository();

  void _onInitTransferStaffEvent(
      InitTransferStaffEvent event, Emitter<TransferStaffState> emit) async {
    emit(state.copyWith(
      status: FormzStatus.submissionInProgress,
      message: '',
    ));
    try {
      add(GetOrganizationEvent());
      add(GetBranchOfficeEvent());
      add(GetDepartmentEvent());
      add(GetTeamEvent());
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
      GetOrganizationEvent event, Emitter<TransferStaffState> emit) async {
    emit(state.copyWith(
      status: FormzStatus.submissionInProgress,
      message: '',
    ));
    try {
      final res = await orgRepo.getOrganization();
      emit(state.copyWith(
        status: FormzStatus.submissionSuccess,
        organizationsList: res?.data,
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

  void _onChangeOrganizationEvent(
      ChangeOrganizationEvent event, Emitter<TransferStaffState> emit) {
    if (state.selectedOrganization != event.organizationModel) {
      emit(state.copyWith(
        selectedOrganization: event.organizationModel,
      ));
      add(GetBranchOfficeEvent());
    }
  }

  void _onGetBranchOfficeEvent(
      GetBranchOfficeEvent event, Emitter<TransferStaffState> emit) async {
    if (state.selectedOrganization != null) {
      emit(state.copyWith(
        status: FormzStatus.submissionInProgress,
        message: '',
      ));
      try {
        final res = await branchRepo.getBranches(
            organizationId: state.selectedOrganization!.id!);
        emit(state.copyWith(
          status: FormzStatus.submissionSuccess,
          message: '',
          branchsList: res?.data,
        ));
        final branchs = res?.data;
        if (branchs != null && branchs.isNotEmpty) {
          add(ChangeBranchOfficeEvent(branchOfficeModel: branchs[0]));
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

  void _onChangeBranchOfficeEvent(
      ChangeBranchOfficeEvent event, Emitter<TransferStaffState> emit) {
    emit(state.copyWith(
      selectedBranch: event.branchOfficeModel,
    ));
    add(GetDepartmentEvent());
  }

  void _onGetDepartmentEvent(
      GetDepartmentEvent event, Emitter<TransferStaffState> emit) async {
    if (state.selectedBranch != null) {
      emit(state.copyWith(
        status: FormzStatus.submissionInProgress,
        message: '',
      ));
      try {
        final res = await departmentRepos.getDepartments(
            branchId: state.selectedBranch!.id!);
        emit(state.copyWith(
          status: FormzStatus.submissionSuccess,
          message: '',
          departmentsList: res?.data,
        ));
        final department = res?.data;
        if (department != null && department.isNotEmpty) {
          add(ChangeDepartmentEvent(departmentModel: department[0]));
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

  void _onChangeDepartmentEvent(
      ChangeDepartmentEvent event, Emitter<TransferStaffState> emit) {
    emit(state.copyWith(
      selectedDepartment: event.departmentModel,
    ));
    add(GetTeamEvent());
  }

  void _onGetTeamEvent(
      GetTeamEvent event, Emitter<TransferStaffState> emit) async {
    if (state.selectedDepartment != null) {
      emit(state.copyWith(
        status: FormzStatus.submissionInProgress,
      ));
      try {
        final res = await temRepos.getTeams(
            departmentId: state.selectedDepartment!.id!);
        emit(state.copyWith(
          status: FormzStatus.submissionSuccess,
          message: '',
          teamsList: res?.data,
        ));
        if (res?.data != null && res!.data!.isNotEmpty) {
          add(ChangeTeamEvent(teamModel: res.data![0]));
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

  void _onChangeTeamEvent(
      ChangeTeamEvent event, Emitter<TransferStaffState> emit) {
    emit(state.copyWith(selectedTeam: event.teamModel));
  }

  void _onChangeUserTypeEvent(
      ChangeUserTypeEvent event, Emitter<TransferStaffState> emit) {
    emit(state.copyWith(userType: event.userType));
  }

  void _onChangeWorkStatusEvent(
      ChangeWorkStatusEvent event, Emitter<TransferStaffState> emit) {
    emit(state.copyWith(workStatus: event.workStatus));
  }

  void _onTransferUserWorkEvent(
      TransferUserWorkEvent event, Emitter<TransferStaffState> emit) async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress, message: ''));
    final userType = state.userType ?? UserType.STAFF;

    if (userType.type >= UserType.CEO.type) {
      if (state.selectedOrganization == null) {
        emit(state.copyWith(
            status: FormzStatus.submissionFailure,
            message: 'organization is required'));
        return;
      }
    }
    if (userType.type >= UserType.DIRECTOR.type) {
      if (state.selectedBranch == null) {
        emit(state.copyWith(
            status: FormzStatus.submissionFailure,
            message: 'branch_office is required'));
        return;
      }
    }
    if (userType.type >= UserType.MANAGER.type) {
      if (state.selectedDepartment == null) {
        emit(state.copyWith(
            status: FormzStatus.submissionFailure,
            message: 'department is required'));
        return;
      }
    }
    if (userType.type >= UserType.LEADER.type) {
      if (state.selectedTeam == null) {
        emit(state.copyWith(
            status: FormzStatus.submissionFailure,
            message: 'team is required'));
        return;
      }
    }
    try {
      final userType = state.userType!.type;
      final model = UserWorkModel(
        organization: state.selectedOrganization,
        branchOffice:
            userType >= UserType.DIRECTOR.type ? state.selectedBranch : null,
        department:
            userType >= UserType.MANAGER.type ? state.selectedDepartment : null,
        team: userType >= UserType.LEADER.type ? state.selectedTeam : null,
        userType: state.userType ?? UserType.STAFF,
        position: state.userType != UserType.STAFF
            ? state.userType?.value ?? ''
            : event.position,
        workStatus: state.workStatus ?? WorkStatus.WORKING,
      );

      await userWorkRepos.updateUserWork(
          model: model, id: state.userWorkModel.id!);
      emit(
        state.copyWith(
          status: FormzStatus.submissionSuccess,
          message: 'Điều chuyển nhân sự thành công'.tr(),
        ),
      );
    } on ErrorFromServer catch (e) {
      emit(state.copyWith(
          status: FormzStatus.submissionFailure, message: e.message));
    }
  }
}

extension BlocExt on BuildContext {
  TransferStaffBloc get transferStaffBloc => read<TransferStaffBloc>();
}
