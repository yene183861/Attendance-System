part of 'department_bloc.dart';

abstract class DepartmentEvent extends Equatable {
  const DepartmentEvent();
}

class GetDepartmentEvent extends DepartmentEvent {
  @override
  List<Object?> get props => [];
}

class DeleteDepartmentEvent extends DepartmentEvent {
  final int id;
  const DeleteDepartmentEvent({required this.id});
  @override
  List<Object?> get props => [];
}

class UpdateDepartmentEvent extends DepartmentEvent {
  final String name;
  final int id;
  const UpdateDepartmentEvent({required this.name, required this.id});

  @override
  List<Object?> get props => [name, id];
}

class CreateDepartmentEvent extends DepartmentEvent {
  final String name;
  const CreateDepartmentEvent({required this.name});
  @override
  List<Object?> get props => [name];
}
