import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import 'package:firefly/data/model/team_model.dart';
import 'package:firefly/services/api/error_from_server.dart';

import 'package:firefly/services/repository/team_repository.dart';

part 'team_state.dart';
part 'team_event.dart';

class TeamBloc extends Bloc<TeamEvent, TeamState> {
  TeamBloc({required int departmentId})
      : super(TeamState(departmentId: departmentId)) {
    on<GetTeamEvent>(_onGetTeamEvent);
    on<DeleteTeamEvent>(_onDeleteTeamEvent);
    on<UpdateTeamEvent>(_onUpdateTeamEvent);
    on<CreateTeamEvent>(_onCreateTeamEvent);
  }

  final teamRepo = TeamRepository();

  Future<void> _onGetTeamEvent(
      GetTeamEvent event, Emitter<TeamState> emit) async {
    emit(
      state.copyWith(
        status: FormzStatus.submissionInProgress,
        message: '',
      ),
    );
    try {
      final res = await teamRepo.getTeams(departmentId: state.departmentId);
      emit(
        state.copyWith(
          status: FormzStatus.submissionSuccess,
          teamsList: res?.data,
          message: '',
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

  Future<void> _onDeleteTeamEvent(
      DeleteTeamEvent event, Emitter<TeamState> emit) async {
    emit(
      state.copyWith(
        status: FormzStatus.submissionInProgress,
        message: '',
      ),
    );
    try {
      await teamRepo.deleteTeam(id: event.id);
      emit(
        state.copyWith(
          status: FormzStatus.submissionSuccess,
          message: 'msg_delete_success'.tr(),
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

  Future<void> _onCreateTeamEvent(
      CreateTeamEvent event, Emitter<TeamState> emit) async {
    emit(state.copyWith(
      status: FormzStatus.submissionInProgress,
      message: '',
    ));
    try {
      await teamRepo.addTeam(
          model: TeamModel(departmentId: state.departmentId, name: event.name));
      emit(
        state.copyWith(
            status: FormzStatus.submissionSuccess,
            message: 'msg_add_team_success'.tr()),
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

  Future<void> _onUpdateTeamEvent(
      UpdateTeamEvent event, Emitter<TeamState> emit) async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress, message: ''));
    try {
      await teamRepo.updateTeam(
        model: TeamModel(departmentId: state.departmentId, name: event.name),
        id: event.id,
      );

      emit(
        state.copyWith(
            status: FormzStatus.submissionSuccess,
            message: 'msg_update_info_success'.tr()),
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
  TeamBloc get teamBloc => read<TeamBloc>();
}
