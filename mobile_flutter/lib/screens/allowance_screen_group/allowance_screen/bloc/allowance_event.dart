part of 'allowance_bloc.dart';

abstract class AllowanceEvent {}

class InitAllowanceEvent extends AllowanceEvent {
  InitAllowanceEvent();
}

class GetAllowanceEvent extends AllowanceEvent {
  GetAllowanceEvent();
}

class GetOrganizationEvent extends AllowanceEvent {
  GetOrganizationEvent();
}

class ChangeOrganizationEvent extends AllowanceEvent {
  final OrganizationModel organizationModel;
  ChangeOrganizationEvent({required this.organizationModel});
}

class CreateAllowanceEvent extends AllowanceEvent {
  final AllowanceModel allowanceModel;

  CreateAllowanceEvent({required this.allowanceModel});
}
