import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:firefly/configs/resources/barrel_const.dart';
import 'package:firefly/custom_widget/default_padding.dart';
import 'package:firefly/custom_widget/popup_notification_custom.dart';
import 'package:firefly/custom_widget/primary_button.dart';
import 'package:firefly/data/arguments/edit_ticket_reason_arguments.dart';
import 'package:firefly/data/enum_type/by_time.dart';
import 'package:firefly/data/enum_type/ticket_type.dart';
import 'package:firefly/data/model/ticket_reason_model.dart';
import 'package:firefly/screens/app_router.dart';
import 'package:firefly/screens/ticket_group_screen/ticket_reason_screen/bloc/ticket_reason_bloc.dart';
import 'package:firefly/utils/size_config.dart';

class TicketReasonItem extends StatelessWidget {
  const TicketReasonItem({
    super.key,
    required this.ticketReason,
    this.color,
  });
  final TicketReasonModel ticketReason;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {},
      child: Ink(
        padding: defaultPadding(horizontal: 25, vertical: 20),
        color: color ?? COLOR_CONST.backgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ticketReason.name,
                      style: FONT_CONST.semoBold(
                        fontSize: 18,
                      ),
                    ),
                    const VerticalSpacing(of: 8),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(text: 'maximum'.tr()),
                          TextSpan(text: 'msg_format_easy_read'.tr()),
                          TextSpan(
                              text: '${ticketReason.maximum}',
                              style: FONT_CONST.semoBold(fontSize: 16)),
                          TextSpan(text: 'space'.tr()),
                          TextSpan(text: 'msg_day'.tr()),
                          TextSpan(text: 'slash_sign'.tr()),
                          TextSpan(
                            text: ticketReason.byTime.value,
                          ),
                        ],
                      ),
                      style: FONT_CONST.medium(fontSize: 14),
                    ),
                    const VerticalSpacing(of: 4),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(text: 'ticket_type'.tr()),
                          TextSpan(text: 'msg_format_easy_read'.tr()),
                          TextSpan(text: ticketReason.ticketType.value),
                        ],
                      ),
                      style: FONT_CONST.medium(fontSize: 14),
                    ),
                  ],
                )),
                const HorizontalSpacing(of: 15),
                Container(
                  alignment: Alignment.centerRight,
                  padding: defaultPadding(horizontal: 15, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: ticketReason.isWorkCalculation
                        ? Colors.green.withOpacity(0.3)
                        : Colors.amber.withOpacity(0.3),
                  ),
                  child: Text(
                    ticketReason.isWorkCalculation
                        ? 'work_calculation'.tr()
                        : 'not_work_calculation'.tr(),
                    textAlign: TextAlign.center,
                    style: FONT_CONST.semoBold(fontSize: 14),
                  ),
                )
              ],
            ),
            if (ticketReason.description != null &&
                ticketReason.description!.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(top: getProportionateScreenHeight(4)),
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: 'extra_description'.tr()),
                      TextSpan(text: 'msg_format_easy_read'.tr()),
                      TextSpan(text: ticketReason.description),
                    ],
                  ),
                  style: FONT_CONST.medium(fontSize: 14),
                ),
              ),
            const VerticalSpacing(of: 15),
            Row(
              children: [
                PrimaryBorderButton(
                  title: 'delete'.tr(),
                  width: SizeConfig.screenWidth * 0.2,
                  height: 30,
                  boxDecoration: BoxDecoration(
                    color: Colors.red.shade400,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  textStyle: FONT_CONST.regular(color: COLOR_CONST.white),
                  onPressed: () {
                    PopupNotificationCustom.showMessgae(
                      title: 'msg_confirm_delete'.tr(),
                      message: 'note_delete_ticket_reason'.tr(),
                      hiddenButtonRight: false,
                      pressButtonRight: () {
                        context.ticketReasonBloc
                            .add(DeleteTicketReasonEvent(id: ticketReason.id!));
                      },
                    );
                  },
                ),
                const HorizontalSpacing(),
                PrimaryButton(
                  title: 'update'.tr(),
                  width: SizeConfig.screenWidth * 0.35,
                  height: 30,
                  boxDecoration: BoxDecoration(
                    color: COLOR_CONST.cloudBurst.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: FONT_CONST.regular(color: COLOR_CONST.white),
                  onPressed: () async {
                    final value = await Navigator.of(context).pushNamed(
                      AppRouter.EDIT_TICKET_REASON_SCREEN,
                      arguments: EditTicketReasonArgument(
                          ticketReasonModel: ticketReason,
                          organization: context
                              .ticketReasonBloc.state.selectedOrganization),
                    );
                    if (value == true) {
                      context.ticketReasonBloc.add(GetTicketReasonEvent());
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
