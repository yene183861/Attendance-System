part of 'edit_contract_bloc.dart';

class EditContractState extends Equatable {
  final FormzStatus status;
  final String? message;
  final List<UserWorkModel>? users;
  final UserWorkModel? selectedUser;
  final ContractModel? contractModel;
  final DateTime startDate;
  final DateTime? endDate;
  final DateTime? signDate;
  final ContractType contractType;

  const EditContractState({
    this.status = FormzStatus.pure,
    this.message,
    this.users,
    this.selectedUser,
    this.contractModel,
    required this.startDate,
    this.endDate,
    this.signDate,
    this.contractType = ContractType.SEASONAL_CONTRACT,
  });

  EditContractState copyWith({
    FormzStatus? status,
    String? message,
    List<UserWorkModel>? users,
    UserWorkModel? selectedUser,
    ContractModel? contractModel,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? signDate,
    ContractType? contractType,
  }) {
    return EditContractState(
      status: status ?? this.status,
      message: message ?? this.message,
      users: users ?? this.users,
      selectedUser: selectedUser ?? this.selectedUser,
      contractModel: contractModel ?? this.contractModel,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      signDate: signDate ?? this.signDate,
      contractType: contractType ?? this.contractType,
    );
  }

  @override
  List<Object?> get props => [
        status,
        message,
        users,
        selectedUser,
        contractModel,
        startDate,
        endDate,
        signDate,
        contractType,
      ];
}
