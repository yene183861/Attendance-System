part of 'edit_organization_bloc.dart';

class EditOrganizationState extends Equatable {
  final FormzStatus status;
  final String? message;
  final File? logo;
  final OrganizationModel? organization;

  const EditOrganizationState({
    this.status = FormzStatus.pure,
    this.message,
    this.logo,
    this.organization,
  });

  EditOrganizationState copyWith({
    FormzStatus? status,
    String? message,
    File? logo,
    OrganizationModel? organization,
  }) {
    return EditOrganizationState(
      status: status ?? this.status,
      message: message ?? this.message,
      logo: logo ?? this.logo,
      organization: organization ?? this.organization,
    );
  }

  @override
  List<Object?> get props => [
        status,
        message,
        logo,
        organization,
      ];
}
