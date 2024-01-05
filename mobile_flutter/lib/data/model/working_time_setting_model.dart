import 'package:equatable/equatable.dart';
import 'package:g_json/g_json.dart';

class WorkingTimeSettingModel extends Equatable {
  final int? id;
  final int userId;
  final String startDate;
  final String endDate;
  final int settingType;
  final bool status;

  const WorkingTimeSettingModel({
    this.id,
    required this.userId,
    required this.startDate,
    required this.endDate,
    required this.settingType,
    required this.status,
  });

  factory WorkingTimeSettingModel.fromJson(JSON json) {
    return WorkingTimeSettingModel(
      id: json['id'].integerValue,
      userId: json['user'].integerValue,
      startDate: json['start_date'].stringValue,
      endDate: json['end_date'].stringValue,
      settingType: json['setting_type'].integerValue,
      status: json['status'].booleanValue,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    data['id'] = id;
    data['user'] = userId;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['setting_type'] = settingType;
    data['status'] = status;

    return data;
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        id,
        userId,
        startDate,
        endDate,
        settingType,
        status,
      ];
}
