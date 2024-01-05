import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:firefly/data/model/organization_model.dart';
import 'package:firefly/data/request_param/edit_organization_param.dart';
import 'package:firefly/services/api/error_from_server.dart';
import 'package:firefly/services/repository/organization_repository.dart';

part 'edit_organization_state.dart';
part 'edit_organization_event.dart';

class EditOrganizationBloc
    extends Bloc<EditOrganizationEvent, EditOrganizationState> {
  EditOrganizationBloc({OrganizationModel? organization})
      : super(EditOrganizationState(organization: organization)) {
    on<CreateOrganizationEvent>(_onCreateOrganizationEvent);
    on<UpdateOrganizationEvent>(_onUpdateOrganizationEvent);
    on<UpdateLogoEvent>(_onUpdateLogoEvent);
  }

  final organizationRepo = OrganizationRepository();

  Future<void> _onCreateOrganizationEvent(CreateOrganizationEvent event,
      Emitter<EditOrganizationState> emit) async {
    emit(state.copyWith(
      status: FormzStatus.submissionInProgress,
    ));
    try {
      final res =
          await organizationRepo.addOrganization(param: event.organization);
      emit(
        state.copyWith(
          status: FormzStatus.submissionSuccess,
          organization: res?.data,
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

  Future<void> _onUpdateOrganizationEvent(UpdateOrganizationEvent event,
      Emitter<EditOrganizationState> emit) async {
    emit(state.copyWith(
      status: FormzStatus.submissionInProgress,
    ));
    try {
      final res = await organizationRepo.updateOrganization(
          param: event.params, id: state.organization!.id!);

      emit(
        state.copyWith(
          status: FormzStatus.submissionSuccess,
          organization: res?.data,
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

  Future<void> _onUpdateLogoEvent(
      UpdateLogoEvent event, Emitter<EditOrganizationState> emit) async {
    emit(state.copyWith(logo: event.logo));
  }
}

extension BlocExt on BuildContext {
  EditOrganizationBloc get editOrganizationBloc => read<EditOrganizationBloc>();
}
