import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:firefly/configs/resources/barrel_const.dart';
import 'package:firefly/custom_widget/custom_dropdown_button.dart';
import 'package:firefly/custom_widget/default_padding.dart';
import 'package:firefly/data/enum_type/ticket_type.dart';
import 'package:firefly/screens/ticket_group_screen/ticket_reason_screen/bloc/ticket_reason_bloc.dart';
import 'package:firefly/utils/size_config.dart';

class FilterByTicketType extends StatelessWidget {
  const FilterByTicketType({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: defaultPadding(horizontal: 25, vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'filter_by_ticket_type'.tr(),
                style: FONT_CONST.regular(),
              ),
              BlocBuilder<TicketReasonBloc, TicketReasonState>(
                buildWhen: (previous, current) =>
                    previous.isFilterByTicketType !=
                    current.isFilterByTicketType,
                builder: (context, state) {
                  return FlutterSwitch(
                    width: 50,
                    height: 30,
                    toggleSize: 27,
                    padding: 1,
                    value: state.isFilterByTicketType,
                    activeColor: COLOR_CONST.cloudBurst,
                    onToggle: (value) {
                      context.ticketReasonBloc
                          .add(IsApplyFilterTypeEvent(isApplyFilter: value));
                    },
                  );
                },
              )
            ],
          ),
          BlocBuilder<TicketReasonBloc, TicketReasonState>(
            buildWhen: (previous, current) =>
                previous.isFilterByTicketType != current.isFilterByTicketType ||
                previous.ticketType != current.ticketType,
            builder: (context, state) {
              return !state.isFilterByTicketType
                  ? const SizedBox.shrink()
                  : CustomDropdownButton(
                      marginTop: 0,
                      colorBorderFocused: COLOR_CONST.cloudBurst,
                      title: null,
                      datas: TicketType.values
                          .map((e) => DropdownMenuItem<TicketType>(
                                value: e,
                                child: Text(
                                  e.value,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: FONT_CONST.regular(),
                                ),
                              ))
                          .toList(),
                      selectedDefault: state.ticketType,
                      onSelectionChanged: (p0) {
                        context.ticketReasonBloc
                            .add(ChangeTicketTypeEvent(ticketType: p0));
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
