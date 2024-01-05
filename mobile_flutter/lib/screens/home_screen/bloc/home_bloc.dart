import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:firefly/data/enum_type/by_time.dart';
import 'package:firefly/data/enum_type/gender.dart';
import 'package:firefly/data/enum_type/ticket_type.dart';
import 'package:firefly/data/enum_type/user_type.dart';
import 'package:firefly/data/model/organization_model.dart';
import 'package:firefly/data/model/ticket_model.dart';
import 'package:firefly/data/model/ticket_reason_model.dart';
import 'package:firefly/data/model/user_model.dart';
import 'package:firefly/data/request_param/get_ticket_param.dart';
import 'package:firefly/data/request_param/get_ticket_reason_param.dart';
import 'package:firefly/services/api/barrel_api.dart';
import 'package:firefly/services/repository/organization_repository.dart';
import 'package:firefly/services/repository/ticket_reason_repository.dart';
import 'package:firefly/services/repository/ticket_repository.dart';
import 'package:firefly/utils/singleton.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeState(selectedUser: Singleton.instance.userProfile!)) {
    on<InitEvent>(_onInitEvent);
    on<GetHomeEvent>(_onGetHomeEvent);
    on<ChangeTicketTypeEvent>(_onChangeTicketTypeEvent);
    on<ChangeOrganizationEvent>(_onChangeOrganizationEvent);
    on<ChangeByTimeEvent>(_onChangeByTimeEvent);
    on<IsApplyFilterTypeEvent>(_onIsApplyFilterTypeEvent);
    on<IsFilterByTimeEvent>(_onIsFilterByTimeEvent);
    on<DeleteHomeEvent>(_onDeleteHomeEvent);
  }

  final orgRepo = OrganizationRepository();
  final ticketReasonRepo = TicketReasonRepository();
  final ticketRepo = TicketRepository();

  void _onInitEvent(InitEvent event, Emitter<HomeState> emit) async {
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
        add(GetHomeEvent());
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

  void _onGetHomeEvent(GetHomeEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(
      status: FormzStatus.submissionInProgress,
      message: '',
    ));
    try {
      // final param = GetTicketParam(
      //   userId: state.selectedUser!.id,
      // );
      // final res = await ticketRepo.getTickets(param: param);
      // emit(
      //   state.copyWith(
      //     status: FormzStatus.submissionSuccess,
      //     message: '',
      //     ticketList: res?.data,
      //   ),
      // );
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
      ChangeTicketTypeEvent event, Emitter<HomeState> emit) async {
    emit(
      state.copyWith(ticketType: event.ticketType),
    );
    add(GetHomeEvent());
  }

  void _onChangeOrganizationEvent(
      ChangeOrganizationEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(selectedOrganization: event.organizationModel));
    add(GetHomeEvent());
  }

  void _onChangeByTimeEvent(
      ChangeByTimeEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(byTime: event.byTime));
    add(GetHomeEvent());
  }

  void _onIsApplyFilterTypeEvent(
      IsApplyFilterTypeEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(isFilterByTicketType: event.isApplyFilter));
    add(GetHomeEvent());
  }

  void _onIsFilterByTimeEvent(
      IsFilterByTimeEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(isFilterByTime: event.isApplyFilter));
    add(GetHomeEvent());
  }

  void _onDeleteHomeEvent(
      DeleteHomeEvent event, Emitter<HomeState> emit) async {
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
      add(GetHomeEvent());
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
  HomeBloc get homeBloc => read<HomeBloc>();
}
