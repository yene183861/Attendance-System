import 'package:firefly/data/enum_type/by_time.dart';
import 'package:firefly/data/enum_type/ticket_type.dart';

class GetTicketReasonParam {
  final int organizationId;
  final ByTime? byTime;
  final TicketType? ticketType;

  GetTicketReasonParam({
    this.ticketType,
    this.byTime,
    required this.organizationId,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (ticketType != null) data['ticket_type'] = ticketType?.type;
    if (byTime != null) data['by_time'] = byTime?.type;
    data['organization_id'] = organizationId;

    return data;
  }
}
