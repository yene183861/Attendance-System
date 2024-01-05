import 'package:equatable/equatable.dart';
import 'package:firefly/data/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import 'package:firefly/data/arguments/edit_allowance_arguments.dart';
import 'package:firefly/data/enum_type/by_time.dart';
import 'package:firefly/data/enum_type/user_type.dart';
import 'package:firefly/data/model/branch_office_model.dart';
import 'package:firefly/data/model/department_model.dart';
import 'package:firefly/data/model/organization_model.dart';
import 'package:firefly/data/model/team_model.dart';
import 'package:firefly/data/model/user_work_model.dart';
import 'package:firefly/data/request_param/get_user_param.dart';

import 'package:firefly/services/api/barrel_api.dart';
import 'package:firefly/services/repository/branch_office_repository.dart';
import 'package:firefly/services/repository/department_repository.dart';
import 'package:firefly/services/repository/organization_repository.dart';
import 'package:firefly/services/repository/team_repository.dart';
import 'package:firefly/services/repository/user_repository.dart';
import 'package:firefly/utils/singleton.dart';

part 'manage_staff_event.dart';
part 'manage_staff_state.dart';

class ManageStaffBloc extends Bloc<ManageStaffEvent, ManageStaffState> {
  ManageStaffBloc()
      : super(
          const ManageStaffState(
            status: FormzStatus.pure,
          ),
        ) {
    on<GetUserEvent>(_onGetUserEvent);
    on<InitEvent>(_onInitEvent);
    on<GetOrganizationEvent>(_onGetOrganizationEvent);
    on<ChangeOrganizationEvent>(_onChangeOrganizationEvent);
    on<GetBranchOfficeEvent>(_onGetBranchOfficeEvent);
    on<ChangeBranchOfficeEvent>(_onChangeBranchOfficeEvent);
    on<GetDepartmentEvent>(_onGetDepartmentEvent);
    on<ChangeDepartmentEvent>(_onChangeDepartmentEvent);
    on<GetTeamEvent>(_onGetTeamEvent);
    on<ChangeTeamEvent>(_onChangeTeamEvent);
    on<DeleteUserEvent>(_onDeleteUserEvent);
  }
  final userRepo = UserRepository();
  final orgRepo = OrganizationRepository();
  final branchRepo = BranchOfficeRepository();
  final departmentRepos = DepartmentRepository();
  final temRepos = TeamRepository();

