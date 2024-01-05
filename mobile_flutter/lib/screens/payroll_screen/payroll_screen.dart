import 'package:easy_localization/easy_localization.dart';
import 'package:firefly/configs/resources/barrel_const.dart';
import 'package:firefly/custom_widget/appbar_default_custom.dart';
import 'package:firefly/custom_widget/custom_dropdown_date_picker.dart';
import 'package:firefly/custom_widget/default_padding.dart';
import 'package:firefly/custom_widget/loading_show_able.dart';
import 'package:firefly/custom_widget/popup_notification_custom.dart';
import 'package:firefly/custom_widget/primary_button.dart';
import 'package:firefly/custom_widget/toast_show_able/barrel_toast.dart';
import 'package:firefly/data/model/payroll_model.dart';
import 'package:firefly/screens/payroll_screen/bloc/payroll_bloc.dart';
import 'package:firefly/utils/pattern.dart';
import 'package:firefly/utils/size_config.dart';
import 'package:firefly/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class PayrollScreen extends StatelessWidget {
  const PayrollScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: COLOR_CONST.backgroundColor,
      body: BlocProvider(
        create: (context) => PayrollBloc()..add(InitEvent()),
        child: const BodyScreen(),
      ),
    );
  }
}

class BodyScreen extends StatefulWidget {
  const BodyScreen({
    super.key,
  });

  @override
  State<BodyScreen> createState() => _BodyScreenState();
}

class _BodyScreenState extends State<BodyScreen> {
  late DateRangePickerController calendarController;

