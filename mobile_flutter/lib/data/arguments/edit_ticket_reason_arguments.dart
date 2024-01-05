import 'package:firefly/data/enum_type/by_time.dart';
import 'package:firefly/data/enum_type/ticket_type.dart';
import 'package:firefly/data/model/organization_model.dart';
import 'package:firefly/data/model/ticket_reason_model.dart';

class EditTicketReasonArgument {
  OrganizationModel? organization;
  TicketReasonModel? ticketReasonModel;
  TicketType? ticketType;
  ByTime? byTime;

  EditTicketReasonArgument({
    this.organization,
    this.ticketReasonModel,
    this.ticketType,
    this.byTime,
  });
}
