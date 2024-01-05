part of 'organization_bloc.dart';

class OrganizationState extends Equatable {
  final FormzStatus status;
  final String? message;
  final List<OrganizationModel>? organizationsList;

  const OrganizationState({
    this.status = FormzStatus.pure,
    this.message,
    this.organizationsList,
  });

  OrganizationState copyWith({
    FormzStatus? status,
    String? message,
    List<OrganizationModel>? organizationsList,
  }) {
    return OrganizationState(
      status: status ?? this.status,
      message: message ?? this.message,
      organizationsList: organizationsList ?? this.organizationsList,
    );
  }

  @override
  List<Object?> get props => [
        status,
        message,
        organizationsList,
      ];
}
