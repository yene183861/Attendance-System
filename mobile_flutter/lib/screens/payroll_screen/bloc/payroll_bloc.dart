import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:firefly/data/model/payroll_model.dart';
import 'package:firefly/data/request_param/get_payroll_param.dart';
import 'package:firefly/services/repository/payroll_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:firefly/data/enum_type/user_type.dart';
import 'package:firefly/data/model/branch_office_model.dart';
import 'package:firefly/data/model/department_model.dart';
import 'package:firefly/data/model/organization_model.dart';
import 'package:firefly/data/model/team_model.dart';
import 'package:firefly/data/model/user_work_model.dart';
import 'package:firefly/services/api/barrel_api.dart';
import 'package:firefly/services/repository/branch_office_repository.dart';
import 'package:firefly/services/repository/department_repository.dart';
import 'package:firefly/services/repository/organization_repository.dart';
import 'package:firefly/services/repository/team_repository.dart';
import 'package:firefly/services/repository/user_work_repository.dart';
import 'package:firefly/utils/date_time_ext.dart';
import 'package:firefly/utils/singleton.dart';
part 'payroll_event.dart';
part 'payroll_state.dart';

class PayrollBloc extends Bloc<PayrollEvent, PayrollState> {
  PayrollBloc()
      : super(PayrollState(
          // month: DateTime.now().lastDateOfMonth,
          // organizationsList: commonArgument?.organizationsList,
          // branchList: commonArgument?.branchList,
          // departmentList: commonArgument?.departmentList,
          // teamList: commonArgument?.teamList,
          // selectedOrganization: commonArgument?.selectedOrganization,
          // selectedBranch: commonArgument?.selectedBranch,
          // selectedDepartment: commonArgument?.selectedDepartment,
          // selectedTeam: commonArgument?.selectedTeam,
          month: DateTime.now().lastDateOfMonth,
        )) {
    on<InitEvent>(_onInitEvent);
    on<GetPayrollEvent>(_onGetPayrollEvent);
    on<GetOrganizationEvent>(_onGetOrganizationEvent);
    on<ChangeOrganizationEvent>(_onChangeOrganizationEvent);
    on<GetBranchOfficeEvent>(_onGetBranchOfficeEvent);
    on<ChangeBranchOfficeEvent>(_onChangeBranchOfficeEvent);
    on<GetDepartmentEvent>(_onGetDepartmentEvent);
    on<ChangeDepartmentEvent>(_onChangeDepartmentEvent);
    on<GetTeamEvent>(_onGetTeamEvent);
    on<ChangeTeamEvent>(_onChangeTeamEvent);
    on<SearchUserEvent>(_onSearchUserEvent);
    // on<DeleteBonusEvent>(_onDeleteBonusEvent);
    on<SelectUserEvent>(_onSelectUserEvent);
    on<FilterByMonthEvent>(_onFilterByMonthEvent);
    on<UpdatePayrollEvent>(_onUpdatePayrollEvent);
    on<CreatePayrollEvent>(_onCreatePayrollEvent);
  }
  final orgRepository = OrganizationRepository();
  final branchRepository = BranchOfficeRepository();
  final departmentRepository = DepartmentRepository();
  final teamRepository = TeamRepository();
  final payrollRepo = PayrollRepository();
  final userWorkRepo = UserWorkRepository();

