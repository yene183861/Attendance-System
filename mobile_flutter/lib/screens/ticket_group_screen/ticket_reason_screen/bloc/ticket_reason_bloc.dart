import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:firefly/data/enum_type/by_time.dart';
import 'package:firefly/data/enum_type/ticket_type.dart';
import 'package:firefly/data/enum_type/user_type.dart';
import 'package:firefly/data/model/organization_model.dart';
import 'package:firefly/data/model/ticket_reason_model.dart';
import 'package:firefly/data/request_param/get_ticket_reason_param.dart';
import 'package:firefly/services/api/barrel_api.dart';
import 'package:firefly/services/repository/organization_repository.dart';
import 'package:firefly/services/repository/ticket_reason_repository.dart';
import 'package:firefly/utils/singleton.dart';

part 'ticket_reason_event.dart';
part 'ticket_reason_state.dart';

class TicketReasonBloc extends Bloc<TicketReasonEvent, TicketReasonState> {
  TicketReasonBloc() : super(TicketReasonState()) {
    on<InitEvent>(_onInitEvent);
    on<GetTicketReasonEvent>(_onGetTicketReasonEvent);
    on<ChangeTicketTypeEvent>(_onChangeTicketTypeEvent);
    on<ChangeOrganizationEvent>(_onChangeOrganizationEvent);
    on<ChangeByTimeEvent>(_onChangeByTimeEvent);
    on<IsApplyFilterTypeEvent>(_onIsApplyFilterTypeEvent);
    on<IsFilterByTimeEvent>(_onIsFilterByTimeEvent);
    on<DeleteTicketReasonEvent>(_onDeleteTicketReasonEvent);
  }

  final orgRepo = OrganizationRepository();
  final ticketReasonRepo = TicketReasonRepository();

  void _onInitEvent(InitEvent event, Emitter<TicketReasonState> emit) async {
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
        emit(
          state.copyWith(
            organizationsList: [org],
            selectedOrganization: org,
          ),
        );
        add(GetTicketReasonEvent());
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

  void _onGetTicketReasonEvent(
      GetTicketReasonEvent event, Emitter<TicketReasonState> emit) async {
    emit(state.copyWith(
      status: FormzStatus.submissionInProgress,
      message: '',
    ));
    try {
      final param = GetTicketReasonParam(
        organizationId: state.selectedOrganization!.id!,
        ticketType: !state.isFilterByTicketType ? null : state.ticketType,
        byTime: !state.isFilterByTime ? null : state.byTime,
      );
      final res = await ticketReasonRepo.getTicketReasons(param: param);
      emit(
        state.copyWith(
          status: FormzStatus.submissionSuccess,
          message: '',
          ticketReasonsList: res?.data,
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

  void _onChangeTicketTypeEvent(
      ChangeTicketTypeEvent event, Emitter<TicketReasonState> emit) async {
    emit(
      state.copyWith(ticketType: event.ticketType),
    );
    add(GetTicketReasonEvent());
  }

  void _onChangeOrganizationEvent(
      ChangeOrganizationEvent event, Emitter<TicketReasonState> emit) async {
    if (state.selectedOrganization != event.organizationModel) {
      emit(state.copyWith(selectedOrganization: event.organizationModel));
      add(GetTicketReasonEvent());
    }
  }

  void _onChangeByTimeEvent(
      ChangeByTimeEvent event, Emitter<TicketReasonState> emit) async {
    emit(state.copyWith(byTime: event.byTime));
    add(GetTicketReasonEvent());
  }

  void _onIsApplyFilterTypeEvent(
      IsApplyFilterTypeEvent event, Emitter<TicketReasonState> emit) async {
    emit(state.copyWith(isFilterByTicketType: event.isApplyFilter));
    add(GetTicketReasonEvent());
  }

  void _onIsFilterByTimeEvent(
      IsFilterByTimeEvent event, Emitter<TicketReasonState> emit) async {
    emit(state.copyWith(isFilterByTime: event.isApplyFilter));
    add(GetTicketReasonEvent());
  }

  void _onDeleteTicketReasonEvent(
      DeleteTicketReasonEvent event, Emitter<TicketReasonState> emit) async {
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
      add(GetTicketReasonEvent());
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
  TicketReasonBloc get ticketReasonBloc => read<TicketReasonBloc>();
}
