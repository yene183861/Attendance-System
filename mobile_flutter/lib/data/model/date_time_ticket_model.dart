import 'package:equatable/equatable.dart';
import 'package:firefly/utils/pattern.dart';
import 'package:firefly/utils/utils.dart';
import 'package:g_json/g_json.dart';
import 'package:firefly/data/model/ticket_reason_model.dart';
import 'package:intl/intl.dart';

class DateTimeTicketModel extends Equatable {
  final int? id;
  final int? ticketId;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final TicketReasonModel ticketReason;

  const DateTimeTicketModel({
    this.id,
    this.ticketId,
    required this.startDateTime,
    required this.endDateTime,
    required this.ticketReason,
  });

  factory DateTimeTicketModel.fromJson(JSON json) {
    return DateTimeTicketModel(
      id: json['id'].integerValue,
      ticketId: json['ticket'].integerValue,
      startDateTime: DateFormat(DateTimePattern.dateFormatPromotion3)
          .parse(json['start_date_time'].stringValue),
      endDateTime: DateFormat(DateTimePattern.dateFormatPromotion3)
          .parse(json['end_date_time'].stringValue),
      ticketReason: TicketReasonModel.fromJson(json['ticket_reason']),
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['ticket'] = ticketId;
    data['start_date_time'] = Utils.formatDateTimeToString(
        time: startDateTime,
        dateFormat: DateFormat(DateTimePattern.dateFormatPromotion3));
    data['end_date_time'] = Utils.formatDateTimeToString(
        time: endDateTime,
        dateFormat: DateFormat(DateTimePattern.dateFormatPromotion3));
    data['ticket_reason'] = ticketReason.id;

    return data;
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        id,
        ticketId,
        endDateTime,
        startDateTime,
        ticketReason,
      ];
}
