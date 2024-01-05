import 'package:firefly/data/enum_type/ticket_type.dart';
import 'package:firefly/data/model/organization_model.dart';
import 'package:firefly/data/model/ticket_model.dart';
import 'package:firefly/data/model/ticket_reason_model.dart';

class EditTicketArgument {
  OrganizationModel? organization;
  TicketReasonModel? ticketReasonModel;
  TicketType? ticketType;
  TicketModel? ticket;

  EditTicketArgument({
    this.organization,
    this.ticketReasonModel,
    this.ticketType,
    this.ticket,
  });
}
