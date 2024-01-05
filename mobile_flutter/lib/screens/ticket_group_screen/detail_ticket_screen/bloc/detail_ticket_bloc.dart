import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import 'package:firefly/data/model/ticket_model.dart';

import 'package:firefly/data/model/user_work_model.dart';

import 'package:firefly/data/request_param/get_user_param.dart';
import 'package:firefly/services/api/barrel_api.dart';
import 'package:firefly/services/repository/organization_repository.dart';
import 'package:firefly/services/repository/ticket_reason_repository.dart';
import 'package:firefly/services/repository/ticket_repository.dart';
import 'package:firefly/services/repository/user_repository.dart';
import 'package:firefly/utils/singleton.dart';

part 'detail_ticket_event.dart';
part 'detail_ticket_state.dart';

class DetailTicketBloc extends Bloc<DetailTicketEvent, DetailTicketState> {
  DetailTicketBloc({required TicketModel ticket})
      : super(DetailTicketState(ticket: ticket)) {
    on<GetDetailTicketEvent>(_onGetDetailTicketEvent);
    on<DeleteDetailTicketEvent>(_onDeleteDetailTicketEvent);
    on<GetUserWorkEvent>(_onGetUserWorkEvent);
    on<ChangeDataEvent>(_onChangeDataEvent);
  }

  final orgRepo = OrganizationRepository();
  final ticketReasonRepo = TicketReasonRepository();
  final ticketRepo = TicketRepository();
  final userRepo = UserRepository();

  void _onGetDetailTicketEvent(
      GetDetailTicketEvent event, Emitter<DetailTicketState> emit) async {
    emit(state.copyWith(
      status: FormzStatus.submissionInProgress,
      message: '',
    ));
    try {
      final res = await ticketRepo.getDetailTicket(id: state.ticket!.id!);
      emit(
        state.copyWith(
          status: FormzStatus.submissionSuccess,
          message: '',
          ticket: res?.data,
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

  void _onChangeDataEvent(
      ChangeDataEvent event, Emitter<DetailTicketState> emit) async {
    emit(state.copyWith(isChangeData: true));
    add(GetDetailTicketEvent());
  }

  void _onDeleteDetailTicketEvent(
      DeleteDetailTicketEvent event, Emitter<DetailTicketState> emit) async {
    emit(state.copyWith(
      status: FormzStatus.submissionInProgress,
      message: '',
    ));
    try {
      await ticketRepo.deleteTicket(id: event.id);
      emit(
        state.copyWith(
          status: FormzStatus.submissionSuccess,
          message: 'delete_success'.tr(),
          isChangeData: true,
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

  void _onGetUserWorkEvent(
      GetUserWorkEvent event, Emitter<DetailTicketState> emit) async {
    emit(state.copyWith(
      status: FormzStatus.submissionInProgress,
      message: '',
    ));
    try {
      if (state.ticket!.user!.id != Singleton.instance.userProfile!.id) {
        final res = await userRepo.getUsersWork(
            getUserParam: GetUserParam(userId: state.ticket!.user!.id!));
        if (res?.data != null && res!.data!.isNotEmpty) {
          emit(
            state.copyWith(
                status: FormzStatus.submissionSuccess,
                message: '',
                userWork: res.data![0]),
          );
        } else {
          emit(
            state.copyWith(
                status: FormzStatus.submissionFailure,
                message: 'Không tồn tại user-work'),
          );
          return;
        }
      } else {
        emit(
          state.copyWith(
            status: FormzStatus.submissionSuccess,
            message: '',
            userWork: Singleton.instance.userWork,
          ),
        );
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

extension BlocExt on BuildContext {
  DetailTicketBloc get detailTicketBloc => read<DetailTicketBloc>();
}