  @override
  void initState() {
    super.initState();
    calendarController = DateRangePickerController();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: BlocListener<PayrollBloc, PayrollState>(
        listenWhen: (p, c) => p.status != c.status,
        listener: (context, state) {
          if (state.status.isSubmissionInProgress) {
            LoadingShowAble.showLoading();
          } else if (state.status.isSubmissionSuccess) {
            LoadingShowAble.forceHide();
            if (state.message != null && state.message!.isNotEmpty) {
              ToastShowAble.show(
                toastType: ToastMessageType.SUCCESS,
                message: state.message ?? '',
              );
              context.payrollBloc.add(GetPayrollEvent());
            }
          } else if (state.status.isSubmissionFailure) {
            LoadingShowAble.forceHide();
            PopupNotificationCustom.showMessgae(
              title: "title_error".tr(),
              message: state.message ?? "",
              hiddenButtonLeft: true,
            );
          } else {
            LoadingShowAble.forceHide();
          }
        },
        child: Column(
          children: [
            const AppbarDefaultCustom(
              title: 'Bảng lương của bạn',
              isCallBack: true,
            ),
            Padding(
              padding: defaultPadding(horizontal: 20, vertical: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BlocBuilder<PayrollBloc, PayrollState>(
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
                        suffixIcon: SizedBox.shrink(),
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
                            time: state.month ?? DateTime.now(),
                            dateFormat: DateFormat(DateTimePattern.monthYear)),
                        isFullwidthDropBox: true,
                        view: DateRangePickerView.year,
                        isExpanded: true,
                        monthFormat: DateTimePattern.monthYear,
                        calendarController: calendarController,
                        dateInit:
                            context.payrollBloc.state.month ?? DateTime.now(),
                        onSelectionChanged: (value) async {
                          FocusScope.of(context).unfocus();
                          context.payrollBloc
                              .add(FilterByMonthEvent(month: value));
                        },
                      ),
                    ),
                  ),
                  // ),
                  PrimaryBorderButton(
                    width: 100,
                    height: 50,
                    title: 'Cập nhập',
                    onPressed: () {
                      context.payrollBloc.add(CreatePayrollEvent());
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: defaultPadding(horizontal: 20, vertical: 10),
              child: BlocBuilder<PayrollBloc, PayrollState>(
                buildWhen: (p, c) => p.month != c.month,
                builder: (context, state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bảng lương ${Utils.formatDateTimeToString(time: state.month ?? DateTime.now(), dateFormat: DateFormat(DateTimePattern.monthYear, 'vi'))}',
                        style: FONT_CONST.bold(fontSize: 20),
                      ),
                      const VerticalSpacing(of: 20),
                    ],
                  );
                },
              ),
            ),
            Padding(
              padding: defaultPadding(horizontal: 20, vertical: 0),
              child: BlocBuilder<PayrollBloc, PayrollState>(
                buildWhen: (p, c) => p.salaryList != c.salaryList,
                builder: (context, state) {
                  if (state.salaryList != null &&
                      state.salaryList!.isNotEmpty) {
                    return ListView.separated(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) => PayrollItem(
                              payroll: state.salaryList![index],
                            ),
                        separatorBuilder: (context, index) =>
                            const VerticalSpacing(of: 10),
                        itemCount: state.salaryList!.length);
                  } else {
                    return Container(
                      height: 200,
                      child: Center(
                        child: Column(
                          children: [
                            Text(
                              'Không có dữ liệu',
                              style: FONT_CONST.regular(),
                            ),
                            const VerticalSpacing(),
                            PrimaryButton(
                              width: 200,
                              title: 'Tạo bảng lương',
                              onPressed: () {
                                context.payrollBloc.add(CreatePayrollEvent());
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PayrollItem extends StatelessWidget {
  const PayrollItem({
    super.key,
    required this.payroll,
  });
  final PayrollModel payroll;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              'Nhân viên: ',
              style: FONT_CONST.regular(),
            ),
            Text(
              payroll.user!.fullname,
              style: FONT_CONST.regular(),
            ),
          ],
        ),
        const VerticalSpacing(of: 5),
        Row(
          children: [
            Text(
              'Thực lĩnh: ',
              style: FONT_CONST.regular(),
            ),
            Text(
              NumberFormat('#,###').format(payroll.realField),
              style: FONT_CONST.regular(),
            ),
            if (payroll.realField != 0)
              Text(
                ' VND',
                style: FONT_CONST.regular(),
              ),
          ],
        ),
        const VerticalSpacing(of: 5),
        Row(
          children: [
            Text(
              'Tổng lương: ',
              style: FONT_CONST.regular(),
            ),
            Text(
              NumberFormat('#,###.###').format(payroll.totalSalary),
              style: FONT_CONST.regular(),
            ),
            if (payroll.totalSalary != 0)
              Text(
                ' VND',
                style: FONT_CONST.regular(),
              ),
          ],
        ),
        const VerticalSpacing(of: 5),
        Row(
          children: [
            Text(
              'Tổng phụ cấp: ',
              style: FONT_CONST.regular(),
            ),
            Text(
              NumberFormat('#,###.###').format(payroll.totalAllowance),
              style: FONT_CONST.regular(),
            ),
            if (payroll.totalAllowance != 0)
              Text(
                ' VND',
                style: FONT_CONST.regular(),
              ),
          ],
        ),
        const VerticalSpacing(of: 5),
        Row(
          children: [
            Text(
              'Tổng thưởng: ',
              style: FONT_CONST.regular(),
            ),
            Text(
              NumberFormat('#,###.###').format(payroll.totalBonus),
              style: FONT_CONST.regular(),
            ),
            if (payroll.totalBonus != 0)
              Text(
                ' VND',
                style: FONT_CONST.regular(),
              ),
          ],
        ),
        const VerticalSpacing(of: 5),
        Row(
          children: [
            Text(
              'Tổng phạt: ',
              style: FONT_CONST.regular(),
            ),
            Text(
              NumberFormat('#,###.###').format(payroll.totalPunish),
              style: FONT_CONST.regular(),
            ),
            if (payroll.totalPunish != 0)
              Text(
                ' VND',
                style: FONT_CONST.regular(),
              ),
          ],
        ),
        const VerticalSpacing(of: 5),
        Row(
          children: [
            Text(
              'Khấu trừ bảo hiểm (10.5%): ',
              style: FONT_CONST.regular(),
            ),
            Text(
              NumberFormat('#,###.###').format(payroll.insurance),
              style: FONT_CONST.regular(),
            ),
            if (payroll.insurance != 0)
              Text(
                ' VND',
                style: FONT_CONST.regular(),
              ),
          ],
        ),
        const VerticalSpacing(of: 5),
        Row(
          children: [
            Text(
              'Khấu trừ thuế: ',
              style: FONT_CONST.regular(),
            ),
            Text(
              NumberFormat('#,###.###').format(payroll.tax),
              style: FONT_CONST.regular(),
            ),
            if (payroll.tax != 0)
              Text(
                ' VND',
                style: FONT_CONST.regular(),
              ),
          ],
        ),
        const VerticalSpacing(of: 5),
        Row(
          children: [
            Text(
              'Trạng thái bảng lương: ',
              style: FONT_CONST.regular(),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                  color: payroll.isClosed ?? false
                      ? Colors.green.shade100
                      : Colors.red.shade100,
                  borderRadius: BorderRadius.circular(12)),
              child: Text(
                payroll.isClosed ?? false ? 'Đã chốt' : "Chưa chốt",
                style: FONT_CONST.regular(
                    color: payroll.isClosed ?? false
                        ? Colors.green
                        : Colors.redAccent),
              ),
            ),
          ],
        )
      ],
    );
  }
}
