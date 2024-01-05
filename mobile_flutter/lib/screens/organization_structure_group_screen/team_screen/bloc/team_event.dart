part of 'team_bloc.dart';

abstract class TeamEvent extends Equatable {
  const TeamEvent();
}

class GetTeamEvent extends TeamEvent {
  @override
  List<Object?> get props => [];
}

class DeleteTeamEvent extends TeamEvent {
  final int id;
  const DeleteTeamEvent({required this.id});
  @override
  List<Object?> get props => [];
}

class UpdateTeamEvent extends TeamEvent {
  final String name;
  final int id;
  const UpdateTeamEvent({required this.name, required this.id});

  @override
  List<Object?> get props => [name, id];
}

class CreateTeamEvent extends TeamEvent {
  final String name;
  const CreateTeamEvent({required this.name});
  @override
  List<Object?> get props => [name];
}
