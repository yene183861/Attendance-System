part of 'edit_organization_bloc.dart';

abstract class EditOrganizationEvent extends Equatable {
  const EditOrganizationEvent();
}

class UpdateOrganizationEvent extends EditOrganizationEvent {
  final EditOrganizationParam params;
  const UpdateOrganizationEvent({required this.params});

  @override
  List<Object?> get props => [params];
}

class CreateOrganizationEvent extends EditOrganizationEvent {
  final EditOrganizationParam organization;
  const CreateOrganizationEvent({required this.organization});
  @override
  List<Object?> get props => [organization];
}

class UpdateLogoEvent extends EditOrganizationEvent {
  final File? logo;
  const UpdateLogoEvent({this.logo});
  @override
  List<Object?> get props => [logo];
}
