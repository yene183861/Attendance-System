import 'package:flutter/material.dart';
import 'package:firefly/configs/resources/barrel_const.dart';
import 'package:firefly/custom_widget/primary_button.dart';
import 'package:firefly/data/enum_type/ticket_status.dart';
import 'package:firefly/utils/size_config.dart';

class ChangeStatusTicketWidget extends StatelessWidget {
  const ChangeStatusTicketWidget({
    super.key,
    required this.ticketStatus,
    this.approvalButton,
    this.refuseButton,
  });
  final TicketStatus ticketStatus;
  final Function? approvalButton;
  final Function? refuseButton;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (ticketStatus == TicketStatus.REFUSE ||
            ticketStatus == TicketStatus.PENDING)
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: PrimaryButton(
                    height: getProportionateScreenHeight(45),
                    title: 'Đồng ý duyệt',
                    textStyle: FONT_CONST.bold(
                        color: COLOR_CONST.backgroundColor, fontSize: 14),
                    boxDecoration: BoxDecoration(
                      color: TicketStatus.APPROVED.color,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    onPressed: () {
                      if (approvalButton != null) {
                        approvalButton!();
                      }
                    },
                  ),
                ),
                const HorizontalSpacing(),
              ],
            ),
          ),
        if (ticketStatus == TicketStatus.PENDING)
          Expanded(
            child: PrimaryButton(
              height: getProportionateScreenHeight(45),
              title: 'Từ chối duyệt',
              textStyle: FONT_CONST.bold(
                  color: COLOR_CONST.backgroundColor, fontSize: 14),
              boxDecoration: BoxDecoration(
                color: TicketStatus.REFUSE.color,
                borderRadius: BorderRadius.circular(8),
              ),
              onPressed: () {
                if (refuseButton != null) refuseButton!();
              },
            ),
          ),
      ],
    );
  }
}