  void _onInitEvent(InitEvent event, Emitter<PayrollState> emit) async {
    print('go herrr');
    final userType = Singleton.instance.userType;
    if (userType != UserType.ADMIN) {
      final userWork = Singleton.instance.userWork!;
      final org = userWork.organization;
      emit(
          state.copyWith(selectedOrganization: org, organizationsList: [org!]));
      if (userType == UserType.CEO) {
        add(GetPayrollEvent());
      } else {
        final userWork = Singleton.instance.userWork!;
        emit(
          state.copyWith(
            selectedUser: userWork,
          ),
        );
        add(GetPayrollEvent());

        // if (userType!.type < UserType.STAFF.type) {
        //   emit(
        //     state.copyWith(
        //       selectedBranch: userWork.branchOffice,
        //       selectedDepartment: userWork.department,
        //       selectedTeam: userWork.team,
        //     ),
        //   );
        //   add(GetDepartmentEvent());
        //   if (userType.type < UserType.LEADER.type) {
        //     add(GetDepartmentEvent());
        //   }
        //   if (userType.type < UserType.MANAGER.type) {
        //     add(GetBranchOfficeEvent());
        //   }
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
          add(GetPayrollEvent());
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

  void _onGetPayrollEvent(
      GetPayrollEvent event, Emitter<PayrollState> emit) async {
    print('go heeee');
    emit(state.copyWith(status: FormzStatus.submissionInProgress, message: ''));
    try {
      final param = GetPayrollParam(
        userId: state.selectedUser?.user?.id,
        organizationId: state.selectedOrganization?.id,
        branchOfficeId: state.selectedBranch?.id,
        departmentId: state.selectedDepartment?.id,
        teamId: state.selectedTeam?.id,
        month: state.month,
      );
      final res = await payrollRepo.getPayrolls(
        param: param,
      );

      emit(state.copyWith(
        status: FormzStatus.submissionSuccess,
        message: '',
        salaryList: res?.data,
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

  Future<void> _onCreatePayrollEvent(
      CreatePayrollEvent event, Emitter<PayrollState> emit) async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress, message: ''));
    try {
      final param = GetPayrollParam(
        userId: state.selectedUser?.user?.id,
        organizationId: state.selectedOrganization?.id,
        branchOfficeId: state.selectedBranch?.id,
        departmentId: state.selectedDepartment?.id,
        teamId: state.selectedTeam?.id,
        month: state.month,
      );
      final res = await payrollRepo.createPayroll(
        userId: state.selectedUser!.user!.id!,
        month: state.month ?? DateTime.now().lastDateOfMonth,
      );

      emit(state.copyWith(
        status: FormzStatus.submissionSuccess,
        message: 'Thành công',
      ));
      add(GetPayrollEvent());
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
      GetOrganizationEvent event, Emitter<PayrollState> emit) async {
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
      ChangeOrganizationEvent event, Emitter<PayrollState> emit) {
    if (state.selectedOrganization?.id != event.model.id) {
      emit(state.copyWith(
        selectedOrganization: event.model,
      ));
      add(GetBranchOfficeEvent());
    }
  }

  void _onGetBranchOfficeEvent(
      GetBranchOfficeEvent event, Emitter<PayrollState> emit) async {
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
      ChangeBranchOfficeEvent event, Emitter<PayrollState> emit) async {
    emit(state.copyWith(selectedBranch: event.model));
    add(GetDepartmentEvent());
  }

  void _onGetDepartmentEvent(
      GetDepartmentEvent event, Emitter<PayrollState> emit) async {
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
      ChangeDepartmentEvent event, Emitter<PayrollState> emit) {
    emit(state.copyWith(selectedDepartment: event.model));
    add(GetTeamEvent());
  }

  void _onChangeTeamEvent(
      ChangeTeamEvent event, Emitter<PayrollState> emit) async {
    emit(state.copyWith(selectedTeam: event.model));
  }

  void _onGetTeamEvent(GetTeamEvent event, Emitter<PayrollState> emit) async {
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
      SearchUserEvent event, Emitter<PayrollState> emit) async {
    if (event.text.isEmpty) return;
    emit(state.copyWith(
      status: FormzStatus.submissionInProgress,
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
      SelectUserEvent event, Emitter<PayrollState> emit) async {
    if (state.selectedUser?.id != event.user.id) {
      emit(state.copyWith(selectedUser: event.user));
      add(GetPayrollEvent());
    }
  }

  void _onUpdatePayrollEvent(
      UpdatePayrollEvent event, Emitter<PayrollState> emit) async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress, message: ''));
    try {
      // await bonusDisciplineRepository.deleteBonusOrDiscipline(id: event.id);
      // emit(state.copyWith(
      //   status: FormzStatus.submissionSuccess,
      //   message: 'delete_sucess',
      // ));
    } on ErrorFromServer catch (e) {
      emit(state.copyWith(
        status: FormzStatus.submissionFailure,
        message: e.message ?? "please_try_again".tr(),
      ));
    }
  }

  Future<void> _onFilterByMonthEvent(
      FilterByMonthEvent event, Emitter<PayrollState> emit) async {
    if (state.month != event.month.lastDateOfMonth) {
      emit(state.copyWith(month: event.month.lastDateOfMonth));
      add(GetPayrollEvent());
    }
  }

  // void _onCopyStateEvent(CopyStateEvent event, Emitter<PayrollState> emit) {
  //   emit(state.copyWith(
  //     organizationsList: event.arg.organizationsList,
  //     branchList: event.arg.branchList,
  //     departmentList: event.arg.departmentList,
  //     teamList: event.arg.teamList,
  //     selectedOrganization: event.arg.selectedOrganization?.id != null
  //         ? event.arg.selectedOrganization
  //         : OrganizationModel(),
  //     selectedBranch: event.arg.selectedBranch?.id != null
  //         ? event.arg.selectedBranch
  //         : BranchOfficeModel(),
  //     selectedDepartment: event.arg.selectedDepartment?.id != null
  //         ? event.arg.selectedDepartment
  //         : DepartmentModel(),
  //     selectedTeam: event.arg.selectedTeam?.id != null
  //         ? event.arg.selectedTeam
  //         : TeamModel(),
  //   ));
  //   add(GetPayrollEvent());
  // }
}

extension BlocExt on BuildContext {
  PayrollBloc get payrollBloc => read<PayrollBloc>();
}
