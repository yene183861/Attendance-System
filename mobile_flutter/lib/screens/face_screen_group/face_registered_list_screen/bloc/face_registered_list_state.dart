part of 'face_registered_list_bloc.dart';

class FaceRegisteredListState extends Equatable {
  final FormzStatus status;
  final String? message;
  final UserWorkModel? selectedUser;
  final List<UserWorkModel>? users;
  final File? videoFile;
  final List<OrganizationModel>? organizationsList;
  final List<BranchOfficeModel>? branchList;
  final List<DepartmentModel>? departmentList;
  final List<TeamModel>? teamList;
  final OrganizationModel? selectedOrganization;
  final BranchOfficeModel? selectedBranch;
  final DepartmentModel? selectedDepartment;
  final TeamModel? selectedTeam;
  final List<FaceModel>? facesList;
  final FaceModel? selectedFace;

  const FaceRegisteredListState({
    this.status = FormzStatus.pure,
    this.message,
    this.selectedUser,
    this.videoFile,
    this.users,
    this.organizationsList,
    this.branchList,
    this.departmentList,
    this.teamList,
    this.selectedOrganization,
    this.selectedBranch,
    this.selectedDepartment,
    this.selectedTeam,
    this.facesList,
    this.selectedFace,
  });

  FaceRegisteredListState copyWith({
    FormzStatus? status,
    String? message,
    UserWorkModel? selectedUser,
    List<UserWorkModel>? users,
    File? videoFile,
    List<OrganizationModel>? organizationsList,
    List<BranchOfficeModel>? branchList,
    List<DepartmentModel>? departmentList,
    List<TeamModel>? teamList,
    OrganizationModel? selectedOrganization,
    BranchOfficeModel? selectedBranch,
    DepartmentModel? selectedDepartment,
    TeamModel? selectedTeam,
    List<FaceModel>? facesList,
    FaceModel? selectedFace,
  }) {
    return FaceRegisteredListState(
      status: status ?? this.status,
      message: message ?? this.message,
      selectedUser: selectedUser ?? this.selectedUser,
      videoFile: videoFile ?? this.videoFile,
      users: users ?? this.users,
      organizationsList: organizationsList ?? this.organizationsList,
      branchList: branchList ?? this.branchList,
      departmentList: departmentList ?? this.departmentList,
      teamList: teamList ?? this.teamList,
      selectedOrganization: selectedOrganization ?? this.selectedOrganization,
      selectedBranch: selectedBranch ?? this.selectedBranch,
      selectedDepartment: selectedDepartment ?? this.selectedDepartment,
      selectedTeam: selectedTeam ?? this.selectedTeam,
      facesList: facesList ?? this.facesList,
      selectedFace: selectedFace ?? this.selectedFace,
    );
  }

  @override
  List<Object?> get props => [
        status,
        message,
        selectedUser,
        videoFile,
        users,
        organizationsList,
        branchList,
        departmentList,
        teamList,
        selectedOrganization,
        selectedBranch,
        selectedDepartment,
        selectedTeam,
        facesList,
        selectedFace,
      ];
}
