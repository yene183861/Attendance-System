import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:g_json/g_json.dart';
import 'package:firefly/data/model/user_model.dart';
import 'package:firefly/utils/pattern.dart';
import 'package:firefly/utils/utils.dart';

class RewardOrDisciplineModel extends Equatable {
  final int? id;
  final UserModel user;
  final String title;
  final String content;
  final double amount;
  final DateTime month;
  final bool isReward;

  const RewardOrDisciplineModel({
    this.id,
    required this.user,
    required this.title,
    required this.content,
    required this.amount,
    required this.month,
    this.isReward = true,
  });

  factory RewardOrDisciplineModel.fromJson(JSON json) {
    return RewardOrDisciplineModel(
      id: json['id'].integerValue,
      user: UserModel.fromJson(json['user']),
      content: json['content'].stringValue,
      title: json['title'].stringValue,
      amount: json['amount'].ddoubleValue,
      month: DateTime.parse(json['month'].stringValue),
      isReward: json['is_reward'].booleanValue,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['user'] = user.id;
    data['title'] = title;
    data['content'] = content;
    data['amount'] = amount;
    data['month'] = Utils.formatDateTimeToString(
      time: month,
      dateFormat: DateFormat(
        DateTimePattern.dayType2,
      ),
    );
    data['is_reward'] = isReward;
    return data;
  }

  RewardOrDisciplineModel copyWith({
    int? id,
    UserModel? user,
    String? title,
    String? content,
    double? amount,
    DateTime? month,
    bool? isReward,
  }) {
    return RewardOrDisciplineModel(
      id: id ?? this.id,
      user: user ?? this.user,
      title: title ?? this.title,
      content: content ?? this.content,
      amount: amount ?? this.amount,
      month: month ?? this.month,
      isReward: isReward ?? this.isReward,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        id,
        user,
        title,
        content,
        amount,
        month,
        isReward,
      ];
}
