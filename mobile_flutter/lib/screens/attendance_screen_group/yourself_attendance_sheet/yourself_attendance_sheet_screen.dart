import 'package:easy_localization/easy_localization.dart';
import 'package:firefly/configs/resources/barrel_const.dart';
import 'package:firefly/custom_widget/appbar_default_custom.dart';
import 'package:firefly/custom_widget/default_padding.dart';
import 'package:firefly/custom_widget/loading_show_able.dart';
import 'package:firefly/custom_widget/toast_show_able/barrel_toast.dart';
import 'package:firefly/data/enum_type/ticket_status.dart';
import 'package:firefly/data/enum_type/ticket_type.dart';
import 'package:firefly/data/model/attendance_statistics_model.dart';
import 'package:firefly/data/model/ticket_model.dart';
import 'package:firefly/screens/attendance_screen_group/yourself_attendance_sheet/bloc/yourself_attendance_sheet_bloc.dart';
import 'package:firefly/screens/attendance_screen_group/yourself_attendance_sheet/components/envidence_face.dart';
import 'package:firefly/utils/date_time_ext.dart';
import 'package:firefly/utils/pattern.dart';
import 'package:firefly/utils/size_config.dart';
import 'package:firefly/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class YourselfAttendanceSheetScreen extends StatelessWidget {
  const YourselfAttendanceSheetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocProvider(
            create: (context) =>
                YourselfAttendanceSheetBloc()..add(GetAttendanceEvent()),
            // ..add(GetAttendanceStatisticsEvent()),
            child: const BodyScreen()));
  }
}

class BodyScreen extends StatefulWidget {
  const BodyScreen({super.key});

  @override
  State<BodyScreen> createState() => _BodyScreenState();
}

