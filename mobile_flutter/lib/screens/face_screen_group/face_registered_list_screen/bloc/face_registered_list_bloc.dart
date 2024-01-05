import 'dart:developer';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:firefly/data/arguments/common_argument.dart';
import 'package:firefly/data/enum_type/user_type.dart';
import 'package:firefly/data/request_param/common_param.dart';
import 'package:firefly/utils/singleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:firefly/data/model/branch_office_model.dart';
import 'package:firefly/data/model/department_model.dart';
import 'package:firefly/data/model/face_model.dart';
import 'package:firefly/data/model/organization_model.dart';
import 'package:firefly/data/model/team_model.dart';
import 'package:firefly/data/model/user_model.dart';
import 'package:firefly/data/model/user_work_model.dart';
import 'package:firefly/data/request_param/get_user_param.dart';
import 'package:firefly/data/request_param/register_face_param.dart';
import 'package:firefly/services/api/error_from_server.dart';
import 'package:firefly/services/repository/branch_office_repository.dart';
import 'package:firefly/services/repository/department_repository.dart';
import 'package:firefly/services/repository/face_repository.dart';
import 'package:firefly/services/repository/organization_repository.dart';
import 'package:firefly/services/repository/team_repository.dart';
import 'package:firefly/services/repository/user_repository.dart';
import 'package:firefly/services/repository/user_work_repository.dart';

part 'face_registered_list_event.dart';
part 'face_registered_list_state.dart';

