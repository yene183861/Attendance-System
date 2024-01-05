import 'package:easy_localization/easy_localization.dart';
import 'package:firefly/custom_widget/appbar_default_custom.dart';
import 'package:firefly/custom_widget/loading_show_able.dart';
import 'package:firefly/custom_widget/search_user_field.dart';
import 'package:firefly/custom_widget/toast_show_able/barrel_toast.dart';
import 'package:firefly/custom_widget/user_work_infomation.dart';
import 'package:firefly/data/arguments/common_argument.dart';
import 'package:firefly/data/enum_type/user_type.dart';
import 'package:firefly/data/model/user_work_model.dart';
import 'package:firefly/screens/ticket_group_screen/ticket_screen/components/checkbox_your_ticket.dart';
import 'package:firefly/screens/ticket_group_screen/ticket_screen/components/filter_by_ticket_status.dart';
import 'package:firefly/screens/ticket_group_screen/ticket_screen/components/filter_ticket_dialog.dart';
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
import 'package:firefly/utils/singleton.dart';
import 'package:firefly/utils/size_config.dart';
import 'package:rxdart/rxdart.dart';

import 'components/filter_by_month.dart';
import 'components/filter_ticket_type.dart';

class TicketScreen extends StatelessWidget {
  const TicketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: BlocProvider(
            create: (context) => TicketBloc(), child: const BodyScreen()),
      ),
      appBar: AppbarDefaultCustom(
        title: 'title_ticket_management'.tr(),
        isCallBack: true,
      ),
    );
  }
}

class BodyScreen extends StatefulWidget {
  const BodyScreen({super.key});

  @override
  State<BodyScreen> createState() => _BodyScreenState();
}

class _BodyScreenState extends State<BodyScreen> {
  late TextEditingController searchController;

  final textSearchChange = BehaviorSubject<String>();

  @override
  void initState() {
    super.initState();
    context.ticketBloc.add(InitEvent());
    searchController = TextEditingController();
    searchController.addListener(() {
      textSearchChange.value = searchController.text;
    });
    textSearchChange
        .debounceTime(const Duration(milliseconds: 100))
        .distinct()
        .listen((searchText) {
      final textSearch = searchText.trim();

      context.ticketBloc.add(SearchUserWorkEvent(name: textSearch));
    });
  }

  @override
  void dispose() {
    super.dispose();
    searchController.removeListener(() {});
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userType = Singleton.instance.userProfile!.userType;
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
              // const LeaveStatisticsWidget(),
              if (userType.type >= UserType.DIRECTOR.type)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: defaultPadding(vertical: 0),
                      child: PrimaryButton(
                        title: 'title_create_ticket1'.tr(),
                        onPressed: () async {
                          final value = await Navigator.of(context)
                              .pushNamed(AppRouter.EDIT_TICKET_SCREEN);
                          if (value == true) {
                            context.ticketBloc.add(GetTicketEvent());
                          }
                        },
                      ),
                    ),
                    const VerticalSpacing(of: 20),
                    const Divider(height: 1),
                  ],
                ),
            ],
          ),
          const VerticalSpacing(of: 20),
          if (userType.type < UserType.MANAGER.type)
            Row(
              children: [
                Row(
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () async {
                        final state = context.ticketBloc.state;
                        final arg = CommonArgument(
                          organizationsList: state.organizationList,
                          branchList: state.branchList,
                          departmentList: state.departmentList,
                          teamList: state.teamList,
                          selectedBranch: state.selectedBranch,
                          selectedOrganization: state.selectedOrganization,
                          selectedDepartment: state.selectedDepartment,
                          selectedTeam: state.selectedTeam,
                        );
                        final res = await showDialog(
                            context: context,
                            builder: (mContext) => BlocProvider(
                                  create: (context) => TicketBloc(
                                    commonArgument: arg,
                                  )
                                    ..add(GetBranchOfficeEvent())
                                    ..add(GetDepartmentEvent())
                                    ..add(GetTeamEvent()),
                                  child: const Dialog(
                                    child: FilterTicketDialog(),
                                  ),
                                ));
                        if (res is CommonArgument) {
                          context.ticketBloc.add(
                              SelectUserEvent(user: const UserWorkModel()));

                          context.ticketBloc.add(CopyStateEvent(arg: res));
                        }
                      },
                      child: Ink(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Image.asset(
                          ICON_CONST.icFilter1.path,
                          width: 22,
                          height: 22,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const HorizontalSpacing(of: 8),
                  ],
                ),
                if (userType.type <= UserType.LEADER.type)
                  Expanded(
                    child: BlocBuilder<TicketBloc, TicketState>(
                        buildWhen: (p, c) =>
                            p.users != c.users ||
                            p.selectedUser != c.selectedUser,
                        builder: (context, state) {
                          return SearchUserField(
                            onSelectedUser: (UserWorkModel) {
                              context.ticketBloc
                                  .add(SelectUserEvent(user: UserWorkModel));
                            },
                            textController: searchController,
                            users: state.users ?? [],
                            userWorkModel: state.selectedUser,
                            textSearchChange: (String) {
                              searchController.notifyListeners();
                            },
                          );
                        }),
                  ),
              ],
            ),
          Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: const FilterByMonth()),
              if (userType.type <= UserType.LEADER.type &&
                  userType.type >= UserType.DIRECTOR.type)
                const CheckboxYourTicket(),
              const HorizontalSpacing(of: 20),
            ],
          ),
          const FilterByTicketType(),
          const FilterByTicketStatus(),
          Padding(
            padding: defaultPadding(vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<TicketBloc, TicketState>(
                  buildWhen: (p, c) => p.isYourTicket != c.isYourTicket,
                  builder: (context, state) => Text(
                    state.isYourTicket
                        ? 'Danh sách đơn từ của bạn'
                        : 'Danh sách đơn từ dưới sự quản lý của bạn',
                    style: FONT_CONST.medium(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
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

                BlocBuilder<TicketBloc, TicketState>(
                    buildWhen: (previous, current) =>
                        previous.ticketList != current.ticketList ||
                        previous.status != current.status,
                    builder: (context, state) => state.selectedUser != null &&
                            (state.selectedUser?.id !=
                                Singleton.instance.userWork?.id)
                        ? Padding(
                            padding:
                                defaultPadding(horizontal: 0, vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Đơn từ của nhân sự: ',
                                  style: FONT_CONST.regular(),
                                ),
                                const VerticalSpacing(of: 8),
                                if (state.selectedUser != null &&
                                    state.selectedUser?.id != null)
                                  UserInfomationWork(
                                    userWorkModel: state.selectedUser!,
                                  ),
                              ],
                            ),
                          )
                        : const SizedBox.shrink()),
                const VerticalSpacing(),

                BlocBuilder<TicketBloc, TicketState>(
                  buildWhen: (previous, current) =>
                      previous.ticketList != current.ticketList ||
                      previous.status != current.status,
                  builder: (context, state) => state
                          .status.isSubmissionInProgress
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
          ),
        ],
      ),
    );
  }
}
