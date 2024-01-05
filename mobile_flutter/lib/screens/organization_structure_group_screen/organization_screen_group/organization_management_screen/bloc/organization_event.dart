part of 'organization_bloc.dart';

abstract class OrganizationEvent extends Equatable {
  const OrganizationEvent();
}

class GetOrganizationEvent extends OrganizationEvent {
  @override
  List<Object?> get props => [];
}

class DeleteOrganizationEvent extends OrganizationEvent {
  final int id;
  const DeleteOrganizationEvent({required this.id});
  @override
  List<Object?> get props => [];
}
