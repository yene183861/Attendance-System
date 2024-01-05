import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firefly/configs/resources/barrel_const.dart';
import 'package:firefly/custom_widget/custom_dropdown_button.dart';
import 'package:firefly/data/model/ticket_reason_model.dart';
import 'package:firefly/screens/ticket_group_screen/edit_ticket_screen/bloc/edit_ticket_bloc.dart';

class TicketReasonSelect extends StatelessWidget {
  const TicketReasonSelect({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditTicketBloc, EditTicketState>(
      buildWhen: (p, c) =>
          p.ticketReasonsList != c.ticketReasonsList ||
          p.selectedTicketReason != c.selectedTicketReason,
      builder: (context, state) => CustomDropdownButton(
        marginTop: 0,
        colorBorderFocused: COLOR_CONST.cloudBurst,
        title: 'title_reason'.tr(),
        isRequired: true,
        datas: (state.ticketReasonsList ?? [])
            .map((e) => DropdownMenuItem<TicketReasonModel>(
                  value: e,
                  child: Text(
                    e.name,
                    style: FONT_CONST.regular(),
                  ),
                ))
            .toList(),
        selectedDefault: state.selectedTicketReason,
        onSelectionChanged: (p0) {
          if (p0 is TicketReasonModel) {
            context.editTicketBloc
                .add(ChangeTicketReasonEvent(tickerReason: p0));
          }
        },
      ),
    );
  }
}
