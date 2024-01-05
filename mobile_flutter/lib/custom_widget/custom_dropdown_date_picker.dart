import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:firefly/configs/resources/color_const.dart';
import 'package:firefly/utils/size_config.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'custom_calendar_picker.dart';

class CustomDropdownDatePicker extends StatelessWidget {
  CustomDropdownDatePicker({
    super.key,
    this.textTime,
    this.boxDecoration,
    this.backgroundColor,
    this.colorBorder = const Color(0xFF272961),
    this.colorBorderFocused = const Color(0xFF272961),
    this.maxHeight,
    this.isFullwidthDropBox = false,
    this.isExpanded = true,
    this.directionDropBox,
    required this.calendarController,
    required this.onSelectionChanged,
    required this.dateInit,
    this.maxWidthButton,
    this.textStyleTitle,
    this.monthFormat,
    this.view,
    this.inputDecoration,
    this.suffixIcon,
    this.prefixIcon,
    this.items,
  });

  final String? textTime;
  final BoxDecoration? boxDecoration;
  final Color? backgroundColor;
  final Color colorBorder;
  final Color colorBorderFocused;
  final double? maxHeight;
  final bool isFullwidthDropBox;
  final bool isExpanded;
  final void Function(DateTime) onSelectionChanged;
  final DropdownDirection? directionDropBox;
  final DateRangePickerController? calendarController;
  final DateTime dateInit;
  final double? maxWidthButton;
  final TextStyle? textStyleTitle;
  final String? monthFormat;
  final DateRangePickerView? view;
  final InputDecoration? inputDecoration;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final List<DropdownMenuItem<dynamic>>? items;

  double heightItemMenu = 50;

  bool isOpenDropdown = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor ?? COLOR_CONST.backgroundColor,
      constraints: BoxConstraints(
          maxHeight: 50, maxWidth: maxWidthButton ?? double.maxFinite),
      child: DropdownButtonFormField2<dynamic>(
        customButton: itemSelectedWidget(
            textTime: textTime, suffixIcon: suffixIcon, prefixIcon: prefixIcon),
        onMenuStateChange: (isOpen) async {
          isOpenDropdown = isOpen;
        },
        decoration: inputDecoration ??
            InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.zero,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: colorBorder),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: colorBorderFocused),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
        isExpanded: isExpanded,
        isDense: false,
        items: items ??
            [
              DropdownMenuItem<Container>(
                  enabled: false,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: CustomCalendarPicker(
                      controller: calendarController,
                      initialSelectedDate: dateInit,
                      monthFormat: monthFormat,
                      view: view,
                      enablePastDates: true,
                      onSelectionChanged: (args) {
                        if (isOpenDropdown) {
                          isOpenDropdown = false;
                          final date = args.value as DateTime;
                          onSelectionChanged(date);
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                  )),
            ],
        onChanged: (value) {},
        // value: selectedDefault,
        dropdownStyleData: DropdownStyleData(
          direction: directionDropBox ?? DropdownDirection.textDirection,
          width: !isFullwidthDropBox
              ? null
              : SizeConfig.screenWidth - getProportionateScreenHeight(40),
          padding: const EdgeInsets.all(0),
          offset: const Offset(0, -5),
          maxHeight: 300,
          // scrollPadding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
        ),

        // ignore: prefer_const_constructors
        menuItemStyleData: MenuItemStyleData(
            // height: 300,
            padding: const EdgeInsets.all(0),
            customHeights: [300]),
      ),
    );
  }

  Widget itemSelectedWidget(
      {String? textTime, Widget? suffixIcon, Widget? prefixIcon}) {
    return Container(
      height: heightItemMenu,
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          prefixIcon ?? const SizedBox.shrink(),
          Flexible(
            child: Text(
              textTime ?? 'dd/MM/yyyy',
              style: textStyleTitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // ignore: prefer_const_constructors
          SizedBox(
            height: 5,
          ),
          suffixIcon ??
              const Icon(
                Icons.calendar_month,
                size: 20,
                color: const Color(0xFF272961),
              ),
        ],
      ),
    );
  }
}
