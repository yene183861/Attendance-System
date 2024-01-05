import 'package:equatable/equatable.dart';
import 'package:g_json/g_json.dart';

import 'package:firefly/data/enum_type/by_time.dart';
import 'package:firefly/data/enum_type/ticket_type.dart';

class TicketReasonModel extends Equatable {
  final int? id;
  final int organizationId;
  final TicketType ticketType;
  final String name;
  final bool isWorkCalculation;
  final String? description;
  final int maximum;
  final ByTime byTime;

  const TicketReasonModel({
    this.id,
    required this.organizationId,
    this.description,
    required this.ticketType,
    required this.name,
    this.isWorkCalculation = false,
    required this.maximum,
    required this.byTime,
  });

  factory TicketReasonModel.fromJson(JSON json) {
    return TicketReasonModel(
      id: json['id'].integerValue,
      organizationId: json['organization'].integerValue,
      name: json['name'].stringValue,
      description: json['description'].stringValue,
      ticketType:
          TicketTypeHelper.convertType(json['ticket_type'].integerValue),
      isWorkCalculation: json['is_work_calculation'].booleanValue,
      maximum: json['maximum'].integerValue,
      byTime: ByTimeHelper.convertType(json['by_time'].integerValue),
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    data['id'] = id;
    data['organization'] = organizationId;
    data['name'] = name;
    data['description'] = description;
    data['ticket_type'] = ticketType.type;
    data['is_work_calculation'] = isWorkCalculation;
    data['maximum'] = maximum;
    data['by_time'] = byTime.type;

    return data;
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        id,
        organizationId,
        description,
        ticketType,
        name,
        isWorkCalculation,
        maximum,
        byTime,
      ];
}
