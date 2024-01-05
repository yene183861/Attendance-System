import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:firefly/data/enum_type/by_time.dart';
import 'package:firefly/data/enum_type/ticket_status.dart';
import 'package:firefly/data/enum_type/ticket_type.dart';
import 'package:firefly/data/model/branch_office_model.dart';
import 'package:firefly/data/model/department_model.dart';
import 'package:firefly/data/model/organization_model.dart';
import 'package:firefly/data/model/team_model.dart';
import 'package:firefly/data/model/ticket_model.dart';
import 'package:firefly/data/model/ticket_reason_model.dart';
import 'package:firefly/data/model/user_work_model.dart';

import 'package:firefly/services/repository/organization_repository.dart';
import 'package:firefly/services/repository/ticket_reason_repository.dart';
import 'package:firefly/services/repository/ticket_repository.dart';

part 'manage_ticket_event.dart';
part 'manage_ticket_state.dart';

class ManageTicketBloc extends Bloc<ManageTicketEvent, ManageTicketState> {
  ManageTicketBloc() : super(ManageTicketState()) {
    // on<InitEvent>(_onInitEvent);
    // // on<GetTicketEvent>(_onGetTicketEvent);
    // on<ChangeTicketTypeEvent>(_onChangeTicketTypeEvent);
    // on<ChangeOrganizationEvent>(_onChangeOrganizationEvent);
    // on<ChangeByTimeEvent>(_onChangeByTimeEvent);
    // on<IsApplyFilterTypeEvent>(_onIsApplyFilterTypeEvent);
    // on<IsFilterByTimeEvent>(_onIsFilterByTimeEvent);
    // on<DeleteTicketEvent>(_onDeleteTicketEvent);
  }

  final orgRepo = OrganizationRepository();
  final ticketReasonRepo = TicketReasonRepository();
  final ticketRepo = TicketRepository();

  // void _onInitEvent(InitEvent event, Emitter<ManageTicketState> emit) async {
  //   emit(state.copyWith(
  //     status: FormzStatus.submissionInProgress,
  //     message: '',
  //   ));
  //   try {
  //     final userType = Singleton.instance.userType;
  //     if (userType == UserType.ADMIN) {
  //       final res = await orgRepo.getOrganization();
  //       emit(state.copyWith(
  //         status: FormzStatus.submissionSuccess,
  //         organizationsList: res?.data,
  //         message: '',
  //       ));
  //       if (res?.data != null && res!.data!.isNotEmpty) {
  //         add(ChangeOrganizationEvent(organizationModel: res.data![0]));
  //       }
  //     } else {
  //       final org = Singleton.instance.userWork!.organization!;
  //       emit(
  //         state.copyWith(
  //           organizationsList: [org],
  //           selectedOrganization: org,
  //         ),
  //       );
  //       add(GetTicketEvent());
  //     }
  //   } on ErrorFromServer catch (e) {
  //     emit(
  //       state.copyWith(
  //         status: FormzStatus.submissionFailure,
  //         message: e.message,
  //       ),
  //     );
  //   }
  // }

  // void _onGetTicketEvent(
  //     GetTicketEvent event, Emitter<ManageTicketState> emit) async {
  //   emit(state.copyWith(
  //     status: FormzStatus.submissionInProgress,
  //     message: '',
  //   ));
  //   try {
  //     final param = GetTicketParam(
  //       userId: state.selectedUser!.id,
  //     );
  //     final res = await ticketRepo.getTickets(param: param);
  //     emit(
  //       state.copyWith(
  //         status: FormzStatus.submissionSuccess,
  //         message: '',
  //         ticketList: res?.data,
  //       ),
  //     );
  //   } on ErrorFromServer catch (e) {
  //     emit(
  //       state.copyWith(
  //         status: FormzStatus.submissionFailure,
  //         message: e.message,
  //       ),
  //     );
  //   }
  // }

  // void _onChangeTicketTypeEvent(
  //     ChangeTicketTypeEvent event, Emitter<ManageTicketState> emit) async {
  //   emit(
  //     state.copyWith(ticketType: event.ticketType),
  //   );
  //   add(GetTicketEvent());
  // }

  // void _onChangeOrganizationEvent(
  //     ChangeOrganizationEvent event, Emitter<ManageTicketState> emit) async {
  //   emit(state.copyWith(selectedOrganization: event.organizationModel));
  //   add(GetTicketEvent());
  // }

  // void _onChangeByTimeEvent(
  //     ChangeByTimeEvent event, Emitter<ManageTicketState> emit) async {
  //   emit(state.copyWith(byTime: event.byTime));
  //   add(GetTicketEvent());
  // }

  // void _onIsApplyFilterTypeEvent(
  //     IsApplyFilterTypeEvent event, Emitter<ManageTicketState> emit) async {
  //   emit(state.copyWith(isFilterByTicketType: event.isApplyFilter));
  //   add(GetTicketEvent());
  // }

  // void _onIsFilterByTimeEvent(
  //     IsFilterByTimeEvent event, Emitter<ManageTicketState> emit) async {
  //   emit(state.copyWith(isFilterByTime: event.isApplyFilter));
  //   add(GetTicketEvent());
  // }

  // void _onDeleteTicketEvent(
  //     DeleteTicketEvent event, Emitter<ManageTicketState> emit) async {
  //   emit(state.copyWith(
  //     status: FormzStatus.submissionInProgress,
  //     message: '',
  //   ));
  //   try {
  //     await ticketReasonRepo.deleteTicketReason(id: event.id);
  //     emit(
  //       state.copyWith(
  //         status: FormzStatus.submissionSuccess,
  //         message: 'delete_success'.tr(),
  //       ),
  //     );
  //     add(GetTicketEvent());
  //   } on ErrorFromServer catch (e) {
  //     emit(
  //       state.copyWith(
  //         status: FormzStatus.submissionFailure,
  //         message: e.message,
  //       ),
  //     );
  //   }
  // }
}

extension BlocExt on BuildContext {
  ManageTicketBloc get manageTicketBloc => read<ManageTicketBloc>();
}
