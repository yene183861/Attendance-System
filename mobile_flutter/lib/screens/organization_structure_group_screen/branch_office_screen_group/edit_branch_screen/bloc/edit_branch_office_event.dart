part of 'edit_branch_office_bloc.dart';

abstract class EditBranchEvent extends Equatable {
  const EditBranchEvent();
}

class UpdateBranchEvent extends EditBranchEvent {
  final BranchOfficeModel branch;
  const UpdateBranchEvent({required this.branch});

  @override
  List<Object?> get props => [branch];
}

class CreateBranchEvent extends EditBranchEvent {
  final BranchOfficeModel branch;
  const CreateBranchEvent({required this.branch});
  @override
  List<Object?> get props => [branch];
}

class DeleteBranchEvent extends EditBranchEvent {
  final int id;
  const DeleteBranchEvent({required this.id});
  @override
  List<Object?> get props => [id];
}
