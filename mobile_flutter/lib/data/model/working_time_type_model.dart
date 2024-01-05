import 'package:equatable/equatable.dart';
import 'package:g_json/g_json.dart';

class WorkingTimeTypeModel extends Equatable {
  final int? id;
  final int organizationId;
  final String startTime;
  final String endTime;
  final String breakTime;
  final bool status;
  final bool isDefault;

  const WorkingTimeTypeModel({
    this.id,
    required this.organizationId,
    required this.startTime,
    required this.endTime,
    required this.breakTime,
    required this.status,
    required this.isDefault,
  });

  factory WorkingTimeTypeModel.fromJson(JSON json) {
    return WorkingTimeTypeModel(
      id: json['id'].integerValue,
      startTime: json['start_time'].stringValue,
      organizationId: json['organization'].integerValue,
      endTime: json['end_time'].stringValue,
      breakTime: json['break_time'].stringValue,
      status: json['status'].booleanValue,
      isDefault: json['default'].booleanValue,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    data['id'] = id;
    data['start_time'] = startTime;
    data['organization'] = organizationId;
    data['end_time'] = endTime;
    data['break_time'] = breakTime;
    data['status'] = status;
    data['default'] = isDefault;
    return data;
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        id,
        organizationId,
        startTime,
        endTime,
        breakTime,
        status,
        isDefault,
      ];
}
