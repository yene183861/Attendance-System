import 'package:equatable/equatable.dart';
import 'package:g_json/g_json.dart';
import 'package:firefly/data/enum_type/by_time.dart';

class AllowanceModel extends Equatable {
  final int? id;
  final int organizationId;
  final String name;
  final String? description;
  final double amount;
  final double maximumAmount;
  final ByTime byTime;

  const AllowanceModel({
    this.id,
    required this.organizationId,
    required this.name,
    required this.amount,
    required this.maximumAmount,
    required this.byTime,
    this.description,
  });

  factory AllowanceModel.fromJson(JSON json) {
    return AllowanceModel(
      id: json['id'].integerValue,
      name: json['name'].stringValue,
      organizationId: json['organization'].integerValue,
      amount: json['amount'].ddoubleValue,
      maximumAmount: json['maximum_amount'].ddoubleValue,
      byTime: ByTimeHelper.convertType(json['by_time'].integerValue),
      description: json['description'].stringValue,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['organization'] = organizationId;
    data['amount'] = amount;
    data['maximum_amount'] = maximumAmount;
    data['by_time'] = byTime.type;
    data['description'] = description;
    return data;
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        id,
        name,
        organizationId,
        amount,
        maximumAmount,
        byTime,
        description,
      ];
}
