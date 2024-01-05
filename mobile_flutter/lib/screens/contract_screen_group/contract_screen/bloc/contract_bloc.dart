import 'package:equatable/equatable.dart';
import 'package:firefly/data/arguments/common_argument.dart';
import 'package:firefly/data/enum_type/contract_status.dart';
import 'package:firefly/data/enum_type/contract_type.dart';
import 'package:firefly/data/enum_type/ticket_status.dart';
import 'package:firefly/data/enum_type/user_type.dart';
import 'package:firefly/data/model/branch_office_model.dart';
import 'package:firefly/data/model/contract_model.dart';
import 'package:firefly/data/model/department_model.dart';
import 'package:firefly/data/model/organization_model.dart';
import 'package:firefly/data/model/team_model.dart';
import 'package:firefly/data/model/user_work_model.dart';
import 'package:firefly/data/request_param/get_contract_param.dart';
import 'package:firefly/services/repository/branch_office_repository.dart';
import 'package:firefly/services/repository/contract_repository.dart';
import 'package:firefly/services/repository/department_repository.dart';
import 'package:firefly/services/repository/organization_repository.dart';
import 'package:firefly/services/repository/team_repository.dart';
import 'package:firefly/services/repository/user_work_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:firefly/data/request_param/login_param.dart';
import 'package:firefly/services/api/error_from_server.dart';

import '../../../../utils/singleton.dart';

part 'contract_event.dart';
part 'contract_state.dart';

class ContractBloc extends Bloc<ContractEvent, ContractState> {
  ContractBloc({CommonArgument? commonArgument})
      : super(
          ContractState(
            organizationsList: commonArgument?.organizationsList,
            branchList: commonArgument?.branchList,
            departmentList: commonArgument?.departmentList,
            teamList: commonArgument?.teamList,
            selectedOrganization: commonArgument?.selectedOrganization,
            selectedBranch: commonArgument?.selectedBranch,
            selectedDepartment: commonArgument?.selectedDepartment,
            selectedTeam: commonArgument?.selectedTeam,
            // endDate: DateTime.now(),
          ),
        ) {
    on<InitEvent>(_onInitEvent);
    on<GetContractEvent>(_onGetContractEvent);
    on<SearchUserWorkEvent>(_onSearchUserWorkEvent);
    on<SelectUserEvent>(_onSelectUserEvent);
    on<GetOrganizationEvent>(_onGetOrganizationEvent);
    on<ChangeOrganizationEvent>(_onChangeOrganizationEvent);
    on<GetBranchOfficeEvent>(_onGetBranchOfficeEvent);
    on<ChangeBranchOfficeEvent>(_onChangeBranchOfficeEvent);
    on<GetDepartmentEvent>(_onGetDepartmentEvent);
    on<ChangeDepartmentEvent>(_onChangeDepartmentEvent);
    on<GetTeamEvent>(_onGetTeamEvent);
    on<ChangeTeamEvent>(_onChangeTeamEvent);
    on<CopyStateEvent>(_onCopyStateEvent);
    on<FilterByDateEvent>(_onFilterByDateEvent);
    on<UpdateContractEvent>(_onUpdateContractEvent);
  }
  final userWorkRepo = UserWorkRepository();
  final orgRepository = OrganizationRepository();
  final branchRepository = BranchOfficeRepository();
  final departmentRepository = DepartmentRepository();
  final teamRepository = TeamRepository();
  final contractRepo = ContractRepository();

