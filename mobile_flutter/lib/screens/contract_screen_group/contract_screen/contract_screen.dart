import 'package:easy_localization/easy_localization.dart';
import 'package:firefly/custom_widget/appbar_default_custom.dart';
import 'package:firefly/custom_widget/default_padding.dart';
import 'package:firefly/custom_widget/loading_show_able.dart';
import 'package:firefly/custom_widget/popup_notification_custom.dart';
import 'package:firefly/custom_widget/primary_button.dart';
import 'package:firefly/custom_widget/search_user_field.dart';
import 'package:firefly/custom_widget/toast_show_able/barrel_toast.dart';
import 'package:firefly/custom_widget/user_work_infomation.dart';
import 'package:firefly/data/arguments/common_argument.dart';
import 'package:firefly/data/arguments/edit_contract_argument.dart';
import 'package:firefly/data/enum_type/user_type.dart';

import 'package:firefly/data/model/user_work_model.dart';
import 'package:firefly/screens/app_router.dart';
import 'package:firefly/utils/singleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:firefly/configs/resources/barrel_const.dart';

import 'package:firefly/utils/size_config.dart';
import 'package:formz/formz.dart';
import 'package:rxdart/rxdart.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import 'bloc/contract_bloc.dart';
import 'components/contract_item.dart';
import 'components/filter_contract_dialog.dart';

class ContractScreen extends StatelessWidget {
  const ContractScreen({super.key, this.isOpenFromDashboard});
  final bool? isOpenFromDashboard;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: COLOR_CONST.backgroundColor,
      body: BlocProvider(
        create: (context) => ContractBloc()..add(InitEvent()),
        child: _ContractScreenForm(
            isOpenFromDashboard: isOpenFromDashboard ?? false),
      ),
    );
  }
}

class _ContractScreenForm extends StatefulWidget {
  const _ContractScreenForm({Key? key, required this.isOpenFromDashboard})
      : super(key: key);
  final bool isOpenFromDashboard;

  @override
  _ContractScreenState createState() => _ContractScreenState();
}

class _ContractScreenState extends State<_ContractScreenForm> {
  late TextEditingController searchController;
  late DateRangePickerController calendarController1, calendarController2;

