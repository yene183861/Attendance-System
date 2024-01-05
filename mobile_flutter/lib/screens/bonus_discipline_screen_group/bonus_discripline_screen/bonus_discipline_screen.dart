import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import 'package:firefly/configs/resources/barrel_const.dart';
import 'package:firefly/custom_widget/custom_dropdown_date_picker.dart';
import 'package:firefly/custom_widget/default_padding.dart';

import 'package:firefly/custom_widget/loading_show_able.dart';
import 'package:firefly/custom_widget/popup_notification_custom.dart';
import 'package:firefly/custom_widget/primary_button.dart';
import 'package:firefly/custom_widget/search_user_tag.dart';
import 'package:firefly/custom_widget/toast_show_able/barrel_toast.dart';
import 'package:firefly/data/arguments/common_argument.dart';
import 'package:firefly/data/arguments/edit_bonus_param.dart';
import 'package:firefly/data/enum_type/user_type.dart';

import 'package:firefly/data/model/user_work_model.dart';
import 'package:firefly/screens/app_router.dart';
import 'package:firefly/screens/bonus_discipline_screen_group/bonus_discripline_screen/components/filter_dialog.dart';
import 'package:firefly/utils/pattern.dart';
import 'package:firefly/utils/singleton.dart';
import 'package:firefly/utils/size_config.dart';
import 'package:firefly/utils/utils.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:textfield_tags/textfield_tags.dart';

import 'bloc/bonus_discipline_bloc.dart';
import 'components/item_reward.dart';

class BonusDiscriplineScreen extends StatefulWidget {
  const BonusDiscriplineScreen({super.key});

  @override
  State<BonusDiscriplineScreen> createState() => _BonusDiscriplineScreenState();
}

class _BonusDiscriplineScreenState extends State<BonusDiscriplineScreen>
    with TickerProviderStateMixin {
  late TabController tabController;
  @override
  void initState() {
    super.initState();
    tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: 0,
    );
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: Scaffold(
          backgroundColor: COLOR_CONST.backgroundColor,
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            elevation: 0.3,
            title: Text(
              "Khen thưởng và kỷ luật",
              style: FONT_CONST.medium(fontSize: 22),
            ),
            leading: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                color: Colors.transparent,
                child: const Icon(
                  Icons.arrow_back,
                  color: COLOR_CONST.cloudBurst,
                ),
              ),
            ),
            backgroundColor: COLOR_CONST.backgroundColor,
            bottom: TabBar(
              controller: tabController,
              tabs: const [
                Tab(
                  iconMargin: EdgeInsets.zero,
                  height: 50,
                  text: "Khen thưởng",
                  icon: Icon(
                    Icons.attach_money,
                    size: 22,
                  ),
                ),
                Tab(
                  text: "Kỷ luật",
                  iconMargin: EdgeInsets.zero,
                  height: 50,
                  icon: Icon(
                    Icons.attach_money,
                    size: 22,
                  ),
                ),
              ],
              padding: EdgeInsets.zero,
              labelColor: COLOR_CONST.cloudBurst,
              labelStyle: FONT_CONST.medium(fontSize: 14),
              dividerColor: COLOR_CONST.backgroundColor,
              indicatorColor: COLOR_CONST.darkBlue,
              indicatorSize: TabBarIndicatorSize.label,
            ),
          ),
          body: BlocProvider(
              create: (context) => BonusDisciplineBloc(),
              child: _ScreenForm(tabController: tabController)),
        ),
      ),
    );
  }
}

class _ScreenForm extends StatefulWidget {
  const _ScreenForm({Key? key, required this.tabController}) : super(key: key);
  final TabController tabController;

  @override
  State<_ScreenForm> createState() => _ScreenFormState();
}

class _ScreenFormState extends State<_ScreenForm> {
  TextEditingController searchController = TextEditingController();
  late DateRangePickerController calendarController;
  late TextfieldTagsController tagController;
  @override
  void initState() {
    super.initState();
    tagController = TextfieldTagsController();
    calendarController = DateRangePickerController();

    widget.tabController.addListener(() {
      context.bonusDisciplineBloc
          .add(ChangeTabEvent(isReward: widget.tabController.index == 0));
    });
    context.bonusDisciplineBloc.add(InitEvent());
  }