  void _onInitEvent(InitEvent event, Emitter<ContractState> emit) async {
    final userType = Singleton.instance.userType;
    if (userType != UserType.ADMIN) {
      final userWork = Singleton.instance.userWork!;
      final org = userWork.organization;
      emit(
          state.copyWith(selectedOrganization: org, organizationsList: [org!]));
      if (userType == UserType.CEO) {
        add(GetContractEvent());
      } else {
        final userWork = Singleton.instance.userWork!;
        emit(
          state.copyWith(
            selectedUser: userWork,
          ),
        );
        add(GetContractEvent());
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
          add(GetContractEvent());
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

  void _onGetContractEvent(
      GetContractEvent event, Emitter<ContractState> emit) async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress, message: ''));
    try {
      final param = GetContractParam(
        userId: state.selectedUser?.user?.id,
        organizationId: state.selectedOrganization?.id,
        branchOfficeId: state.selectedBranch?.id,
        departmentId: state.selectedDepartment?.id,
        teamId: state.selectedTeam?.id,
        contractType: state.contractType,
        state: state.contractStatus,
        status: state.contractState,
        startDate: state.startDate,
        endDate: state.endDate,
      );
      final res = await contractRepo.getContract(getContractParam: param);

      emit(state.copyWith(
        status: FormzStatus.submissionSuccess,
        message: '',
        contractsList: res?.data,
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

  void _onSearchUserWorkEvent(
      SearchUserWorkEvent event, Emitter<ContractState> emit) async {
    if (event.name.isNotEmpty) {
      emit(state.copyWith(
        status: FormzStatus.pure,
        message: '',
      ));
      try {
        final res = await userWorkRepo.searchUserWorkByName(name: event.name);
        emit(state.copyWith(
          status: FormzStatus.submissionSuccess,
          users: res?.data,
          message: '',
        ));
      } on ErrorFromServer catch (e) {
        emit(state.copyWith(
            status: FormzStatus.submissionFailure, message: e.message));
      }
    } else {
      emit(state.copyWith(
        users: [],
      ));
    }
  }

  void _onSelectUserEvent(
      SelectUserEvent event, Emitter<ContractState> emit) async {
    if (state.selectedUser?.id != event.user.id) {
      emit(state.copyWith(selectedUser: event.user));
      add(GetContractEvent());
    }
  }

  void _onGetOrganizationEvent(
      GetOrganizationEvent event, Emitter<ContractState> emit) async {
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
      ChangeOrganizationEvent event, Emitter<ContractState> emit) {
    if (state.selectedOrganization?.id != event.model.id) {
      emit(state.copyWith(
        selectedOrganization: event.model,
      ));
      add(GetBranchOfficeEvent());
    }
  }

  void _onGetBranchOfficeEvent(
      GetBranchOfficeEvent event, Emitter<ContractState> emit) async {
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
            selectedBranch: BranchOfficeModel()),
      );
    }
  }

  void _onChangeBranchOfficeEvent(
      ChangeBranchOfficeEvent event, Emitter<ContractState> emit) async {
    emit(state.copyWith(selectedBranch: event.model));
    add(GetDepartmentEvent());
  }

  void _onGetDepartmentEvent(
      GetDepartmentEvent event, Emitter<ContractState> emit) async {
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
            selectedDepartment: DepartmentModel()),
      );
    }
  }

  void _onChangeDepartmentEvent(
      ChangeDepartmentEvent event, Emitter<ContractState> emit) {
    emit(state.copyWith(selectedDepartment: event.model));
    add(GetTeamEvent());
  }

  void _onChangeTeamEvent(
      ChangeTeamEvent event, Emitter<ContractState> emit) async {
    emit(state.copyWith(selectedTeam: event.model));
  }

  void _onGetTeamEvent(GetTeamEvent event, Emitter<ContractState> emit) async {
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
          selectedTeam: TeamModel(),
        ),
      );
    }
  }

  void _onCopyStateEvent(CopyStateEvent event, Emitter<ContractState> emit) {
    emit(state.copyWith(
      organizationsList: event.arg.organizationsList,
      branchList: event.arg.branchList,
      departmentList: event.arg.departmentList,
      teamList: event.arg.teamList,
      selectedOrganization: event.arg.selectedOrganization?.id != null
          ? event.arg.selectedOrganization
          : const OrganizationModel(),
      selectedBranch: event.arg.selectedBranch?.id != null
          ? event.arg.selectedBranch
          : const BranchOfficeModel(),
      selectedDepartment: event.arg.selectedDepartment?.id != null
          ? event.arg.selectedDepartment
          : const DepartmentModel(),
      selectedTeam: event.arg.selectedTeam?.id != null
          ? event.arg.selectedTeam
          : const TeamModel(),
    ));
    add(GetContractEvent());
  }

  void _onFilterByDateEvent(
      FilterByDateEvent event, Emitter<ContractState> emit) {
    // final startDate = event.startDate;
    // if startDate
    // final endDate = event.endDate;
  }

  void _onUpdateContractEvent(
      UpdateContractEvent event, Emitter<ContractState> emit) async {
    print('go heee');
    emit(state.copyWith(status: FormzStatus.submissionInProgress, message: ''));
    try {
      await contractRepo.updateContract(model: event.model, id: event.id);

      emit(state.copyWith(
        status: FormzStatus.submissionSuccess,
        message: 'update success',
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
}

extension BlocExt on BuildContext {
  ContractBloc get contractBloc => read<ContractBloc>();
}
