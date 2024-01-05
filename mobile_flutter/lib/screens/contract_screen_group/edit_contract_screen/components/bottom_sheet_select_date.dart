import 'package:easy_localization/easy_localization.dart';
import 'package:firefly/configs/resources/barrel_const.dart';
import 'package:firefly/custom_widget/custom_calendar_picker.dart';
import 'package:firefly/custom_widget/default_padding.dart';
import 'package:firefly/screens/contract_screen_group/edit_contract_screen/bloc/edit_contract_bloc.dart';
import 'package:firefly/utils/pattern.dart';
import 'package:firefly/utils/size_config.dart';
import 'package:firefly/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class BottomSheetSelectDate extends StatefulWidget {
  const BottomSheetSelectDate(
      {super.key,
      required this.description,
      this.startDate = true,
      required this.dateController});
  final String description;
  final bool startDate;
  final DateRangePickerController dateController;

  @override
  State<BottomSheetSelectDate> createState() => _BottomSheetSelectDateState();
}

class _BottomSheetSelectDateState extends State<BottomSheetSelectDate> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          padding: EdgeInsets.only(
            right: getProportionateScreenWidth(20),
            left: getProportionateScreenWidth(20),
            bottom: getProportionateScreenHeight(80),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  margin: EdgeInsets.only(
                    top: getProportionateScreenHeight(10),
                    bottom: getProportionateScreenHeight(20),
                  ),
                  width: 40,
                  height: 3,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
              Text(
                'msg_select_date'.tr(),
                style: FONT_CONST.bold(fontSize: 18),
              ),
              const VerticalSpacing(of: 5),
              Text(
                widget.description,
                style: FONT_CONST.semoBold(
                    color: Colors.grey.shade600, fontSize: 14),
              ),
              BlocBuilder<EditContractBloc, EditContractState>(
                  buildWhen: (p, c) => c.startDate != c.endDate,
                  builder: (context, state) {
                    return context.editContractBloc.state.endDate == null ||
                            (Utils.formatDateTimeToString(
                                    time: context
                                        .editContractBloc.state.startDate,
                                    dateFormat:
                                        DateFormat(DateTimePattern.dayType1)) !=
                                Utils.formatDateTimeToString(
                                    time:
                                        context.editContractBloc.state.endDate!,
                                    dateFormat:
                                        DateFormat(DateTimePattern.dayType1)))
                        ? const SizedBox.shrink()
                        : Padding(
                            padding: EdgeInsets.only(
                                top: getProportionateScreenHeight(20)),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey.shade300),
                                  child: const Icon(
                                    Icons.calendar_month,
                                    size: 20,
                                    color: COLOR_CONST.cloudBurst,
                                  ),
                                ),
                                const HorizontalSpacing(),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'msg_priod_time'.tr(),
                                      style: FONT_CONST.regular(
                                          fontSize: 14,
                                          color: Colors.grey.shade500),
                                    ),
                                    Text(
                                      '${Utils.formatDateTimeToString(time: state.startDate, dateFormat: DateFormat(DateTimePattern.dateFormatWithDay))} - ${Utils.formatDateTimeToString(time: state.startDate, dateFormat: DateFormat(DateTimePattern.dateFormatWithDay))}',
                                      style: FONT_CONST.semoBold(fontSize: 14),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          );
                  }),
              const VerticalSpacing(),
              BlocBuilder<EditContractBloc, EditContractState>(
                buildWhen: (p, c) =>
                    p.startDate != c.startDate || p.endDate != c.endDate,
                builder: (context, state) => CustomCalendarPicker(
                  initialSelectedDate: widget.startDate
                      ? context.editContractBloc.state.startDate
                      : context.editContractBloc.state.endDate ??
                          DateTime.now(),
                  enablePastDates: true,
                  controller: widget.dateController,
                  onSelectionChanged: (args) {
                    widget.dateController.displayDate = args.value;
                  },
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: defaultPadding(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 5,
                  offset: const Offset(-2, -2)),
            ],
            color: Colors.white,
          ),
          child: Row(children: [
            Expanded(
              child: Container(
                height: SizeConfig.buttonHeightDefault,
                decoration: BoxDecoration(
                    border:
                        Border.all(color: COLOR_CONST.cloudBurst, width: 2)),
                child: MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  elevation: 0,
                  padding: EdgeInsets.zero,
                  highlightColor: Colors.transparent,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  child: Text(
                    'title_cancel'.tr(),
                    style: FONT_CONST.semoBold(
                      color: COLOR_CONST.cloudBurst,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
            const HorizontalSpacing(of: 30),
            Expanded(
              child: Container(
                height: SizeConfig.buttonHeightDefault,
                decoration: BoxDecoration(
                    color: COLOR_CONST.cloudBurst,
                    border:
                        Border.all(color: COLOR_CONST.cloudBurst, width: 2)),
                child: MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (widget.startDate) {
                      context.editContractBloc.add(ChangeStartDateEvent(
                          startDate: widget.dateController.displayDate!));
                    } else {
                      context.editContractBloc.add(ChangeEndDateEvent(
                          endDate: widget.dateController.displayDate!));
                    }
                  },
                  elevation: 0,
                  padding: EdgeInsets.zero,
                  highlightColor: Colors.transparent,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  child: Text(
                    'title_ok'.tr(),
                    style: FONT_CONST.semoBold(
                      color: COLOR_CONST.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            )
          ]),
        ),
      ],
    );
  }
}
