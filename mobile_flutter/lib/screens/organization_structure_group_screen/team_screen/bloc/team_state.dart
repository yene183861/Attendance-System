part of 'team_bloc.dart';

class TeamState extends Equatable {
  final FormzStatus status;
  final String? message;
  final List<TeamModel>? teamsList;
  final int departmentId;

  const TeamState({
    this.status = FormzStatus.pure,
    this.message,
    this.teamsList,
    required this.departmentId,
  });

  TeamState copyWith({
    FormzStatus? status,
    String? message,
    List<TeamModel>? teamsList,
    int? departmentId,
  }) {
    return TeamState(
      status: status ?? this.status,
      message: message ?? this.message,
      teamsList: teamsList ?? this.teamsList,
      departmentId: departmentId ?? this.departmentId,
    );
  }

  @override
  List<Object?> get props => [
        status,
        message,
        teamsList,
        departmentId,
      ];
}
