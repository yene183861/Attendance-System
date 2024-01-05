import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firefly/configs/resources/barrel_const.dart';
import 'package:firefly/custom_widget/custom_dropdown_button.dart';
import 'package:firefly/data/enum_type/ticket_type.dart';
import 'package:firefly/screens/ticket_group_screen/edit_ticket_screen/bloc/edit_ticket_bloc.dart';

class TicketTypeSelect extends StatelessWidget {
  const TicketTypeSelect({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditTicketBloc, EditTicketState>(
      buildWhen: (p, c) => p.ticketType != c.ticketType,
      builder: (context, state) => CustomDropdownButton(
        marginTop: 0,
        colorBorderFocused: COLOR_CONST.cloudBurst,
        title: 'title_select_ticket_type'.tr(),
        isRequired: true,
        datas: TicketType.values
            .map((e) => DropdownMenuItem<TicketType>(
                  value: e,
                  child: Text(
                    e.value,
                    style: FONT_CONST.regular(),
                  ),
                ))
            .toList(),
        selectedDefault: state.ticketType,
        onSelectionChanged: (p0) {
          context.editTicketBloc.add(ChangeTicketTypeEvent(ticketType: p0));
        },
      ),
    );
  }
}