  void _onGetUserEvent(
      GetUserEvent event, Emitter<ManageStaffState> emit) async {
    emit(state.copyWith(
      status: FormzStatus.submissionInProgress,
    ));
    try {
      final param = GetUserParam(
        organizationId: state.selectedOrganization?.id,
        branchOfficeId: state.selectedBranch?.id,
        departmentId: state.selectedDepartment?.id,
        teamId: state.selectedTeam?.id,
      );
      final res = await userRepo.getUsersWork(getUserParam: param);
      emit(state.copyWith(
        status: FormzStatus.submissionSuccess,
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

  void _onInitEvent(InitEvent event, Emitter<ManageStaffState> emit) async {
    emit(state.copyWith(
      status: FormzStatus.submissionInProgress,
      message: '',
    ));
    try {
      final userType = Singleton.instance.userType;
      if (userType == UserType.ADMIN) {
        final res = await orgRepo.getOrganization();
        emit(state.copyWith(
          status: FormzStatus.submissionSuccess,
          organizationsList: res?.data,
          message: '',
        ));
        if (res?.data != null && res!.data!.isNotEmpty) {
          add(ChangeOrganizationEvent(organizationModel: res.data![0]));
        }
      } else {
        final org = Singleton.instance.userWork!.organization!;
        emit(state.copyWith(organizationsList: [org]));
        if (userType == UserType.CEO) {
          add(
            ChangeOrganizationEvent(
                organizationModel: Singleton.instance.userWork!.organization!),
          );
        } else {
          emit(
            state.copyWith(selectedOrganization: org),
          );
          final branch = Singleton.instance.userWork!.branchOffice!;
          if (userType == UserType.DIRECTOR) {
            add(
              ChangeBranchOfficeEvent(branchOfficeModel: branch),
            );
          } else {
            emit(
              state.copyWith(selectedBranch: branch),
            );
            final department = Singleton.instance.userWork!.department!;
            if (userType == UserType.MANAGER) {
              add(
                ChangeDepartmentEvent(departmentModel: department),
              );
            } else {
              emit(
                state.copyWith(selectedDepartment: department),
              );
              final team = Singleton.instance.userWork!.team!;

              if (userType == UserType.LEADER) {
                add(
                  ChangeTeamEvent(teamModel: team),
                );
              }
            }
          }
        }
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

  void _onGetOrganizationEvent(
      GetOrganizationEvent event, Emitter<ManageStaffState> emit) async {
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
      ChangeOrganizationEvent event, Emitter<ManageStaffState> emit) {
    emit(state.copyWith(
      selectedOrganization: event.organizationModel,
    ));
    add(GetBranchOfficeEvent());
  }

  void _onGetBranchOfficeEvent(
      GetBranchOfficeEvent event, Emitter<ManageStaffState> emit) async {
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
          branchesList: res?.data,
        ));
        final branchs = res?.data;
        if (branchs != null && branchs.isNotEmpty) {
          add(ChangeBranchOfficeEvent(branchOfficeModel: branchs[0]));
        } else {
          emit(state.copyWith(
            status: FormzStatus.submissionSuccess,
            message: '',
            branchesList: [],
            selectedBranch: BranchOfficeModel(),
            selectedDepartment: DepartmentModel(),
            selectedTeam: TeamModel(),
            departmentsList: [],
            teamsList: [],
          ));
          add(GetUserEvent());
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
      ChangeBranchOfficeEvent event, Emitter<ManageStaffState> emit) {
    if (event.branchOfficeModel != null) {
      emit(state.copyWith(
        selectedBranch: event.branchOfficeModel,
      ));
      add(GetDepartmentEvent());
    } else {
      emit(state.copyWith(
        selectedBranch: BranchOfficeModel(),
        departmentsList: [],
        selectedDepartment: DepartmentModel(),
        teamsList: [],
        selectedTeam: TeamModel(),
      ));
      add(GetUserEvent());
    }
  }

  void _onGetDepartmentEvent(
      GetDepartmentEvent event, Emitter<ManageStaffState> emit) async {
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
        } else {
          emit(state.copyWith(
            status: FormzStatus.submissionSuccess,
            message: '',
            selectedDepartment: DepartmentModel(),
            selectedTeam: TeamModel(),
            departmentsList: [],
            teamsList: [],
          ));

          add(GetUserEvent());
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
      ChangeDepartmentEvent event, Emitter<ManageStaffState> emit) {
    if (event.departmentModel != null) {
      emit(state.copyWith(
        selectedDepartment: event.departmentModel!,
      ));
      add(GetTeamEvent());
    } else {
      emit(state.copyWith(
        selectedDepartment: DepartmentModel(),
        teamsList: [],
        selectedTeam: TeamModel(),
      ));
      add(GetUserEvent());
    }
  }

  void _onGetTeamEvent(
      GetTeamEvent event, Emitter<ManageStaffState> emit) async {
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
        } else {
          emit(state.copyWith(
            status: FormzStatus.submissionSuccess,
            message: '',
            selectedTeam: TeamModel(),
            teamsList: [],
          ));
          add(GetUserEvent());
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

  void _onDeleteUserEvent(
      DeleteUserEvent event, Emitter<ManageStaffState> emit) async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress, message: ''));
    try {
      await userRepo.deleteUser(id: event.user.id!);
      emit(
        state.copyWith(
            status: FormzStatus.submissionSuccess,
            message: 'Xóa thành công người dùng'),
      );
      add(GetUserEvent());
    } on ErrorFromServer catch (e) {
      emit(state.copyWith(
          status: FormzStatus.submissionFailure, message: e.message));
    }
  }

  void _onChangeTeamEvent(
      ChangeTeamEvent event, Emitter<ManageStaffState> emit) {
    if (event.teamModel != null) {
      emit(state.copyWith(
        selectedTeam: event.teamModel!,
      ));
    } else {
      emit(state.copyWith(
        selectedTeam: TeamModel(),
      ));
    }
    add(GetUserEvent());
  }

  // void _onUpdateAllowanceEvent(
  //     UpdateAllowanceEvent event, Emitter<ManageStaffState> emit) {
  //   emit(state.copyWith(
  //     status: FormzStatus.submissionInProgress,
  //   ));
  //   try {
  // final datas = [
  //   OrganizationModel(id: 1, name: 'Tổ chức 1'),
  //   OrganizationModel(id: 2, name: 'Tổ chức 2'),
  //   OrganizationModel(id: 3, name: 'Tổ chức 3'),
  //   OrganizationModel(id: 4, name: 'Tổ chức 4'),
  // ];
  // emit(state.copyWith(
  //   status: FormzStatus.submissionSuccess,
  //   organizationsList: datas,
  // ));
  // } on ErrorFromServer catch (e) {
  //   emit(
  //     state.copyWith(
  //       status: FormzStatus.submissionFailure,
  //       message: e.message,
  //     ),
  //   );
  // }
}

// void _onDeleteAllowanceEvent(
//     DeleteAllowanceEvent event, Emitter<ManageStaffState> emit) {}
// void _onSelectByTimeEvent(
//     SelectByTimeEvent event, Emitter<ManageStaffState> emit) {
//   emit(
//     state.copyWith(byTime: event.byTime),
//   );
// }
// }

extension BlocExt on BuildContext {
  ManageStaffBloc get manageStaffBloc => read<ManageStaffBloc>();
}
