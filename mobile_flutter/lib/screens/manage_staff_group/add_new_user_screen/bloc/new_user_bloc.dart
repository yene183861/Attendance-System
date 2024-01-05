import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:formz/formz.dart';
import 'package:firefly/data/arguments/create_user_arguments.dart';
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
import 'package:firefly/utils/singleton.dart';

part 'new_user_event.dart';
part 'new_user_state.dart';

class NewUserBloc extends Bloc<NewUserEvent, NewUserState> {
  NewUserBloc()
      : super(NewUserState(
            userType: Singleton.instance.userType == UserType.ADMIN
                ? UserType.ADMIN
                : UserType.STAFF)) {
    on<InitNewUserEvent>(_onInitNewUserEvent);
    on<GetOrganizationEvent>(_onGetOrganizationEvent);
    on<ChangeOrganizationEvent>(_onChangeOrganizationEvent);
    on<GetBranchOfficeEvent>(_onGetBranchOfficeEvent);
    on<ChangeBranchOfficeEvent>(_onChangeBranchOfficeEvent);
    on<GetDepartmentEvent>(_onGetDepartmentEvent);
    on<ChangeDepartmentEvent>(_onChangeDepartmentEvent);
    on<GetTeamEvent>(_onGetTeamEvent);
    on<ChangeTeamEvent>(_onChangeTeamEvent);
    on<ChangeUserTypeEvent>(_onChangeUserTypeEvent);
    // on<ChangeWorkStatusEvent>(_onChangeWorkStatusEvent);
    on<CreateUserEvent>(_onCreateUserEvent);
    on<CheckValidEmailEvent>(_onCheckValidEmailEvent);
  }
  final orgRepo = OrganizationRepository();
  final branchRepo = BranchOfficeRepository();
  final departmentRepos = DepartmentRepository();
  final temRepos = TeamRepository();
  final userRepos = UserRepository();

