// import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firefly/custom_widget/loading_show_able.dart';
import 'package:firefly/custom_widget/toast_show_able/barrel_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:firefly/configs/resources/barrel_const.dart';
import 'package:firefly/custom_widget/default_padding.dart';
import 'package:firefly/custom_widget/popup_notification_custom.dart';
import 'package:firefly/custom_widget/primary_button.dart';

import 'package:firefly/screens/app_router.dart';
import 'package:firefly/screens/ticket_group_screen/ticket_screen/bloc/ticket_bloc.dart';
import 'package:firefly/screens/ticket_group_screen/ticket_screen/components/item_ticket.dart';
import 'package:firefly/screens/ticket_group_screen/ticket_screen/components/shimmer_ticket_item.dart';

import 'package:firefly/utils/size_config.dart';

import 'components/leave_statistics_widget.dart';

class ManageTicketScreen extends StatelessWidget {
  const ManageTicketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: defaultPadding(),
        child: BlocProvider(
            create: (context) => TicketBloc(), child: const BodyScreen()),
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
  @override
  void initState() {
    super.initState();
    context.ticketBloc.add(InitEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TicketBloc, TicketState>(
      listenWhen: (previous, current) => previous.status != current.status,
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
            context.ticketBloc.add(GetTicketEvent());
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'title_ticket_management'.tr(),
                style: FONT_CONST.bold(fontSize: 22, color: Colors.black87),
              ),
              const VerticalSpacing(of: 15),
              const LeaveStatisticsWidget(),
              const VerticalSpacing(),
              PrimaryButton(
                title: 'title_create_ticket1'.tr(),
                // textStyle: FONT_CONST.semoBold(color: Colors.black87),
                onPressed: () async {
                  final value = await Navigator.of(context)
                      .pushNamed(AppRouter.EDIT_TICKET_SCREEN);
                  if (value == true) {
                    context.ticketBloc.add(GetTicketEvent());
                  }
                },
              ),
              const VerticalSpacing(of: 20),
              const Divider(height: 1),
              const VerticalSpacing(of: 20),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Danh sách đơn từ của bạn',
                style: FONT_CONST.bold(fontSize: 18),
              ),
              // TicketTypeSelect(),
              // Container(
              //   decoration: BoxDecoration(
              //     border: Border.all(color: Colors.grey),
              //     borderRadius: BorderRadius.circular(15),
              //     color: COLOR_CONST.white,
              //   ),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       ...List.generate(
              //         StatusLeave.values.length,
              //         (index) => ItemStatusLeave(
              //             title: StatusLeave.values[index].name,
              //             isSelected: index == 0,
              //             onTap: () {
              //               // onTap(type: SpaOrderBy.values[index].type);
              //             }),
              //       ),
              //     ],
              //   ),
              // ),

              // Icon(Icons.filter_alt_outlined),
              VerticalSpacing(),

              BlocBuilder<TicketBloc, TicketState>(
                buildWhen: (previous, current) =>
                    previous.ticketList != current.ticketList ||
                    previous.status != current.status,
                builder: (context, state) => state.status.isSubmissionInProgress
                    ? const ShimmerTicketItem()
                    : state.ticketList != null && state.ticketList!.isNotEmpty
                        ? ListView.separated(
                            shrinkWrap: true,
                            physics: const ClampingScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemCount: state.ticketList!.length,
                            itemBuilder: (context, index) =>
                                ItemTicket(ticket: state.ticketList![index]),
                            separatorBuilder: (context, index) =>
                                const VerticalSpacing(of: 15),
                          )
                        : const SizedBox.shrink(),
              )
            ],
          ),
        ],
      ),
    );
  }
}
