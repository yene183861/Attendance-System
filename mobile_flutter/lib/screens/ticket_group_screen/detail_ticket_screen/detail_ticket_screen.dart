import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firefly/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:firefly/configs/resources/barrel_const.dart';
import 'package:firefly/custom_widget/default_padding.dart';
import 'package:firefly/custom_widget/loading_show_able.dart';
import 'package:firefly/custom_widget/popup_notification_custom.dart';
import 'package:firefly/custom_widget/toast_show_able/barrel_toast.dart';
import 'package:firefly/data/enum_type/ticket_status.dart';
import 'package:firefly/data/enum_type/ticket_type.dart';
import 'package:firefly/data/enum_type/user_type.dart';
import 'package:firefly/data/model/ticket_model.dart';
import 'package:firefly/screens/app_router.dart';
import 'package:firefly/screens/ticket_group_screen/detail_ticket_screen/bloc/detail_ticket_bloc.dart';
import 'package:firefly/utils/pattern.dart';
import 'package:firefly/utils/singleton.dart';
import 'package:firefly/utils/size_config.dart';

import '../../../custom_widget/appbar_default_custom.dart';

class DetailTicketScreen extends StatelessWidget {
  const DetailTicketScreen({super.key, required this.ticket});
  final TicketModel ticket;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: BlocProvider(
          create: (context) =>
              DetailTicketBloc(ticket: ticket)..add(GetUserWorkEvent()),
          child: BodyScreen()),
    );
  }
}

