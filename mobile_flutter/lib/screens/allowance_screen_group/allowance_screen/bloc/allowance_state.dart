part of 'allowance_bloc.dart';

class AllowanceState extends Equatable {
  final FormzStatus status;
  final String? message;
  final List<AllowanceModel>? allowancesList;
  final List<OrganizationModel>? organizationsList;
  final OrganizationModel? selectedOrganization;

  const AllowanceState({
    required this.status,
    this.message,
    this.allowancesList,
    this.organizationsList,
    this.selectedOrganization,
  });

  AllowanceState copyWith({
    FormzStatus? status,
    String? message,
    List<AllowanceModel>? allowancesList,
    List<OrganizationModel>? organizationsList,
    OrganizationModel? selectedOrganization,
  }) {
    return AllowanceState(
      status: status ?? this.status,
      message: message ?? this.message,
      allowancesList: allowancesList ?? this.allowancesList,
      organizationsList: organizationsList ?? this.organizationsList,
      selectedOrganization: selectedOrganization ?? this.selectedOrganization,
    );
  }

  @override
  List<Object?> get props => [
        status,
        message,
        allowancesList,
        organizationsList,
        selectedOrganization,
      ];
}
