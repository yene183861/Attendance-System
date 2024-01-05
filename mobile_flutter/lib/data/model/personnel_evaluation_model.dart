import 'package:equatable/equatable.dart';
import 'package:g_json/g_json.dart';

class PersonnelEvaluationModel extends Equatable {
  final int? id;
  final int userId;
  final int? reviewerId;
  final bool status;
  final String month;
  final int completedBeforeDeadline;
  final int completedOnTime;
  final int completedOverdue;
  final int unfinished;
  final String? reviewerComment;
  final String? selfAssessment;

  const PersonnelEvaluationModel({
    this.id,
    required this.userId,
    this.reviewerId,
    required this.month,
    this.status = false,
    required this.completedBeforeDeadline,
    required this.completedOnTime,
    required this.completedOverdue,
    required this.unfinished,
    this.reviewerComment,
    this.selfAssessment,
  });

  factory PersonnelEvaluationModel.fromJson(JSON json) {
    return PersonnelEvaluationModel(
      id: json['id'].integerValue,
      userId: json['user'].integerValue,
      reviewerId: json['reviewer'].integerValue,
      month: json['month'].stringValue,
      status: json['status'].booleanValue,
      completedBeforeDeadline: json['completed_before_deadline'].integerValue,
      completedOnTime: json['completed_on_time'].integerValue,
      completedOverdue: json['completed_overdue'].integerValue,
      unfinished: json['unfinished'].integerValue,
      reviewerComment: json['reviewer_comment'].stringValue,
      selfAssessment: json['self_assessment'].stringValue,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    data['user'] = userId;
    data['reviewer'] = reviewerId;
    data['month'] = month;
    data['status'] = status;
    data['completed_before_deadline'] = completedBeforeDeadline;
    data['completed_on_time'] = completedOnTime;
    data['completed_overdue'] = completedOverdue;
    data['unfinished'] = unfinished;
    data['reviewer_comment'] = reviewerComment;
    data['self_assessment'] = selfAssessment;

    return data;
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        id,
        userId,
        reviewerId,
        month,
        status,
        completedBeforeDeadline,
        completedOnTime,
        completedOverdue,
        unfinished,
        reviewerComment,
        selfAssessment,
      ];
}
