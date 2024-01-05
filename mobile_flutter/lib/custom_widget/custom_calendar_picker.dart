import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../configs/resources/barrel_const.dart';

class CustomCalendarPicker extends StatelessWidget {
  const CustomCalendarPicker({
    super.key,
    this.onSelectionChanged,
    required this.initialSelectedDate,
    this.controller,
    this.enablePastDates,
    this.selectableDayPredicate,
    this.monthFormat,
    this.view,
  });

  final void Function(DateRangePickerSelectionChangedArgs)? onSelectionChanged;
  final DateTime initialSelectedDate;
  final DateRangePickerController? controller;
  final bool? enablePastDates;
  final bool Function(DateTime)? selectableDayPredicate;
  final String? monthFormat;
  final DateRangePickerView? view;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      color: COLOR_CONST.backgroundColor,
      child: SingleChildScrollView(
        child: SfDateRangePicker(
          onSelectionChanged: (args) {
            controller?.displayDate = args.value;
            if (onSelectionChanged != null) {
              onSelectionChanged!(args);
            }
          },
          view: view ?? DateRangePickerView.month,
          monthFormat: monthFormat,
          selectionMode: DateRangePickerSelectionMode.single,
          showNavigationArrow: true,
          selectionShape: DateRangePickerSelectionShape.circle,
          selectionColor: COLOR_CONST.cloudBurst,
          allowViewNavigation: false,
          selectableDayPredicate: selectableDayPredicate,
          controller: controller,
          enablePastDates: enablePastDates ?? false,
          selectionTextStyle:
              FONT_CONST.regular(color: COLOR_CONST.white, fontSize: 14),
          initialSelectedDate: initialSelectedDate,
          headerStyle: DateRangePickerHeaderStyle(
              textStyle: FONT_CONST.semoBold(
            color: COLOR_CONST.cloudBurst,
          )),
          monthViewSettings: DateRangePickerMonthViewSettings(
            viewHeaderStyle: DateRangePickerViewHeaderStyle(
              textStyle: FONT_CONST.regular(
                  color: COLOR_CONST.cloudBurst, fontSize: 14),
            ),
            weekNumberStyle: DateRangePickerWeekNumberStyle(
                textStyle: FONT_CONST.regular(color: COLOR_CONST.silverChalice),
                backgroundColor: COLOR_CONST.brightGray),
          ),
          monthCellStyle: DateRangePickerMonthCellStyle(
            cellDecoration: const BoxDecoration(shape: BoxShape.circle),
            todayTextStyle:
                FONT_CONST.regular(color: COLOR_CONST.cloudBurst, fontSize: 14),
            todayCellDecoration: BoxDecoration(
                border: Border.all(
                  color: COLOR_CONST.cloudBurst,
                ),
                shape: BoxShape.circle),
          ),
          todayHighlightColor: COLOR_CONST.cloudBurst,
        ),
      ),
    );
  }

  bool isWeekend(DateTime dateTime) {
    return dateTime.weekday == DateTime.saturday ||
        dateTime.weekday == DateTime.sunday;
  }
}
