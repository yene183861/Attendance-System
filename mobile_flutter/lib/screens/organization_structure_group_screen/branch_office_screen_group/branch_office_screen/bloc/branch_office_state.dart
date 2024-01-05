part of 'branch_office_bloc.dart';

class BranchOfficeState extends Equatable {
  final FormzStatus status;
  final String? message;
  final List<BranchOfficeModel>? branchesList;
  final int organizationId;

  const BranchOfficeState({
    this.status = FormzStatus.pure,
    this.message,
    this.branchesList,
    required this.organizationId,
  });

  BranchOfficeState copyWith({
    FormzStatus? status,
    String? message,
    List<BranchOfficeModel>? branchesList,
    int? organizationId,
  }) {
    return BranchOfficeState(
      status: status ?? this.status,
      message: message ?? this.message,
      branchesList: branchesList ?? this.branchesList,
      organizationId: organizationId ?? this.organizationId,
    );
  }

  @override
  List<Object?> get props => [
        status,
        message,
        branchesList,
        organizationId,
      ];
}
