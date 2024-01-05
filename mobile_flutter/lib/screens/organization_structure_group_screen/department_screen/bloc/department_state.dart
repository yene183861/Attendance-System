part of 'department_bloc.dart';

class DepartmentState extends Equatable {
  final FormzStatus status;
  final String? message;
  final List<DepartmentModel>? departmentsList;
  final int branchId;

  const DepartmentState({
    this.status = FormzStatus.pure,
    this.message,
    this.departmentsList,
    required this.branchId,
  });

  DepartmentState copyWith({
    FormzStatus? status,
    String? message,
    List<DepartmentModel>? departmentsList,
    int? branchId,
  }) {
    return DepartmentState(
      status: status ?? this.status,
      message: message ?? this.message,
      departmentsList: departmentsList ?? this.departmentsList,
      branchId: branchId ?? this.branchId,
    );
  }

  @override
  List<Object?> get props => [
        status,
        message,
        departmentsList,
        branchId,
      ];
}