  @override
  void dispose() {
    // tagController.dispose();
    widget.tabController.removeListener(() {});
    calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userType = Singleton.instance.userType!;

    return BlocListener<BonusDisciplineBloc, BonusDisciplineState>(
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
              context.bonusDisciplineBloc.add(GetBonusDisciplineEvent());
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
        child: Stack(
          alignment: Alignment.bottomCenter,
          fit: StackFit.expand,
          children: [
            Padding(
              padding: defaultPadding(horizontal: 20, vertical: 25),
              child: Column(
                children: [
                  Row(
                    children: [
                      if (userType.type <= UserType.DIRECTOR.type)
                        Row(
                          children: [
                            InkWell(
                              onTap: () async {
                                final state = context.bonusDisciplineBloc.state;
                                final arg = CommonArgument(
                                  organizationsList: state.organizationsList,
                                  branchList: state.branchList,
                                  departmentList: state.departmentList,
                                  teamList: state.teamList,
                                  selectedBranch: state.selectedBranch,
                                  selectedOrganization:
                                      state.selectedOrganization,
                                  selectedDepartment: state.selectedDepartment,
                                  selectedTeam: state.selectedTeam,
                                );
                                final res = await showDialog(
                                    context: context,
                                    builder: (mContext) => BlocProvider(
                                          create: (context) =>
                                              BonusDisciplineBloc(
                                            commonArgument: arg,
                                          )
                                                ..add(GetBranchOfficeEvent())
                                                ..add(GetDepartmentEvent())
                                                ..add(GetTeamEvent()),
                                          child: const Dialog(
                                            child: FilterDialog(),
                                          ),
                                        ));
                                if (res is CommonArgument) {
                                  context.bonusDisciplineBloc.add(
                                      SelectUserEvent(user: UserWorkModel()));
                                  tagController.clearTags();
                                  context.bonusDisciplineBloc
                                      .add(CopyStateEvent(arg: res));
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
                          child: BlocConsumer<BonusDisciplineBloc,
                                  BonusDisciplineState>(
                              listenWhen: (p, c) =>
                                  p.users != c.users ||
                                  p.selectedUser != c.selectedUser,
                              listener: (context, state) {
                                searchController.notifyListeners();
                              },
                              buildWhen: (p, c) =>
                                  p.users != c.users ||
                                  p.selectedUser != c.selectedUser,
                              builder: (context, state) {
                                if (state.selectedUser?.id == null) {}
                                return SearchUserTagField(
                                  tagController: tagController,
                                  textController: searchController,
                                  users: state.users ?? [],
                                  searchUserWork: (p0) {
                                    context.bonusDisciplineBloc
                                        .add(SearchUserEvent(text: p0));
                                  },
                                  onTagDelete: () {
                                    context.bonusDisciplineBloc.add(
                                        SelectUserEvent(
                                            user: const UserWorkModel()));
                                  },
                                  selectedUser: (p0) {
                                    context.bonusDisciplineBloc
                                        .add(SelectUserEvent(user: p0));
                                  },
                                );
                              }),
                        ),
                    ],
                  ),
                  const VerticalSpacing(of: 10),
                  BlocBuilder<BonusDisciplineBloc, BonusDisciplineState>(
                    buildWhen: (p, c) => p.month != c.month,
                    builder: (context, state) => Row(
                      children: [
                        BlocBuilder<BonusDisciplineBloc, BonusDisciplineState>(
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
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade100),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade100),
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
                                  dateFormat:
                                      DateFormat(DateTimePattern.monthYear)),
                              isFullwidthDropBox: true,
                              view: DateRangePickerView.year,
                              isExpanded: true,
                              monthFormat: DateTimePattern.monthYear,
                              calendarController: calendarController,
                              dateInit:
                                  context.bonusDisciplineBloc.state.month ??
                                      DateTime.now(),
                              onSelectionChanged: (value) async {
                                FocusScope.of(context).unfocus();
                                context.bonusDisciplineBloc
                                    .add(FilterByMonthEvent(month: value));
                              },
                            ),
                          ),
                        ),
                        // ),
                      ],
                    ),
                  ),
                  const VerticalSpacing(of: 15),
                  Expanded(
                    child: TabBarView(
                      controller: widget.tabController,
                      children: [
                        BlocBuilder<BonusDisciplineBloc, BonusDisciplineState>(
                          buildWhen: (p, c) => p.rewardList != c.rewardList,
                          builder: (context, state) {
                            return Column(
                              children: [
                                BlocBuilder<BonusDisciplineBloc,
                                        BonusDisciplineState>(
                                    buildWhen: (p, c) =>
                                        p.selectedUser != c.selectedUser,
                                    builder: (context, state) {
                                      if (state.selectedUser?.id != null) {
                                        final user = state.selectedUser!.user;
                                        final isOwner = user!.id ==
                                            Singleton.instance.userProfile!.id;
                                        return Text(
                                          isOwner
                                              ? 'Quyết định khen thưởng đối với bạn'
                                              : 'Quyết định khen thưởng đối với nhân viên ${state.selectedUser!.user!.fullname}:',
                                          style: FONT_CONST.medium(),
                                          textAlign: TextAlign.center,
                                        );
                                      } else {
                                        return Text(
                                          'Danh sách khen thưởng',
                                          style: FONT_CONST.medium(),
                                        );
                                      }
                                    }),
                                (state.rewardList != null &&
                                        state.rewardList!.isNotEmpty)
                                    ? Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              top: getProportionateScreenHeight(
                                                  20)),
                                          child: ListView.separated(
                                              shrinkWrap: true,
                                              padding: EdgeInsets.only(
                                                bottom:
                                                    getProportionateScreenHeight(
                                                        100),
                                              ),
                                              // physics:
                                              //     const NeverScrollableScrollPhysics(),
                                              itemBuilder: (context, index) =>
                                                  RewardItem(
                                                    model: state
                                                        .rewardList![index],
                                                  ),
                                              separatorBuilder: (context,
                                                      index) =>
                                                  const VerticalSpacing(of: 5),
                                              itemCount:
                                                  state.rewardList!.length),
                                        ),
                                      )
                                    : SizedBox(
                                        height: 200,
                                        child: Center(
                                            child: Text(
                                          'Không có khoản khen thưởng nào',
                                          style:
                                              FONT_CONST.regular(fontSize: 14),
                                        )),
                                      )
                              ],
                            );
                          },
                        ),
                        BlocBuilder<BonusDisciplineBloc, BonusDisciplineState>(
                          buildWhen: (p, c) =>
                              p.disciplineList != c.disciplineList,
                          builder: (context, state) {
                            return Column(
                              children: [
                                BlocBuilder<BonusDisciplineBloc,
                                        BonusDisciplineState>(
                                    buildWhen: (p, c) =>
                                        p.selectedUser != c.selectedUser,
                                    builder: (context, state) {
                                      if (state.selectedUser?.id != null) {
                                        final user = state.selectedUser!.user;
                                        final isOwner = user!.id ==
                                            Singleton.instance.userProfile!.id;
                                        return Text(
                                          isOwner
                                              ? 'Quyết định kỷ luật đối với bạn'
                                              : 'Kỷ luật đối với nhân viên ${state.selectedUser!.user!.fullname}:',
                                          style: FONT_CONST.medium(),
                                          textAlign: TextAlign.center,
                                        );
                                      } else {
                                        return Text(
                                          'Danh sách kỷ luật',
                                          style: FONT_CONST.medium(),
                                        );
                                      }
                                    }),
                                (state.disciplineList != null &&
                                        state.disciplineList!.isNotEmpty)
                                    ? Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              top: getProportionateScreenHeight(
                                                  20)),
                                          child: ListView.separated(
                                              shrinkWrap: true,
                                              padding: EdgeInsets.only(
                                                bottom:
                                                    getProportionateScreenHeight(
                                                        100),
                                              ),
                                              itemBuilder: (context, index) =>
                                                  RewardItem(
                                                    model: state
                                                        .disciplineList![index],
                                                  ),
                                              separatorBuilder: (context,
                                                      index) =>
                                                  const VerticalSpacing(of: 5),
                                              itemCount:
                                                  state.disciplineList!.length),
                                        ),
                                      )
                                    : SizedBox(
                                        height: 200,
                                        child: Center(
                                            child: Text(
                                          'Không có khoản kỷ luật nào',
                                          style:
                                              FONT_CONST.regular(fontSize: 14),
                                        )),
                                      )
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (Singleton.instance.userType!.type <= UserType.LEADER.type)
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
                    child:
                        BlocBuilder<BonusDisciplineBloc, BonusDisciplineState>(
                      buildWhen: (p, c) => p.isReward != c.isReward,
                      builder: (context, state) => PrimaryButton(
                        title: state.isReward
                            ? 'Thêm khen thưởng'.tr()
                            : 'Thêm mới kỷ luật'.tr(),
                        onPressed: () async {
                          final state = context.bonusDisciplineBloc.state;

                          final res = await Navigator.of(context).pushNamed(
                            AppRouter.EDIT_BONUS_DISCRIPLINE_SCREEN,
                            arguments: EditBonusArgument(
                              organizationsList: state.organizationsList,
                              branchList: state.branchList,
                              departmentList: state.departmentList,
                              teamList: state.teamList,
                              selectedOrganization: state.selectedOrganization,
                              selectedBranch: state.selectedBranch,
                              selectedDepartment: state.selectedDepartment,
                              selectedTeam: state.selectedTeam,
                              rewardOrDisModel: null,
                              isReward: widget.tabController.index == 0
                                  ? true
                                  : false,
                            ),
                          );
                          if (res == true) {
                            context.bonusDisciplineBloc
                                .add(GetBonusDisciplineEvent());
                          }
                          if (res is UserWorkModel) {
                            context.bonusDisciplineBloc
                                .add(SelectUserEvent(user: res));
                          }
                        },
                      ),
                    ),
                  )),
          ],
        ));
  }
}
