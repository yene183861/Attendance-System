import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:firefly/data/arguments/common_argument.dart';
import 'package:firefly/data/enum_type/ticket_status.dart';
import 'package:firefly/data/model/branch_office_model.dart';
import 'package:firefly/data/model/department_model.dart';
import 'package:firefly/data/model/team_model.dart';
import 'package:firefly/data/model/user_work_model.dart';
import 'package:firefly/services/repository/branch_office_repository.dart';
import 'package:firefly/services/repository/department_repository.dart';
import 'package:firefly/services/repository/team_repository.dart';
import 'package:firefly/services/repository/user_work_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:firefly/data/enum_type/ticket_type.dart';
import 'package:firefly/data/enum_type/user_type.dart';
import 'package:firefly/data/model/organization_model.dart';
import 'package:firefly/data/model/ticket_model.dart';
import 'package:firefly/data/model/ticket_reason_model.dart';
import 'package:firefly/data/request_param/get_ticket_param.dart';
import 'package:firefly/services/api/barrel_api.dart';
import 'package:firefly/services/repository/organization_repository.dart';
import 'package:firefly/services/repository/ticket_reason_repository.dart';
import 'package:firefly/services/repository/ticket_repository.dart';
import 'package:firefly/utils/singleton.dart';
import 'package:firefly/utils/date_time_ext.dart';

part 'ticket_event.dart';
part 'ticket_state.dart';

class TicketBloc extends Bloc<TicketEvent, TicketState> {
  TicketBloc({CommonArgument? commonArgument})
      : super(TicketState(
          organizationList: commonArgument?.organizationsList,
          branchList: commonArgument?.branchList,
          departmentList: commonArgument?.departmentList,
          teamList: commonArgument?.teamList,
          selectedOrganization: commonArgument?.selectedOrganization,
          selectedBranch: commonArgument?.selectedBranch,
          selectedDepartment: commonArgument?.selectedDepartment,
          selectedTeam: commonArgument?.selectedTeam,
          isYourTicket: commonArgument != null
              ? false
              : (Singleton.instance.userType!.type <= UserType.CEO.type
                  ? false
                  : true),
          month: DateTime.now().lastDateOfMonth,
        )) {
    on<InitEvent>(_onInitEvent);
    on<GetTicketEvent>(_onGetTicketEvent);
    on<ChangeTicketTypeEvent>(_onChangeTicketTypeEvent);
    on<GetOrganizationEvent>(_onGetOrganizationEvent);
    on<ChangeOrganizationEvent>(_onChangeOrganizationEvent);
    on<GetBranchOfficeEvent>(_onGetBranchOfficeEvent);
    on<ChangeBranchOfficeEvent>(_onChangeBranchOfficeEvent);
    on<GetDepartmentEvent>(_onGetDepartmentEvent);
    on<ChangeDepartmentEvent>(_onChangeDepartmentEvent);
    on<GetTeamEvent>(_onGetTeamEvent);
    on<ChangeTeamEvent>(_onChangeTeamEvent);
    on<IsApplyFilterTypeEvent>(_onIsApplyFilterTypeEvent);
    on<IsApplyFilterTicketStatusEvent>(_onIsApplyFilterTicketStatusEvent);
    on<ChangeTicketStatusEvent>(_onChangeTicketStatusEvent);
    on<DeleteTicketEvent>(_onDeleteTicketEvent);

    on<SelectUserEvent>(_onSelectUserEvent);
    on<SearchUserWorkEvent>(_onSearchUserWorkEvent);
    on<CopyStateEvent>(_onCopyStateEvent);
    on<FilterYourTicket>(_onFilterYourTicket);
    on<ChangeMonthEvent>(_onChangeMonthEvent);
    on<HandleTicketEvent>(_onHandleTicketEvent);
  }
  final userWorkRepo = UserWorkRepository();
  final orgRepository = OrganizationRepository();
  final branchRepository = BranchOfficeRepository();
  final departmentRepository = DepartmentRepository();
  final teamRepository = TeamRepository();
  final ticketReasonRepo = TicketReasonRepository();
  final ticketRepo = TicketRepository();

