import 'package:equatable/equatable.dart';
import 'package:g_json/g_json.dart';

import 'package:firefly/data/enum_type/ticket_status.dart';
import 'package:firefly/data/enum_type/ticket_type.dart';
import 'package:firefly/data/model/date_time_ticket_model.dart';
import 'package:firefly/data/model/user_model.dart';

class TicketModel extends Equatable {
  final int? id;
  final UserModel? user;
  final TicketType ticketType;
  final String? description;
  final TicketStatus status;
  final UserModel? reviewer;
  final String? reviewerOpinions;
  final List<DateTimeTicketModel>? dateTimeTickets;
  // final List<TicketModel>?

  const TicketModel({
    this.id,
    this.user,
    this.description,
    required this.ticketType,
    this.status = TicketStatus.PENDING,
    this.reviewer,
    this.reviewerOpinions,
    this.dateTimeTickets,
  });

  factory TicketModel.fromJson(JSON json) {
    return TicketModel(
      id: json['id'].integerValue,
      user: UserModel.fromJson(json['user']),
      ticketType:
          TicketTypeHelper.convertType(json['ticket_type'].integerValue),
      description: json['description'].stringValue,
      status: TicketStatusHelper.convertType(json['status'].integerValue),
      reviewer: UserModel.fromJson(json['reviewer']),
      reviewerOpinions: json['reviewer_opinions'].stringValue,
      dateTimeTickets: json['date_time_tickets']
          .listValue
          .map((e) => DateTimeTicketModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    data['id'] = id;
    data['user'] = user?.id;
    data['status'] = status.type;
    data['description'] = description;
    data['ticket_type'] = ticketType.type;
    data['reviewer'] = reviewer?.id;
    data['reviewer_opinions'] = reviewerOpinions;
    data['date_time_tickets'] =
        dateTimeTickets?.map((e) => e.toJson()).toList();

    return data;
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        id,
        user,
        description,
        ticketType,
        status,
        reviewer,
        reviewerOpinions,
        dateTimeTickets,
      ];
}
