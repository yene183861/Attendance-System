part of 'branch_office_bloc.dart';

abstract class BranchOfficeEvent extends Equatable {
  const BranchOfficeEvent();
}

class GetBranchOfficeEvent extends BranchOfficeEvent {
  @override
  List<Object?> get props => [];
}

class DeleteBranchOfficeEvent extends BranchOfficeEvent {
  final int id;
  const DeleteBranchOfficeEvent({required this.id});
  @override
  List<Object?> get props => [];
}

class UpdateBranchEvent extends BranchOfficeEvent {
  final BranchOfficeModel branch;
  final int id;
  const UpdateBranchEvent({required this.branch, required this.id});

  @override
  List<Object?> get props => [branch, id];
}

class CreateBranchEvent extends BranchOfficeEvent {
  final BranchOfficeModel branch;
  const CreateBranchEvent({required this.branch});
  @override
  List<Object?> get props => [branch];
}