class BodyScreen extends StatelessWidget {
  const BodyScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DetailTicketBloc, DetailTicketState>(
        listener: (context, state) {
          if (state.status.isSubmissionInProgress) {
            LoadingShowAble.showLoading();
          } else if (state.status.isSubmissionSuccess) {
            LoadingShowAble.hideLoading();
            if (state.message != null && state.message!.isNotEmpty) {
              ToastShowAble.show(
                toastType: ToastMessageType.SUCCESS,
                message: state.message ?? '',
              );
              if (state.message == 'delete_success'.tr()) {
                Navigator.of(context).pop(true);
              }
            }
          } else if (state.status.isSubmissionFailure) {
            LoadingShowAble.hideLoading();

            PopupNotificationCustom.showMessgae(
              title: "title_error".tr(),
              message: state.message ?? "",
              hiddenButtonLeft: true,
            );
          } else {
            LoadingShowAble.hideLoading();
          }
        },
        buildWhen: (previous, current) => previous.ticket != current.ticket,
        builder: (context, state) {
          final ticket = context.detailTicketBloc.state.ticket!;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppbarDefaultCustom(
                  title: 'Detail Ticket',
                  isCallBack: true,
                  callbackEvent: context.detailTicketBloc.state.isChangeData
                      ? () {
                          Navigator.of(context).pop(true);
                        }
                      : null,
                ),
                Container(
                  padding: defaultPadding(horizontal: 20, vertical: 15),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.grey.shade400),
                    ),
                    color: ticket.status.color.withOpacity(0.3),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 8,
                            width: 8,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: ticket.status.color),
                            margin: EdgeInsets.only(
                                right: getProportionateScreenWidth(8)),
                          ),
                          Text(
                            ticket.status == TicketStatus.PENDING
                                ? 'Pending aproval'
                                : ticket.status == TicketStatus.APPROVED
                                    ? 'Approved by'
                                    : 'Refuse by',
                            style:
                                FONT_CONST.medium(color: ticket.status.color),
                          ),
                        ],
                      ),
                      if (ticket.reviewer?.id != 0)
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: getProportionateScreenWidth(5)),
                              height: 20,
                              width: 20,
                              child: CachedNetworkImage(
                                imageUrl: ticket.reviewer?.avatarThumb ?? '',
                                placeholder: (context, url) => CircleAvatar(
                                  backgroundImage: AssetImage(
                                    IMAGE_CONST.imgDefaultAvatar.path,
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    CircleAvatar(
                                  backgroundImage: AssetImage(
                                    IMAGE_CONST.imgDefaultAvatar.path,
                                  ),
                                ),
                                imageBuilder: (context, imageProvider) =>
                                    CircleAvatar(
                                  backgroundImage: imageProvider,
                                ),
                              ),
                            ),
                            Text(
                              ticket.reviewer!.fullname,
                              style: FONT_CONST.medium(),
                            )
                          ],
                        )
                    ],
                  ),
                ),
                VerticalSpacing(of: 10),
                Container(
                  color: Colors.grey.shade200,
                  child: Column(
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey.shade200),
                            borderRadius: BorderRadius.circular(8)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Thông tin chung',
                              style: FONT_CONST.semoBold(fontSize: 18),
                            ),
                            InfoUserWork(),
                            ItemInfo(
                              title: 'Tính công',
                              content: ticket.dateTimeTickets![0].ticketReason
                                      .isWorkCalculation
                                  ? 'Có'
                                  : 'Không',
                            ),
                            ItemInfo(
                              title: 'Mô tả',
                              content: ticket.description!.isEmpty
                                  ? '--'
                                  : ticket.description,
                            ),
                            // Row(
                            //   crossAxisAlignment: CrossAxisAlignment.start,
                            //   // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            //   children: [
                            //     Expanded(
                            //       child: ItemInfo(
                            //         title: 'Mô tả',
                            //         content: ticket.description!.isEmpty
                            //             ? '--'
                            //             : ticket.description,
                            //       ),
                            //     ),
                            //     // const HorizontalSpacing(of: 30),
                            //     Expanded(
                            //       child: ItemInfo(
                            //         title: 'Tính công',
                            //         content: ticket.dateTimeTickets![0]
                            //                 .ticketReason.isWorkCalculation
                            //             ? 'Có'
                            //             : 'Không',
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            ItemInfo(
                              title: 'Ý kiến người duyệt',
                              content: ticket.reviewerOpinions!.isEmpty
                                  ? '--'
                                  : ticket.reviewerOpinions,
                            ),

                            VerticalSpacing(),
                            Divider(),
                            VerticalSpacing(),
                            DetailTicketDateTime(),
                            VerticalSpacing(of: 20),
                            Divider(),
                            VerticalSpacing(of: 20),
                            Text(
                              'Đính kèm',
                              style: FONT_CONST.medium(),
                            ),
                            Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Text('Bạn không có file đính kèm nào'),
                            ),
                          ],
                        ),
                      ),
                      if (Singleton.instance.userProfile!.id ==
                              ticket.user!.id &&
                          ticket.status != TicketStatus.APPROVED)
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
                            if (ticket.status == TicketStatus.PENDING)
                              Expanded(
                                child: Container(
                                  height: SizeConfig.buttonHeightDefault,
                                  margin: EdgeInsets.only(
                                      right: getProportionateScreenWidth(30)),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: COLOR_CONST.cloudBurst,
                                          width: 2)),
                                  child: MaterialButton(
                                    onPressed: () {
                                      PopupNotificationCustom.showMessgae(
                                        title: "Xác nhận xóa".tr(),
                                        message:
                                            "Bạn có chắc chắn muốn xóa đơn này không?",
                                        hiddenButtonLeft: false,
                                        pressButtonRight: () {
                                          context.detailTicketBloc.add(
                                              DeleteDetailTicketEvent(
                                                  id: ticket.id!));
                                        },
                                      );
                                    },
                                    elevation: 0,
                                    padding: EdgeInsets.zero,
                                    highlightColor: Colors.transparent,
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    child: Text(
                                      'delete'.tr(),
                                      style: FONT_CONST.semoBold(
                                        color: COLOR_CONST.cloudBurst,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            Expanded(
                              child: Container(
                                height: SizeConfig.buttonHeightDefault,
                                decoration: BoxDecoration(
                                    color: COLOR_CONST.cloudBurst,
                                    border: Border.all(
                                        color: COLOR_CONST.cloudBurst,
                                        width: 2)),
                                child: MaterialButton(
                                  onPressed: () async {
                                    final value =
                                        await Navigator.of(context).pushNamed(
                                      AppRouter.EDIT_TICKET_SCREEN,
                                      arguments: ticket,
                                    );
                                    if (value == true) {
                                      context.detailTicketBloc
                                          .add(ChangeDataEvent());
                                    }
                                    // Navigator.of(context).pop();
                                    // if (widget.startDate) {
                                    //   context.editTicketBloc.add(ChangeStartDateEvent(
                                    //       startDate:
                                    //           widget.dateController.displayDate!));
                                    // } else {
                                    //   log('change end dtae');
                                    //   context.editTicketBloc.add(ChangeEndDateEvent(
                                    //       endDate: widget.dateController.displayDate!));
                                    // }
                                  },
                                  elevation: 0,
                                  padding: EdgeInsets.zero,
                                  highlightColor: Colors.transparent,
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  child: Text(
                                    'update'.tr(),
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

                      // VerticalSpacing(of: 10),
                      // CommentAndHistoryAction(),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}

class DetailTicketDateTime extends StatelessWidget {
  const DetailTicketDateTime({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final datetimeTicket =
        context.detailTicketBloc.state.ticket!.dateTimeTickets![0];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Chi tiết',
          style: FONT_CONST.semoBold(fontSize: 18),
        ),
        Table(
          columnWidths: <int, TableColumnWidth>{
            0: FlexColumnWidth(SizeConfig.screenWidth * 0.3),
            1: FlexColumnWidth(SizeConfig.screenWidth * 0.3),
            // 2: FixedColumnWidth(SizeConfig.screenWidth * 0.14),
            // 3: FixedColumnWidth(SizeConfig.screenWidth * 0.14),
            // 4: FixedColumnWidth(SizeConfig.screenWidth * 0.14),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: <TableRow>[
            TableRow(
              children: <Widget>[
                TableCell(
                  // verticalAlignment: TableCellVerticalAlignment.top,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      'Bắt đầu',
                      style: FONT_CONST.medium(
                          color: Colors.black54, fontSize: 12),
                    ),
                  ),
                ),
                TableCell(
                  // verticalAlignment: TableCellVerticalAlignment.top,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    // alignment: Alignment.center,
                    child: Text(
                      'Kết thúc',
                      style: FONT_CONST.medium(
                          color: Colors.black54, fontSize: 12),
                    ),
                  ),
                ),
                // Container(
                //   alignment: Alignment.center,
                //   padding: EdgeInsets.all(8),
                //   child: Text(
                //     'Số ngày',
                //     style:
                //         FONT_CONST.medium(color: Colors.black54, fontSize: 12),
                //   ),
                // ),
                // Container(
                //   alignment: Alignment.center,
                //   padding: EdgeInsets.all(8),
                //   child: Text(
                //     'Trước khi nghỉ',
                //     style:
                //         FONT_CONST.medium(color: Colors.black54, fontSize: 12),
                //   ),
                // ),
                // Container(
                //   alignment: Alignment.center,
                //   padding: EdgeInsets.all(8),
                //   child: Text(
                //     'Sau khi nghỉ',
                //     style:
                //         FONT_CONST.medium(color: Colors.black54, fontSize: 12),
                //   ),
                // ),
              ],
            ),
            TableRow(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                // border: Border.all(color: Colors.blueGrey),
                // borderRadius: BorderRadius.circular(8),
              ),
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.all(8),
                  child: Text(
                    '${Utils.formatDateTimeToString(time: datetimeTicket.startDateTime, dateFormat: DateFormat(DateTimePattern.timeType))}\n${DateFormat(DateTimePattern.dayType1).format(datetimeTicket.startDateTime)}',
                    style: FONT_CONST.regular(fontSize: 12),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.all(8),
                  child: Text(
                    '${Utils.formatDateTimeToString(time: datetimeTicket.endDateTime, dateFormat: DateFormat(DateTimePattern.timeType))}\n${DateFormat(DateTimePattern.dayType1).format(datetimeTicket.endDateTime)}',
                    style: FONT_CONST.regular(fontSize: 12),
                  ),
                ),
                // Center(
                //   child: Container(
                //     alignment: Alignment.center,
                //     padding: EdgeInsets.all(8),
                //     child: Text(
                //       '1 (day)',
                //       style: FONT_CONST.regular(fontSize: 12),
                //     ),
                //   ),
                // ),
                // Center(
                //   child: Container(
                //     alignment: Alignment.center,
                //     padding: EdgeInsets.all(8),
                //     child: Text(
                //       '1 (day)',
                //       style: FONT_CONST.regular(fontSize: 12),
                //     ),
                //   ),
                // ),
                // Center(
                //   child: Container(
                //     alignment: Alignment.center,
                //     padding: EdgeInsets.all(8),
                //     child: Text(
                //       '1 (day)',
                //       style: FONT_CONST.regular(fontSize: 12),
                //     ),
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class CommentAndHistoryAction extends StatelessWidget {
  const CommentAndHistoryAction({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'Thảo luận',
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'Lịch sử hoạt động',
                ),
              ),
            ],
          ),
          Stack(
            alignment: Alignment.topCenter,
            children: [
              const Divider(),
              Positioned(
                left: 20,
                top: 7,
                child: Container(
                  width: 70,
                  height: 2,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            padding: EdgeInsets.symmetric(vertical: 8),
            width: double.infinity,
            child: Column(
              children: [
                Text('Hiện chưa có bình luận nào'),
                VerticalSpacing(of: 20),
                Container(
                  child: TextFormField(
                    maxLines: null,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        // enabledBorder: OutlineInputBorder(
                        //   borderSide:
                        //       BorderSide(color: Colors.blue),
                        //   borderRadius:
                        //       BorderRadius.circular(12),
                        // ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                        prefixIcon: Container(
                          padding: EdgeInsets.only(bottom: 13),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(
                                Icons.arrow_circle_up_rounded,
                                color: Colors.black45,
                              ),
                            ],
                          ),
                        ),
                        suffixIcon: Container(
                          padding: EdgeInsets.only(bottom: 13),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Icon(
                                Icons.attach_file_rounded,
                                color: Colors.black45,
                              ),
                              SizedBox(width: 5),
                              Icon(
                                Icons.sentiment_satisfied_rounded,
                                color: Colors.black45,
                              ),
                              SizedBox(width: 5),
                              Icon(
                                Icons.send_rounded,
                                color: Colors.black45,
                              ),
                              SizedBox(width: 8),
                            ],
                          ),
                        )),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class InfoUserWork extends StatelessWidget {
  const InfoUserWork({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailTicketBloc, DetailTicketState>(
        buildWhen: (previous, current) =>
            previous.userWork != current.userWork ||
            previous.ticket != current.ticket,
        builder: (context, state) {
          final ticket = context.detailTicketBloc.state.ticket;
          final userWork = context.detailTicketBloc.state.userWork;
          final user = context.detailTicketBloc.state.ticket!.user;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ItemInfo(
                      title: 'Họ và tên',
                      child: Container(
                        padding: defaultPadding(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                            color: Colors.red[50],
                            borderRadius: BorderRadius.circular(12)),
                        child: Text(
                          ticket!.user!.fullname,
                          style: FONT_CONST.medium(
                            color: Colors.red[400],
                          ),
                        ),
                      ),
                    ),
                  ),
                  HorizontalSpacing(of: 10),
                  Expanded(
                    child: ItemInfo(
                      title: 'Mã nhân viên',
                      content: '--',
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ItemInfo(
                      title: user!.userType.type >= UserType.LEADER.type
                          ? 'Team'
                          : (user.userType.type >= UserType.MANAGER.type)
                              ? 'Phòng ban'
                              : (user.userType.type >= UserType.DIRECTOR.type)
                                  ? 'Chi nhánh'
                                  : 'Tổ chức',
                      content: user.userType.type >= UserType.LEADER.type
                          ? userWork?.team?.name
                          : (user.userType.type >= UserType.MANAGER.type)
                              ? userWork?.department?.name
                              : (user.userType.type >= UserType.DIRECTOR.type)
                                  ? userWork?.branchOffice?.name
                                  : userWork?.organization?.name,
                    ),
                  ),
                  HorizontalSpacing(of: 10),
                  Expanded(
                    child: ItemInfo(
                      title: 'Vị trí',
                      content: userWork?.position ?? '',
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ItemInfo(
                      title: 'Kiểu đơn',
                      content: ticket.ticketType.value,
                    ),
                  ),
                  HorizontalSpacing(of: 10),
                  Expanded(
                    child: ItemInfo(
                      title: 'Lý do',
                      content: ticket.dateTimeTickets![0].ticketReason.name,
                    ),
                  ),
                ],
              ),
            ],
          );
        });
  }
}

class ItemInfo extends StatelessWidget {
  const ItemInfo({super.key, required this.title, this.child, this.content});
  final String title;
  final Widget? child;
  final String? content;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        VerticalSpacing(),
        Container(
          height: 2,
          width: 15,
          decoration: BoxDecoration(
              color: Colors.amber, borderRadius: BorderRadius.circular(12)),
        ),
        SizedBox(
          height: 3,
        ),
        Text(
          title,
          style: FONT_CONST.bold(color: Colors.grey.shade500, fontSize: 14),
        ),
        const VerticalSpacing(of: 5),
        child != null
            ? child!
            : Text(
                content ?? '--',
                style: FONT_CONST.medium(fontSize: 16),
              ),
      ],
    );
  }
}
