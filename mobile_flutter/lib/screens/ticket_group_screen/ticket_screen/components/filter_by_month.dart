import 'package:firefly/configs/resources/barrel_const.dart';
import 'package:firefly/custom_widget/custom_dropdown_date_picker.dart';
import 'package:firefly/custom_widget/default_padding.dart';
import 'package:firefly/utils/pattern.dart';
import 'package:firefly/utils/size_config.dart';
import 'package:firefly/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../bloc/ticket_bloc.dart';

class FilterByMonth extends StatefulWidget {
  const FilterByMonth({super.key});

  @override
  State<FilterByMonth> createState() => _FilterByMonthState();
}

class _FilterByMonthState extends State<FilterByMonth> {
  late DateRangePickerController calendarController;

  @override
  void initState() {
    super.initState();
    calendarController = DateRangePickerController();
  }

  @override
  void dispose() {
    calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: defaultPadding(horizontal: 20, vertical: 0),
      child: BlocBuilder<TicketBloc, TicketState>(
        buildWhen: (p, c) => p.month != c.month,
        builder: (context, state) => Container(
          height: 40,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: CustomDropdownDatePicker(
            maxWidthButton: 180,
            textStyleTitle: FONT_CONST.medium(),
            inputDecoration: InputDecoration(
              isDense: true,
              fillColor: Colors.grey.shade100,
              contentPadding: EdgeInsets.zero,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade100),
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade100),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            suffixIcon: const SizedBox.shrink(),
            prefixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  ICON_CONST.icCalendar.path,
                  width: 22,
                  height: 22,
                  fit: BoxFit.cover,
                ),
                const HorizontalSpacing(),
              ],
            ),
            backgroundColor: Colors.grey.shade100,
            textTime: Utils.formatDateTimeToString(
                time: state.month,
                dateFormat: DateFormat(DateTimePattern.monthYear)),
            isFullwidthDropBox: true,
            view: DateRangePickerView.year,
            isExpanded: true,
            monthFormat: DateTimePattern.monthYear,
            calendarController: calendarController,
            dateInit: context.ticketBloc.state.month,
            onSelectionChanged: (value) async {
              FocusScope.of(context).unfocus();
              context.ticketBloc.add(ChangeMonthEvent(month: value));
            },
          ),
        ),
      ),
    );
  }
}
