part of 'face_registered_list_bloc.dart';

abstract class FaceRegisteredListEvent {}

class InitEvent extends FaceRegisteredListEvent {
  InitEvent();
}

class CreateFaceRegisteredListEvent extends FaceRegisteredListEvent {
  final File video;
  CreateFaceRegisteredListEvent({required this.video});
}

class SearchUserWorkEvent extends FaceRegisteredListEvent {
  final String name;
  SearchUserWorkEvent({required this.name});
}

class GetListFaceEvent extends FaceRegisteredListEvent {
  GetListFaceEvent();
}

class UpdateFaceEvent extends FaceRegisteredListEvent {
  UpdateFaceEvent();
}

class DeleteFaceEvent extends FaceRegisteredListEvent {
  DeleteFaceEvent();
}

class SelectUserEvent extends FaceRegisteredListEvent {
  final UserWorkModel user;
  SelectUserEvent({required this.user});
}

class GetOrganizationEvent extends FaceRegisteredListEvent {
  GetOrganizationEvent();
}

class ChangeOrganizationEvent extends FaceRegisteredListEvent {
  final OrganizationModel model;
  ChangeOrganizationEvent({required this.model});
}

class GetBranchOfficeEvent extends FaceRegisteredListEvent {
  GetBranchOfficeEvent();
}

class ChangeBranchOfficeEvent extends FaceRegisteredListEvent {
  final BranchOfficeModel model;
  ChangeBranchOfficeEvent({required this.model});
}

class GetDepartmentEvent extends FaceRegisteredListEvent {
  GetDepartmentEvent();
}

class ChangeDepartmentEvent extends FaceRegisteredListEvent {
  final DepartmentModel model;
  ChangeDepartmentEvent({required this.model});
}

class ChangeTeamEvent extends FaceRegisteredListEvent {
  final TeamModel model;
  ChangeTeamEvent({required this.model});
}

class GetTeamEvent extends FaceRegisteredListEvent {
  GetTeamEvent();
}

class CopyStateEvent extends FaceRegisteredListEvent {
  final CommonArgument arg;
  CopyStateEvent({required this.arg});
}