class FaceRegisteredListBloc
    extends Bloc<FaceRegisteredListEvent, FaceRegisteredListState> {
  FaceRegisteredListBloc({CommonArgument? commonArgument})
      : super(FaceRegisteredListState(
          organizationsList: commonArgument?.organizationsList,
          branchList: commonArgument?.branchList,
          departmentList: commonArgument?.departmentList,
          teamList: commonArgument?.teamList,
          selectedOrganization: commonArgument?.selectedOrganization,
          selectedBranch: commonArgument?.selectedBranch,
          selectedDepartment: commonArgument?.selectedDepartment,
          selectedTeam: commonArgument?.selectedTeam,
        )) {
    on<InitEvent>(_onInitEvent);
    on<CreateFaceRegisteredListEvent>(_onCreateFaceRegisteredListEvent);
    on<SearchUserWorkEvent>(_onSearchUserWorkEvent);
    on<SelectUserEvent>(_onSelectUserEvent);
    on<GetListFaceEvent>(_onGetListFaceEvent);
    on<GetOrganizationEvent>(_onGetOrganizationEvent);
    on<ChangeOrganizationEvent>(_onChangeOrganizationEvent);
    on<GetBranchOfficeEvent>(_onGetBranchOfficeEvent);
    on<ChangeBranchOfficeEvent>(_onChangeBranchOfficeEvent);
    on<GetDepartmentEvent>(_onGetDepartmentEvent);
    on<ChangeDepartmentEvent>(_onChangeDepartmentEvent);
    on<GetTeamEvent>(_onGetTeamEvent);
    on<ChangeTeamEvent>(_onChangeTeamEvent);
    on<CopyStateEvent>(_onCopyStateEvent);
  }
  final userWorkRepo = UserWorkRepository();
  final faceRepo = FaceRepository();
  final orgRepository = OrganizationRepository();
  final branchRepository = BranchOfficeRepository();
  final departmentRepository = DepartmentRepository();
  final teamRepository = TeamRepository();

  void _onInitEvent(
      InitEvent event, Emitter<FaceRegisteredListState> emit) async {
    final userType = Singleton.instance.userType;
    if (userType != UserType.ADMIN) {
      final userWork = Singleton.instance.userWork!;
      final org = userWork.organization;
      emit(
          state.copyWith(selectedOrganization: org, organizationsList: [org!]));
      // if (userType == UserType.CEO) {
      add(GetListFaceEvent());
      // } else {
      //   final userWork = Singleton.instance.userWork!;
      //   emit(
      //     state.copyWith(
      //       selectedUser: userWork,
      //     ),
      //   );
      //   add(GetListFaceEvent());
      // }
    } else {
      try {
        final res = await orgRepository.getOrganization();
        emit(state.copyWith(
          status: FormzStatus.submissionSuccess,
          message: '',
          organizationsList: res?.data,
        ));
        if (res?.data != null && res!.data!.isNotEmpty) {
          emit(state.copyWith(selectedOrganization: res.data![0]));
          add(GetListFaceEvent());
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

  void _onCreateFaceRegisteredListEvent(CreateFaceRegisteredListEvent event,
      Emitter<FaceRegisteredListState> emit) async {
    emit(state.copyWith(
      status: FormzStatus.submissionInProgress,
      message: '',
    ));
    // if (state.selectedUser?.id != null && state.videoFile != null) {
    try {
      log('đáadadadđ: ${event.video}');
      log('add: ${event.video.runtimeType}');
      // log('')
      await faceRepo.registerFace(
          registerFaceParam: RegisterFaceParam(
              // userId: state.selectedUser!.user!.id!,
              userId: 8,
              videoFile: event.video));
      emit(state.copyWith(
        status: FormzStatus.submissionSuccess,
        message: 'Đăng ký gương mặt thành công',
      ));
      log('ĐĂNG KÝ THÀNH CÔNG RỒI');
    } on ErrorFromServer catch (e) {
      emit(state.copyWith(
          status: FormzStatus.submissionFailure, message: e.message));
    }
    // } else {
    //   final error = state.selectedUser?.id != null
    //       ? 'Bạn cần quay video khuôn mặt người dùng'
    //       : 'email is required';
    //   emit(state.copyWith(
    //       status: FormzStatus.submissionFailure, message: error));
    // }
  }

  void _onSearchUserWorkEvent(
      SearchUserWorkEvent event, Emitter<FaceRegisteredListState> emit) async {
    if (event.name.isNotEmpty) {
      emit(state.copyWith(
        status: FormzStatus.submissionInProgress,
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
      SelectUserEvent event, Emitter<FaceRegisteredListState> emit) async {
    if (state.selectedUser?.id != event.user.id) {
      emit(state.copyWith(selectedUser: event.user));
      add(GetListFaceEvent());
    }
  }

  void _onGetListFaceEvent(
      GetListFaceEvent event, Emitter<FaceRegisteredListState> emit) async {
    emit(state.copyWith(
      status: FormzStatus.submissionInProgress,
      message: '',
    ));
    try {
      final param = CommonParam(
        userId: state.selectedUser?.user?.id,
        organizationId: state.selectedOrganization?.id,
        branchOfficeId: state.selectedBranch?.id,
        departmentId: state.selectedDepartment?.id,
        teamId: state.selectedTeam?.id,
      );

      final res = await faceRepo.getListFaces(param: param);
      emit(state.copyWith(
        status: FormzStatus.submissionSuccess,
        facesList: res?.data,
        message: '',
      ));
    } on ErrorFromServer catch (e) {
      emit(state.copyWith(
          status: FormzStatus.submissionFailure, message: e.message));
    }
  }

  void _onGetOrganizationEvent(
      GetOrganizationEvent event, Emitter<FaceRegisteredListState> emit) async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress, message: ''));
    try {
      final res = await orgRepository.getOrganization();
      emit(state.copyWith(
        status: FormzStatus.submissionSuccess,
        message: '',
        organizationsList: res?.data,
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

  void _onChangeOrganizationEvent(
      ChangeOrganizationEvent event, Emitter<FaceRegisteredListState> emit) {
    if (state.selectedOrganization?.id != event.model.id) {
      emit(state.copyWith(
        selectedOrganization: event.model,
      ));
      add(GetBranchOfficeEvent());
    }
  }

  void _onGetBranchOfficeEvent(
      GetBranchOfficeEvent event, Emitter<FaceRegisteredListState> emit) async {
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
        ),
      );
    }
  }

  void _onChangeBranchOfficeEvent(ChangeBranchOfficeEvent event,
      Emitter<FaceRegisteredListState> emit) async {
    emit(state.copyWith(selectedBranch: event.model));
    add(GetDepartmentEvent());
  }

  void _onGetDepartmentEvent(
      GetDepartmentEvent event, Emitter<FaceRegisteredListState> emit) async {
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
        ),
      );
    }
  }

  void _onChangeDepartmentEvent(
      ChangeDepartmentEvent event, Emitter<FaceRegisteredListState> emit) {
    emit(state.copyWith(selectedDepartment: event.model));
    add(GetTeamEvent());
  }

  void _onChangeTeamEvent(
      ChangeTeamEvent event, Emitter<FaceRegisteredListState> emit) async {
    emit(state.copyWith(selectedTeam: event.model));
  }

  void _onGetTeamEvent(
      GetTeamEvent event, Emitter<FaceRegisteredListState> emit) async {
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
        ),
      );
    }
  }

  void _onCopyStateEvent(
      CopyStateEvent event, Emitter<FaceRegisteredListState> emit) async {
    emit(state.copyWith(
      organizationsList: event.arg.organizationsList,
      branchList: event.arg.branchList,
      departmentList: event.arg.departmentList,
      teamList: event.arg.teamList,
      selectedOrganization: event.arg.selectedOrganization?.id != null
          ? event.arg.selectedOrganization
          : OrganizationModel(),
      selectedBranch: event.arg.selectedBranch?.id != null
          ? event.arg.selectedBranch
          : BranchOfficeModel(),
      selectedDepartment: event.arg.selectedDepartment?.id != null
          ? event.arg.selectedDepartment
          : DepartmentModel(),
      selectedTeam: event.arg.selectedTeam?.id != null
          ? event.arg.selectedTeam
          : TeamModel(),
    ));
    add(GetListFaceEvent());
  }
}

extension BlocExt on BuildContext {
  FaceRegisteredListBloc get faceRegisteredListBloc =>
      read<FaceRegisteredListBloc>();
}
