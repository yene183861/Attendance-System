import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:firefly/data/model/organization_model.dart';
import 'package:firefly/services/api/error_from_server.dart';
import 'package:firefly/services/repository/organization_repository.dart';

part 'organization_state.dart';
part 'organization_event.dart';

class OrganizationBloc extends Bloc<OrganizationEvent, OrganizationState> {
  OrganizationBloc() : super(const OrganizationState()) {
    on<GetOrganizationEvent>(_onGetOrganizationEvent);
    on<DeleteOrganizationEvent>(_onDeleteOrganizationEvent);
  }

  final organizationRepo = OrganizationRepository();

  Future<void> _onGetOrganizationEvent(
      GetOrganizationEvent event, Emitter<OrganizationState> emit) async {
    emit(
      state.copyWith(
        status: FormzStatus.submissionInProgress,
      ),
    );
    try {
      final res = await organizationRepo.getOrganization();
      emit(
        state.copyWith(
          status: FormzStatus.submissionSuccess,
          organizationsList: res?.data,
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

  Future<void> _onDeleteOrganizationEvent(
      DeleteOrganizationEvent event, Emitter<OrganizationState> emit) async {
    emit(
      state.copyWith(
        status: FormzStatus.submissionInProgress,
      ),
    );
    try {
      await organizationRepo.deleteOrganization(id: event.id);
      emit(
        state.copyWith(
          status: FormzStatus.submissionFailure,
          message: 'msg_delete_organization_success'.tr(),
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
  OrganizationBloc get organizationBloc => read<OrganizationBloc>();
}