  void _onInitEvent(InitEvent event, Emitter<TicketState> emit) async {
    emit(state.copyWith(
      status: FormzStatus.submissionInProgress,
      message: '',
    ));
    try {
      final userType = Singleton.instance.userType;
      if (userType == UserType.ADMIN) {
        final res = await orgRepository.getOrganization();
        emit(state.copyWith(
          status: FormzStatus.submissionSuccess,
          organizationList: res?.data,
          message: '',
        ));
        if (res?.data != null && res!.data!.isNotEmpty) {
          add(ChangeOrganizationEvent(model: res.data![0]));
        }
      } else {
        final org = Singleton.instance.userWork!.organization!;
        print(Singleton.instance.userWork!.id);
        emit(
          state.copyWith(
            organizationList: [org],
            selectedOrganization: org,
          ),
        );
        if (userType != UserType.CEO) {
          final userWork = Singleton.instance.userWork!;
          emit(
            state.copyWith(
              selectedUser: userWork,
            ),
          );
        }
        add(GetTicketEvent());
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

  void _onSearchUserWorkEvent(
      SearchUserWorkEvent event, Emitter<TicketState> emit) async {
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
      SelectUserEvent event, Emitter<TicketState> emit) async {
    if (state.selectedUser?.id != event.user.id) {
      emit(state.copyWith(selectedUser: event.user));
      add(GetTicketEvent());
    }
  }

  void _onGetTicketEvent(
      GetTicketEvent event, Emitter<TicketState> emit) async {
    emit(state.copyWith(
      status: FormzStatus.submissionInProgress,
      message: '',
    ));
    try {
      final param = GetTicketParam(
        userId: state.selectedUser?.user?.id,
        organizationId: state.selectedOrganization?.id,
        branchOfficeId: state.selectedBranch?.id,
        departmentId: state.selectedDepartment?.id,
        teamId: state.selectedTeam?.id,
        ticketType: state.isFilterByTicketType ? state.ticketType : null,
        status: state.isFilterByTicketStatus ? state.ticketStatus : null,
        month: state.month.lastDateOfMonth,
      );
      final res = await ticketRepo.getTickets(param: param);
      emit(
        state.copyWith(
          status: FormzStatus.submissionSuccess,
          message: '',
          ticketList: res?.data,
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

  void _onGetOrganizationEvent(
      GetOrganizationEvent event, Emitter<TicketState> emit) async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress, message: ''));
    try {
      final res = await orgRepository.getOrganization();
      emit(state.copyWith(
        status: FormzStatus.submissionSuccess,
        message: '',
        organizationList: res?.data,
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

  void _onChangeTicketTypeEvent(
      ChangeTicketTypeEvent event, Emitter<TicketState> emit) async {
    emit(
      state.copyWith(ticketType: event.ticketType),
    );
    add(GetTicketEvent());
  }

  void _onIsApplyFilterTypeEvent(
      IsApplyFilterTypeEvent event, Emitter<TicketState> emit) async {
    emit(state.copyWith(isFilterByTicketType: event.isApply));
    add(GetTicketEvent());
  }

  void _onIsApplyFilterTicketStatusEvent(
      IsApplyFilterTicketStatusEvent event, Emitter<TicketState> emit) async {
    emit(state.copyWith(isFilterByTicketStatus: event.isApply));
    add(GetTicketEvent());
  }

  void _onChangeTicketStatusEvent(
      ChangeTicketStatusEvent event, Emitter<TicketState> emit) async {
    emit(state.copyWith(ticketStatus: event.status));
    add(GetTicketEvent());
  }

  void _onDeleteTicketEvent(
      DeleteTicketEvent event, Emitter<TicketState> emit) async {
    emit(state.copyWith(
      status: FormzStatus.submissionInProgress,
      message: '',
    ));
    try {
      await ticketReasonRepo.deleteTicketReason(id: event.id);
      emit(
        state.copyWith(
          status: FormzStatus.submissionSuccess,
          message: 'delete_success'.tr(),
        ),
      );
      add(GetTicketEvent());
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
      ChangeOrganizationEvent event, Emitter<TicketState> emit) {
    if (state.selectedOrganization?.id != event.model.id) {
      emit(state.copyWith(
        selectedOrganization: event.model,
      ));
      add(GetBranchOfficeEvent());
    }
  }

  void _onGetBranchOfficeEvent(
      GetBranchOfficeEvent event, Emitter<TicketState> emit) async {
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
            selectedBranch: const BranchOfficeModel()),
      );
    }
  }

  void _onChangeBranchOfficeEvent(
      ChangeBranchOfficeEvent event, Emitter<TicketState> emit) async {
    emit(state.copyWith(selectedBranch: event.model));
    add(GetDepartmentEvent());
  }

  void _onGetDepartmentEvent(
      GetDepartmentEvent event, Emitter<TicketState> emit) async {
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
            selectedDepartment: const DepartmentModel()),
      );
    }
  }

  void _onChangeDepartmentEvent(
      ChangeDepartmentEvent event, Emitter<TicketState> emit) {
    emit(state.copyWith(selectedDepartment: event.model));
    add(GetTeamEvent());
  }

  void _onChangeTeamEvent(
      ChangeTeamEvent event, Emitter<TicketState> emit) async {
    emit(state.copyWith(selectedTeam: event.model));
  }

  void _onGetTeamEvent(GetTeamEvent event, Emitter<TicketState> emit) async {
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
          selectedTeam: const TeamModel(),
        ),
      );
    }
  }

  void _onCopyStateEvent(CopyStateEvent event, Emitter<TicketState> emit) {
    emit(state.copyWith(
      organizationList: event.arg.organizationsList,
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
    add(GetTicketEvent());
  }

  void _onFilterYourTicket(FilterYourTicket event, Emitter<TicketState> emit) {
    if (state.isYourTicket != event.isYourTicket) {
      emit(state.copyWith(
        isYourTicket: event.isYourTicket,
      ));
      if (event.isYourTicket) {
        add(SelectUserEvent(user: Singleton.instance.userWork!));
      } else {
        add(SelectUserEvent(user: UserWorkModel()));
      }
      // add(GetTicketEvent());
    }
  }

  void _onChangeMonthEvent(ChangeMonthEvent event, Emitter<TicketState> emit) {
    if (state.month != event.month) {
      emit(state.copyWith(
        month: event.month.lastDateOfMonth,
      ));
      add(GetTicketEvent());
    }
  }

  void _onHandleTicketEvent(
      HandleTicketEvent event, Emitter<TicketState> emit) async {
    emit(
      state.copyWith(
        status: FormzStatus.submissionInProgress,
        message: '',
      ),
    );

    try {
      final model = TicketModel(
          status: event.status,
          dateTimeTickets: event.ticket.dateTimeTickets,
          reviewerOpinions: event.reason ?? '',
          ticketType: event.ticket.ticketType);
      await ticketRepo.updateTicket(model: model, id: event.ticket.id!);
      emit(
        state.copyWith(
          status: FormzStatus.submissionSuccess,
          message: 'Phê duyệt đơn thành công'.tr(),
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
  TicketBloc get ticketBloc => read<TicketBloc>();
}