class _BodyScreenState extends State<BodyScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: BlocListener<YourselfAttendanceSheetBloc,
              YourselfAttendanceSheetState>(
          listenWhen: (p, c) => p.status != c.status,
          listener: (context, state) {
            if (state.status.isSubmissionInProgress) {
              LoadingShowAble.showLoading();
              // if (state.message != null && state.message!.isNotEmpty) {
              //   ToastShowAble.show(
              //       toastType: ToastMessageType.INFO,
              //       message: state.message ?? '');
              // }
            } else if (state.status.isSubmissionSuccess) {
              LoadingShowAble.forceHide();

              if (state.message != null && state.message!.isNotEmpty) {
                ToastShowAble.show(
                    toastType: ToastMessageType.SUCCESS,
                    message: state.message ?? '');

                // Navigator.of(context).pop(true);
              }
            } else if (state.status.isSubmissionSuccess) {
              LoadingShowAble.forceHide();

              ToastShowAble.show(
                  toastType: ToastMessageType.ERROR,
                  message: state.message ?? '');
            } else {
              LoadingShowAble.forceHide();
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppbarDefaultCustom(
                title: 'Bảng chấm công \ncủa bạn',
                isCallBack: true,
              ),
              Padding(
                padding: defaultPadding(horizontal: 20, vertical: 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        constraints: BoxConstraints(
                            maxHeight: SizeConfig.screenHeight / 2),
                        child: const CustomCalendar()),
                    // const VerticalSpacing(of: 20),
                    BlocBuilder<YourselfAttendanceSheetBloc,
                            YourselfAttendanceSheetState>(
                        buildWhen: (p, c) =>
                            p.listAttendance != c.listAttendance ||
                            p.day != c.day,
                        builder: (context, state) {
                          return state.listAttendance != null &&
                                  state.listAttendance!.isNotEmpty
                              ? Container(
                                  // padding:
                                  //     defaultPadding(horizontal: 20, vertical: 0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const VerticalSpacing(of: 15),
                                      Text(
                                        Utils.formatDateTimeToString(
                                          time: state.day!,
                                          dateFormat: DateFormat(DateTimePattern
                                              .dateFormatWithDay3),
                                        ),
                                        style: FONT_CONST.medium(fontSize: 18),
                                      ),
                                      const VerticalSpacing(of: 15),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Expanded(
                                            child: Container(
                                              padding: defaultPadding(
                                                  horizontal: 15, vertical: 10),
                                              decoration: BoxDecoration(
                                                color: state.listAttendance![0]
                                                            .startTime ==
                                                        null
                                                    ? Colors.red.shade200
                                                    : Colors.green.shade200,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    'Giờ vào',
                                                    style: FONT_CONST.medium(),
                                                  ),
                                                  const VerticalSpacing(of: 5),
                                                  Text(
                                                    state.listAttendance![0]
                                                                .startTime !=
                                                            null
                                                        ? Utils.formatDateTimeToString(
                                                            time: state
                                                                .listAttendance![
                                                                    0]
                                                                .startTime!,
                                                            dateFormat: DateFormat(
                                                                DateTimePattern
                                                                    .timeType))
                                                        : '--:--',
                                                    style: FONT_CONST.bold(
                                                        fontSize: 18),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          const HorizontalSpacing(),
                                          Expanded(
                                            child: Container(
                                              padding: defaultPadding(
                                                  horizontal: 15, vertical: 10),
                                              decoration: BoxDecoration(
                                                color: Colors.green.shade200,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    'Giờ ra',
                                                    style: FONT_CONST.medium(),
                                                  ),
                                                  const VerticalSpacing(of: 5),
                                                  Text(
                                                    state.listAttendance![0]
                                                                .endTime !=
                                                            null
                                                        ? Utils.formatDateTimeToString(
                                                            time: state
                                                                .listAttendance![
                                                                    0]
                                                                .endTime!,
                                                            dateFormat: DateFormat(
                                                                DateTimePattern
                                                                    .timeType))
                                                        : '--:--',
                                                    style: FONT_CONST.bold(
                                                        fontSize: 18),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const VerticalSpacing(of: 10),
                                      const Divider(height: 1),
                                      const VerticalSpacing(of: 8),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Chấm công trong ngày',
                                            style:
                                                FONT_CONST.medium(fontSize: 18),
                                          ),
                                          const VerticalSpacing(of: 10),
                                          (state.listAttendance![0]
                                                          .faceAttendances !=
                                                      null &&
                                                  state.listAttendance![0]
                                                      .faceAttendances!.isNotEmpty)
                                              ? ListView.separated(
                                                  shrinkWrap: true,
                                                  padding: EdgeInsets.zero,
                                                  itemBuilder: (context, index) => EnvidenceItem(
                                                      model: state
                                                              .listAttendance![0]
                                                              .faceAttendances![
                                                          index]),
                                                  separatorBuilder:
                                                      (context, index) =>
                                                          const VerticalSpacing(
                                                              of: 5),
                                                  itemCount: state
                                                      .listAttendance![0]
                                                      .faceAttendances!
                                                      .length)
                                              : Text(
                                                  'Không có dữ liệu',
                                                  style: FONT_CONST.regular(),
                                                )
                                        ],
                                      ),
                                      const VerticalSpacing(of: 8),
                                      const Divider(height: 1),
                                      const VerticalSpacing(of: 8),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Đơn từ trong ngày',
                                            style:
                                                FONT_CONST.medium(fontSize: 18),
                                          ),
                                          const VerticalSpacing(of: 10),
                                          (state.listAttendance![0].tickets !=
                                                      null &&
                                                  state.listAttendance![0]
                                                      .tickets!.isNotEmpty)
                                              ? const ListTicketAttendance()
                                              : Text(
                                                  'Không có đơn từ nào trong ngày',
                                                  style: FONT_CONST.regular(),
                                                )
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              : state.day!.isWeekend
                                  ? const SizedBox.shrink()
                                  : Column(
                                      children: [
                                        const VerticalSpacing(of: 8),
                                        Text(
                                          'Bạn chưa chấm công ngày ${DateFormat(DateTimePattern.dayType1).format(state.day!)}',
                                          style: FONT_CONST.medium(
                                            color: COLOR_CONST.portlandOrange,
                                          ),
                                        ),
                                      ],
                                    );
                        }),
                    const VerticalSpacing(of: 25),
                    BlocBuilder<YourselfAttendanceSheetBloc,
                        YourselfAttendanceSheetState>(
                      buildWhen: (p, c) =>
                          p.attendanceStatisticsModel !=
                              c.attendanceStatisticsModel ||
                          p.month != c.month,
                      builder: (context, state) {
                        return state.attendanceStatisticsModel != null
                            ? AttendanceStaticsInMonth(
                                model: state.attendanceStatisticsModel,
                              )
                            : const SizedBox();
                      },
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}

class ListTicketAttendance extends StatelessWidget {
  const ListTicketAttendance({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final list = context.yourselfAttendanceSheetBloc.state.listAttendance;
    return ListView.separated(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) =>
            TicketItemAttendance(ticket: list[0].tickets![index]),
        separatorBuilder: (context, index) => const VerticalSpacing(of: 5),
        itemCount: list![0].tickets!.length);
  }
}

class TicketItemAttendance extends StatelessWidget {
  const TicketItemAttendance({
    super.key,
    required this.ticket,
  });
  final TicketModel ticket;

  @override
  Widget build(BuildContext context) {
    final start_time = Utils.formatDateTimeToString(
        time: ticket.dateTimeTickets![0].startDateTime,
        dateFormat: DateFormat(DateTimePattern.timeType));
    final end_time = Utils.formatDateTimeToString(
        time: ticket.dateTimeTickets![0].endDateTime,
        dateFormat: DateFormat(DateTimePattern.timeType));

    return Container(
      padding: defaultPadding(horizontal: 0, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              ticket.ticketType.value,
              style: FONT_CONST.regular(),
            ),
          ),
          const HorizontalSpacing(of: 5),
          Expanded(
            child: Text(
              '$start_time - $end_time',
              style: FONT_CONST.regular(),
            ),
          ),
          const HorizontalSpacing(of: 5),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: ticket.status.color.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: defaultPadding(horizontal: 10, vertical: 5),
              child: Text(
                ticket.status.value,
                textAlign: TextAlign.center,
                style: FONT_CONST.medium(color: ticket.status.color),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AttendanceStaticsInMonth extends StatelessWidget {
  const AttendanceStaticsInMonth({
    super.key,
    this.model,
  });
  final AttendanceStatisticsModel? model;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Chi tiết công ${Utils.formatDateTimeToString(
            time: context.yourselfAttendanceSheetBloc.state.month ??
                DateTime.now().lastDateOfMonth,
            dateFormat: DateFormat(DateTimePattern.monthYear),
          )}',
          style: FONT_CONST.bold(fontSize: 18),
        ),
        const VerticalSpacing(of: 15),
        StatisticsItem(
          title: 'Số công làm việc thực tế: ',
          content: '${model?.actualWorkNumber ?? 0}',
        ),
        const VerticalSpacing(of: 10),
        StatisticsItem(
          title: 'Số công chuẩn trong tháng:',
          content: '${model?.standardWorkNumber ?? 0}',
        ),
        const VerticalSpacing(of: 10),
        const Divider(height: 1),
        const VerticalSpacing(of: 10),
        StatisticsItem(
          title: 'Số lần đi muộn trong tháng:',
          content: '${model?.timesLateIn ?? 0}',
        ),
        const VerticalSpacing(of: 10),
        StatisticsItem(
          title: 'Số phút đi muộn trong tháng:',
          content: '${model?.minutesLateIn ?? 0}',
        ),
        const VerticalSpacing(of: 10),
        // StatisticsItem(
        //   title: 'Tiền phạt đi muộn ',
        //   content: '${model?.penaltyBeingLate ?? 0}',
        // ),
        // const VerticalSpacing(of: 10),
        const Divider(height: 1),
        const VerticalSpacing(of: 10),
        StatisticsItem(
          title: 'Số lần về sớm trong tháng:',
          content: '${model?.timesEarlyOut ?? 0}',
        ),
        const VerticalSpacing(of: 10),
        StatisticsItem(
          title: 'Số phút về sớm trong tháng:',
          content: '${model?.minutesEarlyOut ?? 0}',
        ),
        const VerticalSpacing(of: 10),
        // StatisticsItem(
        //   title: 'Tiền phạt về sớm: ',
        //   content: '${model?.earlyReturnPenalty ?? 0}',
        // ),
        // const VerticalSpacing(of: 10),
        const Divider(height: 1),
        const VerticalSpacing(of: 10),
        StatisticsItem(
          title: 'Số lần quên chấm công',
          content: '${model?.forgotCheckInOut ?? 0}',
        ),
        const VerticalSpacing(of: 10),
        // StatisticsItem(
        //   title: 'Tiền phạt quên chấm công',
        //   content: '${model?.penaltyForgettingAttendance ?? 0}',
        // ),
        // const VerticalSpacing(of: 10),
        const Divider(height: 1),
        const VerticalSpacing(of: 10),
        // StatisticsItem(
        //   title: 'Số công nghỉ không lý do:',
        //   content: '${model?.penaltyForgettingAttendance ?? 0}',
        // ),
        // const VerticalSpacing(of: 10),
        // StatisticsItem(
        //   title: 'Tiền phạt nghỉ không lý do',
        //   content: '${model?.penaltyLeavingWithoutReason ?? 0}',
        // ),
        // const VerticalSpacing(of: 10),
        const Divider(height: 1),
        const VerticalSpacing(of: 10),
        StatisticsItem(
          title: 'Số giờ làm thêm',
          content: '${model?.overtimeHour ?? 0}',
        ),
        // const VerticalSpacing(of: 10),
        // StatisticsItem(
        //   title: 'Công ăn theo làm thêm',
        //   content: '${model?.overtimeSalary ?? 0}',
        // ),
      ],
    );
  }
}

class StatisticsItem extends StatelessWidget {
  const StatisticsItem(
      {super.key,
      required this.title,
      required this.content,
      this.textStyleTitle,
      this.textStyleContent});
  final String title;
  final String content;
  final TextStyle? textStyleTitle;
  final TextStyle? textStyleContent;

  @override
  Widget build(BuildContext context) {
    return Row(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style:
              textStyleTitle ?? FONT_CONST.medium(color: Colors.grey.shade600),
        ),
        const HorizontalSpacing(),
        Text(
          content,
          style: textStyleContent ?? FONT_CONST.medium(fontSize: 18),
        ),
      ],
    );
  }
}

class CustomCalendar extends StatefulWidget {
  const CustomCalendar({super.key});

  @override
  State<CustomCalendar> createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  final DateRangePickerController _controller = DateRangePickerController();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<YourselfAttendanceSheetBloc,
        YourselfAttendanceSheetState>(
      buildWhen: (p, c) => p.day != c.day,
      builder: (context, state) => SfDateRangePicker(
        selectionMode: DateRangePickerSelectionMode.single,
        // selectionTextStyle:
        //     FONT_CONST.regular(color: COLOR_CONST.white, fontSize: 14),
        selectionColor: Colors.blue.shade100,
        // selectionRadius: 20,
        // selectionShape: DateRangePickerSelectionShape.rectangle,
        allowViewNavigation: true,
        view: DateRangePickerView.month,
        controller: _controller,
        onSelectionChanged: (args) {
          _controller.displayDate = args.value;
          context.yourselfAttendanceSheetBloc
              .add(ChangeWorkingDayEvent(day: args.value!));
        },
        // se,
        cellBuilder:
            (BuildContext context, DateRangePickerCellDetails details) {
          final bool isToday = isSameDate(details.date, DateTime.now());
          final bool isBlackOut = isBlackedDate(details.date);
          final bool isSpecialDate = isSpecialDay(details.date);

          return CustomDateCell(
              details: details,
              isToday: isToday,
              isBlackOut: isBlackOut,
              isSpecialDate: isSpecialDate);
        },
      ),
    );
  }

  bool isSpecialDay(DateTime date) {
    if (date.day == 20 || date.day == 21 || date.day == 24 || date.day == 25) {
      return true;
    }
    return false;
  }

  bool isSameDate(DateTime date, DateTime dateTime) {
    if (date.year == dateTime.year &&
        date.month == dateTime.month &&
        date.day == dateTime.day) {
      return true;
    }

    return false;
  }

  bool isBlackedDate(DateTime date) {
    if (date.day == 17 || date.day == 18) {
      return true;
    }
    return false;
  }
}

class CustomDateCell extends StatelessWidget {
  const CustomDateCell({
    super.key,
    required this.isToday,
    required this.isBlackOut,
    required this.isSpecialDate,
    required this.details,
  });

  final bool isToday;
  final bool isBlackOut;
  final bool isSpecialDate;
  final DateRangePickerCellDetails details;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(2),
      height: 100,
      padding: defaultPadding(vertical: 5, horizontal: 0),
      decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.1),
          border: isToday
              ? Border.all(color: Colors.grey.shade400, width: 1.5)
              : null,
          borderRadius: BorderRadius.circular(12)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        // mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            details.date.day.toString(),
            style: FONT_CONST.bold(),
          ),
          // Container(
          //     decoration:
          //         BoxDecoration(color: Colors.amber, shape: BoxShape.circle)),
        ],
      ),
    );
  }
}
