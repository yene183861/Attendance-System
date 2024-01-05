import 'package:equatable/equatable.dart';
import 'package:firefly/data/enum_type/contract_type.dart';
import 'package:firefly/data/enum_type/ticket_status.dart';
import 'package:g_json/g_json.dart';
import 'package:intl/intl.dart';

import 'package:firefly/data/enum_type/contract_status.dart';
import 'package:firefly/utils/pattern.dart';
import 'package:firefly/utils/utils.dart';

import 'user_model.dart';

class ContractModel extends Equatable {
  final int? id;
  final int? organizationId;
  final UserModel user;
  final UserModel? creator;
  final UserModel? approve;
  final String contractCode;
  final double basicSalary;
  final double salaryCoefficient;
  final String name;
  final ContractStatus state;
  final TicketStatus status;
  final DateTime startDate;
  final DateTime? endDate;
  final DateTime? signDate;
  final ContractType contractType;
  final String? createdAt;

  const ContractModel({
    this.id,
    this.organizationId,
    required this.user,
    this.creator,
    this.approve,
    required this.contractCode,
    required this.basicSalary,
    this.salaryCoefficient = 1.0,
    required this.name,
    this.state = ContractStatus.VALID_CONTRACT,
    this.status = TicketStatus.PENDING,
    required this.startDate,
    this.endDate,
    this.signDate,
    this.contractType = ContractType.SEASONAL_CONTRACT,
    this.createdAt,
  });

  factory ContractModel.fromJson(JSON json) {
    return ContractModel(
      id: json['id'].integerValue,
      organizationId: json['organization'].integerValue,
      user: UserModel.fromJson(json['user']),
      creator: UserModel.fromJson(json['creator']),
      approve: UserModel.fromJson(json['approve']),
      contractCode: json['contract_code'].stringValue,
      basicSalary: json['basic_salary'].ddoubleValue,
      salaryCoefficient: json['salary_coefficient'].ddoubleValue,
      name: json['name'].stringValue,
      state: ContractStatusHelper.convertType(json['state'].integerValue),
      status: TicketStatusHelper.convertType(json['status'].integerValue),
      startDate: DateTime.parse(json['start_date'].stringValue),
      endDate: DateTime.parse(json['end_date'].stringValue),
      signDate: DateTime.parse(json['sign_date'].stringValue),
      contractType:
          ContractTypeHelper.convertType(json['contract_type'].integerValue),
      createdAt: json['created_at'].stringValue,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['organization'] = organizationId;
    data['user'] = user.id;
    data['creator'] = creator?.id;
    data['approve'] = approve?.id;
    data['contract_code'] = contractCode;
    data['basic_salary'] = basicSalary;
    data['salary_coefficient'] = salaryCoefficient;
    data['name'] = name;
    data['state'] = state.type;
    data['status'] = status.type;
    data['start_date'] = Utils.formatDateTimeToString(
        time: startDate,
        dateFormat: DateFormat(
          DateTimePattern.dayType2,
        ));
    if (endDate != null) {
      data['end_date'] = Utils.formatDateTimeToString(
          time: endDate!,
          dateFormat: DateFormat(
            DateTimePattern.dayType2,
          ));
    }
    if (signDate != null) {
      data['sign_date'] = Utils.formatDateTimeToString(
          time: signDate!,
          dateFormat: DateFormat(
            DateTimePattern.dayType2,
          ));
    }
    data['contract_type'] = contractType.type;
    data['created_at'] = createdAt;

    return data;
  }

  ContractModel copyWith({
    int? id,
    int? organizationId,
    UserModel? user,
    UserModel? creator,
    UserModel? approve,
    String? contractCode,
    double? basicSalary,
    double? salaryCoefficient,
    String? name,
    ContractStatus? state,
    TicketStatus? status,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? signDate,
    ContractType? contractType,
    String? createdAt,
  }) {
    return ContractModel(
      id: id ?? this.id,
      organizationId: organizationId ?? this.organizationId,
      user: user ?? this.user,
      creator: creator ?? this.creator,
      approve: approve ?? this.approve,
      contractCode: contractCode ?? this.contractCode,
      basicSalary: basicSalary ?? this.basicSalary,
      salaryCoefficient: salaryCoefficient ?? this.salaryCoefficient,
      name: name ?? this.name,
      state: state ?? this.state,
      status: status ?? this.status,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      signDate: signDate ?? this.signDate,
      contractType: contractType ?? this.contractType,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        id,
        organizationId,
        user,
        creator,
        approve,
        contractCode,
        basicSalary,
        salaryCoefficient,
        name,
        state,
        status,
        startDate,
        endDate,
        signDate,
        contractType,
        createdAt,
      ];
}
