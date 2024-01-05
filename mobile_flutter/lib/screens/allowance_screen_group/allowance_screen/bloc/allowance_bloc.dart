import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:firefly/data/enum_type/user_type.dart';
import 'package:firefly/data/model/allowance_model.dart';
import 'package:firefly/data/model/organization_model.dart';
import 'package:firefly/services/api/barrel_api.dart';
import 'package:firefly/services/repository/allowance_repository.dart';
import 'package:firefly/services/repository/organization_repository.dart';
import 'package:firefly/utils/singleton.dart';

part 'allowance_event.dart';
part 'allowance_state.dart';

class AllowanceBloc extends Bloc<AllowanceEvent, AllowanceState> {
  AllowanceBloc()
      : super(const AllowanceState(
          status: FormzStatus.pure,
        )) {
    on<InitAllowanceEvent>(_onInitAllowanceEvent);
    // on<GetOrganizationEvent>(_onGetOrganizationEvent);
    on<ChangeOrganizationEvent>(_onChangeOrganizationEvent);
    on<GetAllowanceEvent>(_onGetAllowanceEvent);
  }
  final allowanceRepository = AllowanceRepository();
  final orgRepo = OrganizationRepository();

  void _onInitAllowanceEvent(
      InitAllowanceEvent event, Emitter<AllowanceState> emit) async {
    emit(state.copyWith(
      status: FormzStatus.submissionInProgress,
    ));
    late OrganizationModel selectedOrg;
    try {
      if (Singleton.instance.userType == UserType.ADMIN) {
        final res = await orgRepo.getOrganization();
        emit(state.copyWith(
          status: FormzStatus.submissionSuccess,
          organizationsList: res?.data,
        ));
        if (res?.data != null && res!.data!.isNotEmpty) {
          selectedOrg = res.data![0];
          add(ChangeOrganizationEvent(organizationModel: selectedOrg));
        }
      } else {
        selectedOrg = Singleton.instance.userWork!.organization!;
        emit(state.copyWith(
          status: FormzStatus.submissionSuccess,
          organizationsList: [selectedOrg],
        ));
        add(ChangeOrganizationEvent(organizationModel: selectedOrg));
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

  void _onChangeOrganizationEvent(
      ChangeOrganizationEvent event, Emitter<AllowanceState> emit) {
    if (state.selectedOrganization?.id != event.organizationModel.id) {
      emit(state.copyWith(
        selectedOrganization: event.organizationModel,
        status: FormzStatus.pure,
      ));
      add(GetAllowanceEvent());
    }
  }

  void _onGetAllowanceEvent(
      GetAllowanceEvent event, Emitter<AllowanceState> emit) async {
    emit(state.copyWith(
      status: FormzStatus.submissionInProgress,
    ));
    try {
      final res = await allowanceRepository.getAllowance(
          organizationId: state.selectedOrganization!.id!);
      emit(state.copyWith(
        status: FormzStatus.submissionSuccess,
        allowancesList: res?.data,
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
  AllowanceBloc get allowanceBloc => read<AllowanceBloc>();
}
