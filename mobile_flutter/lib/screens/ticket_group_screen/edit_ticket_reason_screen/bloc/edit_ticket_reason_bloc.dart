import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:firefly/data/arguments/edit_ticket_reason_arguments.dart';
import 'package:firefly/data/enum_type/by_time.dart';
import 'package:firefly/data/enum_type/ticket_type.dart';
import 'package:firefly/data/enum_type/user_type.dart';
import 'package:firefly/data/model/organization_model.dart';
import 'package:firefly/data/model/ticket_reason_model.dart';
import 'package:firefly/services/api/error_from_server.dart';
import 'package:firefly/services/repository/organization_repository.dart';
import 'package:firefly/services/repository/ticket_reason_repository.dart';
import 'package:firefly/utils/singleton.dart';

part 'edit_ticket_reason_event.dart';
part 'edit_ticket_reason_state.dart';

class EditTicketReasonBloc
    extends Bloc<EditTicketReasonEvent, EditTicketReasonState> {
  EditTicketReasonBloc({required EditTicketReasonArgument arg})
      : super(EditTicketReasonState(
          selectedOrganization: arg.organization,
          ticketReasonModel: arg.ticketReasonModel,
          ticketType: (arg.ticketReasonModel != null
                  ? arg.ticketReasonModel?.ticketType
                  : arg.ticketType) ??
              TicketType.APPLICATION_FOR_THOUGHT,
          byTime: (arg.ticketReasonModel != null
                  ? arg.ticketReasonModel!.byTime
                  : arg.byTime) ??
              ByTime.MONTH,
          isCaculWork: arg.ticketReasonModel != null
              ? arg.ticketReasonModel!.isWorkCalculation
              : false,
        )) {
    on<InitEvent>(_onInitEvent);
    on<ChangeByTimeEvent>(_onChangeByTimeEvent);
    on<ChangeTicketTypeEvent>(_onChangeTicketTypeEvent);
    on<ChangeOrganizationEvent>(_onChangeOrganizationEvent);
    on<CreateTicketReasonEvent>(_onCreateTicketReasonEvent);
    on<UpdateTicketReasonEvent>(_onUpdateTicketReasonEvent);
    on<ChangeStatusCaculWork>(_onChangeStatusCaculWork);
  }

  final orgRepo = OrganizationRepository();
  final ticketReasonRepo = TicketReasonRepository();
  void _onInitEvent(
      InitEvent event, Emitter<EditTicketReasonState> emit) async {
    if (state.ticketReasonModel != null) {
      add(ChangeStatusCaculWork(state.ticketReasonModel!.isWorkCalculation));
    }
    emit(
      state.copyWith(
        status: FormzStatus.submissionInProgress,
        message: '',
      ),
    );
    try {
      final user_type = Singleton.instance.userType;
      if (user_type == UserType.ADMIN) {
        final res = await orgRepo.getOrganization();
        emit(state.copyWith(
          status: FormzStatus.submissionSuccess,
          organizationsList: res?.data,
          message: '',
        ));
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

  void _onChangeByTimeEvent(
      ChangeByTimeEvent event, Emitter<EditTicketReasonState> emit) async {
    emit(state.copyWith(byTime: event.byTime));
  }

  void _onChangeTicketTypeEvent(
      ChangeTicketTypeEvent event, Emitter<EditTicketReasonState> emit) async {
    emit(state.copyWith(ticketType: event.ticketType));
  }

  void _onChangeOrganizationEvent(ChangeOrganizationEvent event,
      Emitter<EditTicketReasonState> emit) async {
    emit(state.copyWith(selectedOrganization: event.organizationModel));
  }

  void _onCreateTicketReasonEvent(CreateTicketReasonEvent event,
      Emitter<EditTicketReasonState> emit) async {
    emit(state.copyWith(
      status: FormzStatus.submissionInProgress,
      message: '',
    ));
    try {
      await ticketReasonRepo.addTicketReason(model: event.ticketReasonModel);
      emit(
        state.copyWith(
          status: FormzStatus.submissionSuccess,
          message: 'create_success'.tr(),
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

  void _onUpdateTicketReasonEvent(UpdateTicketReasonEvent event,
      Emitter<EditTicketReasonState> emit) async {
    emit(state.copyWith(
      status: FormzStatus.submissionInProgress,
      message: '',
    ));
    try {
      await ticketReasonRepo.updateTicketReason(
          model: event.ticketReasonModel, id: state.ticketReasonModel!.id!);
      emit(
        state.copyWith(
          status: FormzStatus.submissionSuccess,
          message: 'update_ticket_reason_success'.tr(),
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

  void _onChangeStatusCaculWork(
      ChangeStatusCaculWork event, Emitter<EditTicketReasonState> emit) async {
    emit(state.copyWith(isCaculWork: event.isCacul));
  }
}

extension BlocExt on BuildContext {
  EditTicketReasonBloc get editTicketReasonBloc => read<EditTicketReasonBloc>();
}
