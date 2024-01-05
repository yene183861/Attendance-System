import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:formz/formz.dart';
import 'package:firefly/custom_widget/appbar_default_custom.dart';
import 'package:firefly/custom_widget/default_padding.dart';
import 'package:firefly/custom_widget/dropdown_select_organization.dart';
import 'package:firefly/custom_widget/popup_notification_custom.dart';
import 'package:firefly/custom_widget/primary_button.dart';
import 'package:firefly/data/arguments/edit_ticket_reason_arguments.dart';
import 'package:firefly/data/enum_type/user_type.dart';
import 'package:firefly/screens/app_router.dart';
import 'package:firefly/screens/ticket_group_screen/ticket_reason_screen/bloc/ticket_reason_bloc.dart';
import 'package:firefly/screens/ticket_group_screen/ticket_reason_screen/components/filter_by_ticket_type.dart';
import 'package:firefly/screens/ticket_group_screen/ticket_reason_screen/components/filter_by_time.dart';
import 'package:firefly/screens/ticket_group_screen/ticket_reason_screen/components/item_ticket_reason.dart';
import 'package:firefly/screens/ticket_group_screen/ticket_reason_screen/components/shimmer_ticket_reason_list.dart';
import 'package:firefly/utils/singleton.dart';
import 'package:firefly/utils/size_config.dart';

import '../../../configs/resources/barrel_const.dart';

class TicketReasonScreen extends StatelessWidget {
  const TicketReasonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: COLOR_CONST.backgroundColor,
      appBar: AppbarDefaultCustom(
        title: 'ticket_reason'.tr(),
        isCallBack: true,
      ),
      body: BlocProvider(
          create: (context) => TicketReasonBloc(),
          child: const TicketReasonScreenBody()),
    );
  }
}

class TicketReasonScreenBody extends StatefulWidget {
  const TicketReasonScreenBody({
    super.key,
  });

  @override
  State<TicketReasonScreenBody> createState() => _TicketReasonScreenBodyState();
}

class _TicketReasonScreenBodyState extends State<TicketReasonScreenBody> {
  @override
  void initState() {
    super.initState();
    context.ticketReasonBloc.add(InitEvent());
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
        dismissOnCapturedTaps: true,
        child: BlocListener<TicketReasonBloc, TicketReasonState>(
          listenWhen: (p, c) => p.status != c.status,
          listener: (context, state) {
            if (state.status.isSubmissionFailure) {
              PopupNotificationCustom.showMessgae(
                title: "title_error".tr(),
                message: state.message ?? "",
                hiddenButtonLeft: true,
              );
            }
          },
          child: Stack(
            alignment: Alignment.bottomCenter,
            fit: StackFit.expand,
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    // if (Singleton.instance.userProfile?.userType ==
                    //     UserType.ADMIN)
                    Padding(
                      padding: defaultPadding(horizontal: 25, vertical: 0),
                      child: BlocBuilder<TicketReasonBloc, TicketReasonState>(
                        buildWhen: (p, c) =>
                            p.organizationsList != c.organizationsList ||
                            p.selectedOrganization != c.selectedOrganization,
                        builder: (context, state) {
                          return DropdownSelectOrganization(
                            organizations: state.organizationsList ?? [],
                            selectedOrganization: state.selectedOrganization,
                            onSelectionChanged: (p0) {
                              context.ticketReasonBloc.add(
                                ChangeOrganizationEvent(organizationModel: p0),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    const FilterByTicketType(),
                    const FilterByTime(),
                    const Divider(
                      height: 1,
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        bottom: getProportionateScreenHeight(100),
                      ),
                      child: BlocBuilder<TicketReasonBloc, TicketReasonState>(
                        buildWhen: (p, c) {
                          return p.ticketReasonsList != c.ticketReasonsList ||
                              p.status != c.status;
                        },
                        builder: (context, state) {
                          return state.status.isSubmissionInProgress
                              ? const ShimmerTicketReasonList()
                              : (state.ticketReasonsList != null &&
                                      state.ticketReasonsList!.isNotEmpty)
                                  ? ListView.separated(
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) =>
                                          TicketReasonItem(
                                        ticketReason:
                                            state.ticketReasonsList![index],
                                        color: index % 2 == 0
                                            ? null
                                            : Colors.grey[50],
                                      ),
                                      separatorBuilder: (context, index) =>
                                          const Divider(height: 1),
                                      itemCount:
                                          state.ticketReasonsList!.length,
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.only(top: 100),
                                      child: Text(
                                        'no_data'.tr(),
                                        style: FONT_CONST.regular(),
                                      ),
                                    );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              if (Singleton.instance.userType!.type <= UserType.CEO.type)
                Positioned(
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: Container(
                      padding: defaultPadding(horizontal: 25),
                      decoration: BoxDecoration(
                          color: COLOR_CONST.backgroundColor,
                          boxShadow: [
                            BoxShadow(
                              color: COLOR_CONST.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(-2, -2),
                            ),
                          ]),
                      child: PrimaryButton(
                        title: 'create_ticket_reason'.tr(),
                        onPressed: () async {
                          final state = context.ticketReasonBloc.state;
                          final selectedOrg = state.selectedOrganization;
                          if (selectedOrg != null) {
                            final value = await Navigator.of(context).pushNamed(
                              AppRouter.EDIT_TICKET_REASON_SCREEN,
                              arguments: EditTicketReasonArgument(
                                organization: state.selectedOrganization,
                                byTime: state.byTime,
                                ticketType: state.ticketType,
                              ),
                            );
                            if (value == true) {
                              context.ticketReasonBloc
                                  .add(GetTicketReasonEvent());
                            }
                          } else {
                            PopupNotificationCustom.showMessgae(
                              title: 'title_error'.tr(),
                              message: 'Không có tổ chức nào',
                              hiddenButtonLeft: true,
                            );
                          }
                        },
                      ),
                    )),
            ],
          ),
        ));
  }
}
