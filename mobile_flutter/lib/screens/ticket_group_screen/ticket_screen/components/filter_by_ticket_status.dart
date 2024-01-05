import 'package:easy_localization/easy_localization.dart';
import 'package:firefly/data/enum_type/ticket_status.dart';
import 'package:firefly/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:firefly/configs/resources/barrel_const.dart';
import 'package:firefly/custom_widget/custom_dropdown_button.dart';
import 'package:firefly/custom_widget/default_padding.dart';

import '../bloc/ticket_bloc.dart';

class FilterByTicketStatus extends StatelessWidget {
  const FilterByTicketStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: defaultPadding(horizontal: 20, vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Lọc theo trạng thái đơn'.tr(),
                style: FONT_CONST.regular(),
              ),
              BlocBuilder<TicketBloc, TicketState>(
                buildWhen: (previous, current) =>
                    previous.isFilterByTicketStatus !=
                    current.isFilterByTicketStatus,
                builder: (context, state) {
                  return FlutterSwitch(
                    width: 50,
                    height: 30,
                    toggleSize: 27,
                    padding: 1,
                    value: state.isFilterByTicketStatus,
                    activeColor: COLOR_CONST.cloudBurst,
                    onToggle: (value) {
                      context.ticketBloc
                          .add(IsApplyFilterTicketStatusEvent(isApply: value));
                    },
                  );
                },
              )
            ],
          ),
          BlocBuilder<TicketBloc, TicketState>(
            buildWhen: (previous, current) =>
                previous.isFilterByTicketStatus !=
                    current.isFilterByTicketStatus ||
                previous.ticketStatus != current.ticketStatus,
            builder: (context, state) {
              return !state.isFilterByTicketStatus
                  ? const SizedBox.shrink()
                  : CustomDropdownButton(
                      marginTop: 0,
                      colorBorderFocused: COLOR_CONST.cloudBurst,
                      title: null,
                      datas: TicketStatus.values
                          .map((e) => DropdownMenuItem<TicketStatus>(
                                value: e,
                                child: Text(
                                  e.value,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: FONT_CONST.regular(),
                                ),
                              ))
                          .toList(),
                      selectedDefault: state.ticketStatus,
                      onSelectionChanged: (p0) {
                        context.ticketBloc
                            .add(ChangeTicketStatusEvent(status: p0));
                      },
                    );
            },
          ),
          const VerticalSpacing(of: 10),
        ],
      ),
    );
  }
}
