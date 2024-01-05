part of 'edit_branch_office_bloc.dart';

class EditBranchOfficeState extends Equatable {
  final FormzStatus status;
  final String? message;

  final EditBranchArgument editBranchArgument;

  const EditBranchOfficeState({
    this.status = FormzStatus.pure,
    this.message,
    required this.editBranchArgument,
  });

  EditBranchOfficeState copyWith({
    FormzStatus? status,
    String? message,
    EditBranchArgument? editBranchArgument,
  }) {
    return EditBranchOfficeState(
      status: status ?? this.status,
      message: message ?? this.message,
      editBranchArgument: editBranchArgument ?? this.editBranchArgument,
    );
  }

  @override
  List<Object?> get props => [
        status,
        message,
        editBranchArgument,
      ];
}