  final textSearchChange = BehaviorSubject<String>();

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    searchController.addListener(() {
      textSearchChange.value = searchController.text;
    });
    textSearchChange
        .debounceTime(const Duration(milliseconds: 100))
        .distinct()
        .listen((searchText) {
      final textSearch = searchText.trim();

      context.contractBloc.add(SearchUserWorkEvent(name: textSearch));
    });
    calendarController1 = DateRangePickerController();
    calendarController2 = DateRangePickerController();
  }

  @override
  void dispose() {
    super.dispose();
    searchController.removeListener(() {});
    searchController.dispose();
    calendarController1.dispose();
    calendarController2.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userType = Singleton.instance.userType;
    return BlocListener<ContractBloc, ContractState>(
      listenWhen: (p, c) => p.status != c.status,
      listener: (context, state) {
        if (state.status.isSubmissionInProgress) {
          LoadingShowAble.showLoading();
        } else if (state.status.isSubmissionSuccess) {
          LoadingShowAble.forceHide();
          if (state.message != null && state.message!.isNotEmpty) {
            if (state.message != null && state.message!.isNotEmpty) {
              ToastShowAble.show(
                toastType: ToastMessageType.SUCCESS,
                message: state.message ?? '',
              );
            }
          }
        } else if (state.status.isSubmissionFailure) {
          LoadingShowAble.forceHide();
          PopupNotificationCustom.showMessgae(
            title: "title_error".tr(),
            message: state.message ?? "",
            hiddenButtonRight: true,
          );
        } else {
          LoadingShowAble.forceHide();
        }
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            if (!widget.isOpenFromDashboard)
              const AppbarDefaultCustom(
                  title: 'Công việc và hợp đồng', isCallBack: true),
            Padding(
              padding: defaultPadding(horizontal: 20, vertical: 0),
              child: Column(children: [
                if (userType!.type <= UserType.DIRECTOR.type)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PrimaryBorderButton(
                        title: 'Thêm mới hợp đồng',
                        height: getProportionateScreenHeight(50),
                        onPressed: () async {
                          final state = context.contractBloc.state;
                          final res = await Navigator.of(context).pushNamed(
                            AppRouter.EDIT_CONTRACT_SCREEN,
                            arguments: EditContractArgument(
                              selectedUser: state.selectedUser?.id !=
                                      Singleton.instance.userWork!.id
                                  ? state.selectedUser
                                  : null,
                            ),
                          );
                          if (res == true) {
                            context.contractBloc.add(GetContractEvent());
                          }
                        },
                      ),
                      const VerticalSpacing(of: 15),
                    ],
                  ),
                if (userType.type < UserType.MANAGER.type)
                  Row(
                    children: [
                      Row(
                        children: [
                          InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () async {
                              final state = context.contractBloc.state;
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
                                        create: (context) => ContractBloc(
                                          commonArgument: arg,
                                        )
                                          ..add(GetBranchOfficeEvent())
                                          ..add(GetDepartmentEvent())
                                          ..add(GetTeamEvent()),
                                        child: const Dialog(
                                          child: FilterContractDialog(),
                                        ),
                                      ));
                              if (res is CommonArgument) {
                                context.contractBloc.add(
                                    SelectUserEvent(user: UserWorkModel()));

                                context.contractBloc
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
                      // if (userType.type <= UserType.LEADER.type)
                      Expanded(
                        child: BlocBuilder<ContractBloc, ContractState>(
                            buildWhen: (p, c) =>
                                p.users != c.users ||
                                p.selectedUser != c.selectedUser,
                            builder: (context, state) {
                              return SearchUserField(
                                onSelectedUser: (UserWorkModel) {
                                  context.contractBloc.add(
                                      SelectUserEvent(user: UserWorkModel));
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
                // const VerticalSpacing(of: 10),
                // Row(
                //   children: [
                //     Expanded(
                //       child: BlocBuilder<ContractBloc, ContractState>(
                //         buildWhen: (p, c) => p.startDate != c.startDate,
                //         builder: (context, state) => Column(
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           children: [
                //             Text(
                //               'Từ: ',
                //               style: FONT_CONST.regular(),
                //             ),
                //             const VerticalSpacing(of: 5),
                //             Container(
                //               height: 40,
                //               clipBehavior: Clip.hardEdge,
                //               decoration: BoxDecoration(
                //                 color: Colors.grey.shade100,
                //                 borderRadius: BorderRadius.circular(12),
                //               ),
                //               child: CustomDropdownDatePicker(
                //                 maxWidthButton: 180,
                //                 textStyleTitle: FONT_CONST.medium(),
                //                 inputDecoration: InputDecoration(
                //                   isDense: true,
                //                   fillColor: Colors.grey.shade100,
                //                   contentPadding: EdgeInsets.zero,
                //                   enabledBorder: OutlineInputBorder(
                //                     borderSide:
                //                         BorderSide(color: Colors.grey.shade100),
                //                     borderRadius: BorderRadius.circular(12),
                //                   ),
                //                   focusedBorder: OutlineInputBorder(
                //                     borderSide:
                //                         BorderSide(color: Colors.grey.shade100),
                //                     borderRadius: BorderRadius.circular(12),
                //                   ),
                //                 ),
                //                 suffixIcon: const SizedBox.shrink(),
                //                 prefixIcon: Row(
                //                   mainAxisSize: MainAxisSize.min,
                //                   children: [
                //                     Image.asset(
                //                       ICON_CONST.icCalendar1.path,
                //                       width: 22,
                //                       height: 22,
                //                       fit: BoxFit.cover,
                //                     ),
                //                     const HorizontalSpacing(),
                //                   ],
                //                 ),
                //                 backgroundColor: Colors.grey.shade100,
                //                 textTime: Utils.formatDateTimeToString(
                //                     time: state.startDate ?? DateTime.now(),
                //                     dateFormat:
                //                         DateFormat(DateTimePattern.dayType1)),
                //                 isFullwidthDropBox: true,
                //                 view: DateRangePickerView.month,
                //                 isExpanded: true,
                //                 monthFormat: DateTimePattern.monthYear,
                //                 calendarController: calendarController1,
                //                 dateInit: state.startDate ?? DateTime.now(),
                //                 onSelectionChanged: (value) async {
                //                   FocusScope.of(context).unfocus();
                //                   // context.bonusDisciplineBloc
                //                   //     .add(FilterByMonthEvent(month: value));
                //                 },
                //               ),
                //             ),
                //           ],
                //         ),
                //       ),
                //     ),
                //     // const HorizontalSpacing(of: 30),
                //     // Expanded(
                //     //   child: BlocBuilder<ContractBloc, ContractState>(
                //     //     buildWhen: (p, c) => p.endDate != c.endDate,
                //     //     builder: (context, state) => Column(
                //     //       crossAxisAlignment: CrossAxisAlignment.start,
                //     //       children: [
                //     //         Text(
                //     //           'Đến',
                //     //           style: FONT_CONST.regular(),
                //     //         ),
                //     //         const VerticalSpacing(of: 5),
                //     //         Container(
                //     //           height: 40,
                //     //           clipBehavior: Clip.hardEdge,
                //     //           decoration: BoxDecoration(
                //     //             color: Colors.grey.shade100,
                //     //             borderRadius: BorderRadius.circular(12),
                //     //           ),
                //     //           child: CustomDropdownDatePicker(
                //     //             maxWidthButton: 180,
                //     //             textStyleTitle: FONT_CONST.medium(),
                //     //             inputDecoration: InputDecoration(
                //     //               isDense: true,
                //     //               fillColor: Colors.grey.shade100,
                //     //               contentPadding: EdgeInsets.zero,
                //     //               enabledBorder: OutlineInputBorder(
                //     //                 borderSide:
                //     //                     BorderSide(color: Colors.grey.shade100),
                //     //                 borderRadius: BorderRadius.circular(12),
                //     //               ),
                //     //               focusedBorder: OutlineInputBorder(
                //     //                 borderSide:
                //     //                     BorderSide(color: Colors.grey.shade100),
                //     //                 borderRadius: BorderRadius.circular(12),
                //     //               ),
                //     //             ),
                //     //             suffixIcon: const SizedBox.shrink(),
                //     //             prefixIcon: Row(
                //     //               mainAxisSize: MainAxisSize.min,
                //     //               children: [
                //     //                 Image.asset(
                //     //                   ICON_CONST.icCalendar.path,
                //     //                   width: 22,
                //     //                   height: 22,
                //     //                   fit: BoxFit.cover,
                //     //                 ),
                //     //                 const HorizontalSpacing(),
                //     //               ],
                //     //             ),
                //     //             backgroundColor: Colors.grey.shade100,
                //     //             textTime: Utils.formatDateTimeToString(
                //     //                 time: state.endDate ?? DateTime.now(),
                //     //                 dateFormat:
                //     //                     DateFormat(DateTimePattern.dayType1)),
                //     //             isFullwidthDropBox: true,
                //     //             view: DateRangePickerView.month,
                //     //             isExpanded: true,
                //     //             monthFormat: DateTimePattern.monthYear,
                //     //             calendarController: calendarController1,
                //     //             dateInit: state.endDate ?? DateTime.now(),
                //     //             onSelectionChanged: (value) async {
                //     //               FocusScope.of(context).unfocus();
                //     //               // context.bonusDisciplineBloc
                //     //               //     .add(FilterByMonthEvent(month: value));
                //     //             },
                //     //           ),
                //     //         ),
                //     //       ],
                //     //     ),
                //     //   ),
                //     // ),
                //     // ),
                //   ],
                // ),

                const VerticalSpacing(),
                BlocBuilder<ContractBloc, ContractState>(
                  buildWhen: (p, c) => p.selectedUser != c.selectedUser,
                  builder: (context, state) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (state.selectedUser == null ||
                                state.selectedUser?.id == null)
                            ? 'Danh sách hợp đồng từ tổ chức của bạn'
                            : state.selectedUser?.id ==
                                    Singleton.instance.userWork?.id
                                ? 'Danh sách hợp đồng của bạn'
                                : 'Danh sách hợp đồng của nhân viên: ${state.selectedUser?.user?.fullname}',
                        textAlign: TextAlign.center,
                        style: FONT_CONST.bold(fontSize: 18),
                      ),
                      if (state.selectedUser != null &&
                          state.selectedUser?.id != null)
                        Padding(
                          padding: defaultPadding(vertical: 8, horizontal: 0),
                          child: UserInfomationWork(
                              userWorkModel: state.selectedUser!),
                        ),
                    ],
                  ),
                ),
                BlocBuilder<ContractBloc, ContractState>(
                  buildWhen: (p, c) => p.contractsList != c.contractsList,
                  builder: (context, state) => (state.contractsList != null &&
                          state.contractsList!.isNotEmpty)
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const VerticalSpacing(),
                            ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.only(
                                  bottom: getProportionateScreenHeight(100),
                                ),
                                itemBuilder: (context, index) => ContractItem(
                                      model: state.contractsList![index],
                                    ),
                                separatorBuilder: (context, index) =>
                                    const VerticalSpacing(of: 8),
                                itemCount: state.contractsList!.length),
                          ],
                        )
                      : Container(
                          height: 200,
                          child: Center(
                              child: Text(
                            'Không có hợp đồng nào',
                            style: FONT_CONST.regular(),
                          )),
                        ),
                ),
                const VerticalSpacing(of: 15),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
