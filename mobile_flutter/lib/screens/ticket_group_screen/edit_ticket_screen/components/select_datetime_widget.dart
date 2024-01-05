import 'package:easy_localization/easy_localization.dart';
import 'package:firefly/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firefly/configs/resources/barrel_const.dart';
import 'package:firefly/custom_widget/custom_dropdown_button.dart';
import 'package:firefly/data/enum_type/ticket_type.dart';
import 'package:firefly/screens/ticket_group_screen/edit_ticket_screen/bloc/edit_ticket_bloc.dart';
import 'package:firefly/screens/ticket_group_screen/edit_ticket_screen/components/bottom_sheet_select_date.dart';
import 'package:firefly/screens/ticket_group_screen/edit_ticket_screen/components/select_date_field.dart';
import 'package:firefly/utils/pattern.dart';
import 'package:firefly/utils/utils.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class SelectDateTimeWidget extends StatefulWidget {
  const SelectDateTimeWidget({
    super.key,
  });

  @override
  State<SelectDateTimeWidget> createState() => _SelectDateTimeWidgetState();
}

class _SelectDateTimeWidgetState extends State<SelectDateTimeWidget> {
  late DateRangePickerController startDateController, endDateController;

  @override
  void initState() {
    super.initState();
    startDateController = DateRangePickerController();
    endDateController = DateRangePickerController();
  }

  @override
  void dispose() {
    super.dispose();
    startDateController.dispose();
    endDateController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<EditTicketBloc, EditTicketState>(
              buildWhen: (p, c) => p.startDate != c.startDate,
              builder: (context, state) => SelectDateWidget(
                title: 'msg_start_date'.tr(),
                date: Utils.formatDateTimeToString(
                    time: state.startDate!,
                    dateFormat: DateFormat(DateTimePattern.dayType1)),
                onTap: () {
                  showModalBottomSheet(
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12))),
                      backgroundColor: Colors.white,
                      context: context,
                      builder: (_) {
                        return BlocProvider.value(
                          value: context.editTicketBloc,
                          child: BottomSheetSelectDate(
                              dateController: startDateController,
                              description: 'msg_start_date'.tr()),
                        );
                      });
                },
              ),
            ),
            const HorizontalSpacing(of: 10),
            BlocBuilder<EditTicketBloc, EditTicketState>(
              buildWhen: (p, c) => p.ticketType != c.ticketType,
              builder: (context, state) =>
                  state.ticketType == TicketType.APPLICATION_FOR_THOUGHT ||
                          state.ticketType == TicketType.CHECK_IN_OUT_FORM
                      ? const Expanded(child: StartTimeWidget())
                      : const SizedBox.shrink(),
            ),
          ],
        ),
        BlocBuilder<EditTicketBloc, EditTicketState>(
            buildWhen: (p, c) =>
                p.ticketType != c.ticketType || p.endDate != c.endDate,
            builder: (context, state) => state.ticketType !=
                    TicketType.CHECK_IN_OUT_FORM
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      state.ticketType != TicketType.APPLICATION_FOR_THOUGHT
                          ? Container(
                              margin: const EdgeInsets.only(top: 15),
                              // height: 65,
                              child: const StartTimeWidget(),
                            )
                          : SelectDateWidget(
                              title: 'msg_end_date'.tr(),
                              date: Utils.formatDateTimeToString(
                                  time: state.endDate!,
                                  dateFormat:
                                      DateFormat(DateTimePattern.dayType1)),
                              onTap: () {
                                showModalBottomSheet(
                                    isScrollControlled: true,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(12),
                                            topRight: Radius.circular(12))),
                                    backgroundColor: Colors.white,
                                    context: context,
                                    builder: (_) {
                                      return BlocProvider.value(
                                        value: context.editTicketBloc,
                                        child: BottomSheetSelectDate(
                                            description: 'msg_end_date'.tr(),
                                            dateController: endDateController,
                                            startDate: false),
                                      );
                                    });
                              },
                            ),
                      const HorizontalSpacing(of: 10),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(
                              top: state.ticketType !=
                                      TicketType.APPLICATION_FOR_THOUGHT
                                  ? 15
                                  : 0),
                          child: BlocBuilder<EditTicketBloc, EditTicketState>(
                            buildWhen: (p, c) =>
                                //     p.timeList != c.timeList ||
                                //     p.endDate != c.endDate ||
                                p.status != c.status,
                            builder: (context, state) {
                              print('co build lại hay không');
                              print(state.endTime);
                              return CustomDropdownButton(
                                marginTop: 0,
                                maxWidthButton: 150,
                                isExpanded: true,
                                colorBorderFocused: COLOR_CONST.cloudBurst,
                                title: 'msg_end_time'.tr(),
                                datas: (state.timeList ?? [])
                                    .map((e) => DropdownMenuItem<String>(
                                          value: e,
                                          child: Text(
                                            e,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: FONT_CONST.regular(),
                                          ),
                                        ))
                                    .toList(),
                                selectedDefault: (state.endTime != null &&
                                        state.endTime!.isNotEmpty)
                                    ? state.endTime
                                    : null,
                                onSelectionChanged: (p0) {
                                  context.editTicketBloc
                                      .add(ChangeEndTimeEvent(endTime: p0));
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  )
                : const SizedBox.shrink()),
      ],
    );
  }
}

class StartTimeWidget extends StatelessWidget {
  const StartTimeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditTicketBloc, EditTicketState>(
      buildWhen: (p, c) =>
          //     p.timeList != c.timeList ||
          //     p.startDate != c.startDate ||
          p.status != c.status,
      builder: (context, state) => CustomDropdownButton(
        marginTop: 0,
        maxWidthButton: 150,
        isExpanded: true,
        colorBorderFocused: COLOR_CONST.cloudBurst,
        title: 'msg_start_time'.tr(),
        datas: (state.timeList ?? [])
            .map((e) => DropdownMenuItem<String>(
                  value: e,
                  child: Text(
                    e,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: FONT_CONST.regular(),
                  ),
                ))
            .toList(),
        selectedDefault:
            (state.startTime != null && state.startTime!.isNotEmpty)
                ? state.startTime
                : null,
        onSelectionChanged: (p0) {
          context.editTicketBloc.add(ChangeStartTimeEvent(startTime: p0));
        },
      ),
    );
  }
}
