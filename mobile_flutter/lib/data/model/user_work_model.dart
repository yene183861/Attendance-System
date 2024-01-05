import 'package:equatable/equatable.dart';
import 'package:g_json/g_json.dart';
import 'package:firefly/data/enum_type/user_type.dart';
import 'package:firefly/data/enum_type/work_status.dart';
import 'package:firefly/data/model/branch_office_model.dart';
import 'package:firefly/data/model/department_model.dart';
import 'package:firefly/data/model/organization_model.dart';
import 'package:firefly/data/model/team_model.dart';
import 'package:firefly/data/model/user_model.dart';

class UserWorkModel extends Equatable {
  final int? id;
  final UserModel? user;
  final TeamModel? team;
  final DepartmentModel? department;
  final BranchOfficeModel? branchOffice;
  final OrganizationModel? organization;

  final UserType? userType;
  final String? position;
  final WorkStatus? workStatus;
  final String? reason;

  const UserWorkModel({
    this.id,
    this.user,
    this.team,
    this.department,
    this.branchOffice,
    this.organization,
    this.userType,
    this.position,
    this.workStatus,
    this.reason,
  });

  factory UserWorkModel.fromJson(JSON json) {
    return UserWorkModel(
      id: json['id'].integerValue,
      organization: OrganizationModel.fromJson(json['organization']),
      branchOffice: BranchOfficeModel.fromJson(json['branch_office']),
      department: DepartmentModel.fromJson(json['department']),
      team: TeamModel.fromJson(json['team']),
      user: UserModel.fromJson(json['user']),
      userType: UserTypeHelper.convertType(json['user_type'].integerValue),
      position: json['position'].stringValue,
      workStatus:
          WorkStatusHelper.convertType(json['work_status'].integerValue),
      reason: json['reason'].stringValue,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    data['id'] = id;
    data['user'] = user?.id;
    data['organization'] = organization?.id;
    data['branch_office'] = branchOffice?.id;
    data['department'] = department?.id;
    data['team'] = team?.id;
    data['user_type'] = userType?.type;
    data['position'] = position;
    data['work_status'] = workStatus?.type;
    data['reason'] = reason;

    return data;
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        id,
        organization,
        branchOffice,
        department,
        team,
        user,
        userType,
        position,
        workStatus,
        reason,
      ];
}