  void _onInitNewUserEvent(
      InitNewUserEvent event, Emitter<NewUserState> emit) async {
    print('gggggg 1111');
    print(event.createUserArgument.team);
    print(event.createUserArgument.department);
    emit(state.copyWith(
      status: FormzStatus.submissionInProgress,
      message: '',
      selectedOrganization: event.createUserArgument.organization,
      selectedBranch: event.createUserArgument.branch,
      selectedDepartment: event.createUserArgument.department,
      selectedTeam: event.createUserArgument.team,
    ));
    try {
      final userType = Singleton.instance.userType;
      if (userType == UserType.ADMIN) {
        add(GetOrganizationEvent());
      }
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
    print('gggggg 1111333333');
    print(state.selectedTeam);
    print(state.selectedDepartment);
    // try {
    //   final userType = Singleton.instance.userType;
    //   if (userType == UserType.ADMIN) {
    //     final res = await orgRepo.getOrganization();
    //     emit(state.copyWith(
    //       status: FormzStatus.submissionSuccess,
    //       organizationsList: res?.data,
    //       message: '',
    //     ));
    //   } else {
    //     final org = Singleton.instance.userWork!.organization!;
    //     emit(state.copyWith(organizationsList: [org]));
    //     if (userType == UserType.CEO) {
    //       add(
    //         ChangeOrganizationEvent(
    //             organizationModel: Singleton.instance.userWork!.organization!),
    //       );
    //     } else {
    //       emit(
    //         state.copyWith(selectedOrganization: org),
    //       );
    //       final branch = Singleton.instance.userWork!.branchOffice!;
    //       if (userType == UserType.DIRECTOR) {
    //         add(
    //           ChangeBranchOfficeEvent(branchOfficeModel: branch),
    //         );
    //       } else {
    //         emit(
    //           state.copyWith(selectedBranch: branch),
    //         );
    //         final department = Singleton.instance.userWork!.department!;
    //         if (userType == UserType.MANAGER) {
    //           add(
    //             ChangeDepartmentEvent(departmentModel: department),
    //           );
    //         } else {
    //           emit(
    //             state.copyWith(selectedDepartment: department),
    //           );
    //           final team = Singleton.instance.userWork!.team!;
    //           if (userType == UserType.LEADER) {
    //             add(
    //               ChangeTeamEvent(teamModel: team),
    //             );
    //           }
    //         }
    //       }
    //     }
    //   }
    // } on ErrorFromServer catch (e) {
    //   emit(
    //     state.copyWith(
    //       status: FormzStatus.submissionFailure,
    //       message: e.message,
    //     ),
    //   );
    // }
  }

  void _onGetOrganizationEvent(
      GetOrganizationEvent event, Emitter<NewUserState> emit) async {
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
      ChangeOrganizationEvent event, Emitter<NewUserState> emit) {
    emit(state.copyWith(
      selectedOrganization: event.organizationModel,
    ));
    add(GetBranchOfficeEvent());
  }

  void _onGetBranchOfficeEvent(
      GetBranchOfficeEvent event, Emitter<NewUserState> emit) async {
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
        // final branchs = res?.data;
        // if (branchs != null && branchs.isNotEmpty) {
        //   add(ChangeBranchOfficeEvent(branchOfficeModel: branchs[0]));
        // }
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
      ChangeBranchOfficeEvent event, Emitter<NewUserState> emit) {
    emit(state.copyWith(
      selectedBranch: event.branchOfficeModel,
    ));
    add(GetDepartmentEvent());
  }

  void _onGetDepartmentEvent(
      GetDepartmentEvent event, Emitter<NewUserState> emit) async {
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
        // final department = res?.data;
        // if (department != null && department.isNotEmpty) {
        //   add(ChangeDepartmentEvent(departmentModel: department[0]));
        // }
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
      ChangeDepartmentEvent event, Emitter<NewUserState> emit) {
    emit(state.copyWith(
      selectedDepartment: event.departmentModel,
    ));
    add(GetTeamEvent());
  }

  void _onGetTeamEvent(GetTeamEvent event, Emitter<NewUserState> emit) async {
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
        // if (res?.data != null && res!.data!.isNotEmpty) {
        //   add(ChangeTeamEvent(teamModel: res.data![0]));
        // }
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

  void _onChangeTeamEvent(ChangeTeamEvent event, Emitter<NewUserState> emit) {
    emit(state.copyWith(selectedTeam: event.teamModel));
  }

  void _onChangeUserTypeEvent(
      ChangeUserTypeEvent event, Emitter<NewUserState> emit) {
    emit(state.copyWith(userType: event.userType));
  }

  // void _onChangeWorkStatusEvent(
  //     ChangeWorkStatusEvent event, Emitter<NewUserState> emit) {
  //   emit(state.copyWith(workStatus: event.workStatus));
  // }

  void _onCreateUserEvent(
      CreateUserEvent event, Emitter<NewUserState> emit) async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
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
    print('sssssssssssss');
    print(state.selectedTeam);
    print(state.selectedDepartment);
    try {
      final userWork = UserWorkModel(
        organization: state.selectedOrganization,
        branchOffice: state.selectedBranch,
        department: state.selectedDepartment,
        team: state.selectedTeam,
        userType: state.userType ?? UserType.STAFF,
        position: event.position ?? '',
        workStatus: WorkStatus.WORKING,
        reason: '',
      );

      final param = CreateUserModel(
          email: event.email,
          fullName: event.fullName,
          userType: state.userType ?? UserType.STAFF,
          userWork: state.userType == UserType.ADMIN ? null : userWork);
      await userRepos.createUser(model: param);
      emit(
        state.copyWith(
          status: FormzStatus.submissionSuccess,
          message: 'Tạo người dùng thành công'.tr(),
        ),
      );
    } on ErrorFromServer catch (e) {
      emit(state.copyWith(
          status: FormzStatus.submissionFailure, message: e.message));
    }
  }

  void _onCheckValidEmailEvent(
      CheckValidEmailEvent event, Emitter<NewUserState> emit) {
    emit(state.copyWith(isValidEmail: event.isValid));
  }
}

extension BlocExt on BuildContext {
  NewUserBloc get newUserBloc => read<NewUserBloc>();
}
