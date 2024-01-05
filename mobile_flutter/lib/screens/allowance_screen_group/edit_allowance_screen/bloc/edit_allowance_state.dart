part of 'edit_allowance_bloc.dart';

class EditAllowanceState extends Equatable {
  final FormzStatus status;
  final String? message;
  final EditAllowanceArgument? editAllowanceArgument;
  final ByTime byTime;

  const EditAllowanceState({
    required this.status,
    this.message,
    this.editAllowanceArgument,
    required this.byTime,
  });

  EditAllowanceState copyWith({
    FormzStatus? status,
    String? message,
    EditAllowanceArgument? editAllowanceArgument,
    ByTime? byTime,
  }) {
    return EditAllowanceState(
      status: status ?? this.status,
      message: message ?? this.message,
      editAllowanceArgument:
          editAllowanceArgument ?? this.editAllowanceArgument,
      byTime: byTime ?? this.byTime,
    );
  }

  @override
  List<Object?> get props => [
        status,
        message,
        editAllowanceArgument,
        byTime,
      ];
}
