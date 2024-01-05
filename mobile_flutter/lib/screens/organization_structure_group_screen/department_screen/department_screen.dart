import 'package:easy_localization/easy_localization.dart';
import 'package:firefly/data/enum_type/user_type.dart';
import 'package:firefly/utils/singleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:firefly/configs/resources/barrel_const.dart';
import 'package:firefly/custom_widget/appbar_default_custom.dart';
import 'package:firefly/custom_widget/loading_show_able.dart';
import 'package:firefly/custom_widget/popup_notification_custom.dart';
import 'package:firefly/custom_widget/primary_button.dart';
import 'package:firefly/custom_widget/toast_show_able/barrel_toast.dart';

import 'package:firefly/screens/organization_structure_group_screen/branch_office_screen_group/branch_office_screen/components/shimmer_branch_list.dart';
import 'package:firefly/utils/size_config.dart';

import 'bloc/department_bloc.dart';
import 'components/department_list_widget.dart';
import 'components/dialog_edit_department.dart';

class DepartmentScreen extends StatelessWidget {
  const DepartmentScreen({
    super.key,
    required this.branchId,
  });
  final int branchId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: COLOR_CONST.backgroundColor,
      resizeToAvoidBottomInset: false,
      body: BlocProvider(
        create: (context) => DepartmentBloc(branchId: branchId),
        child: const DepartmentScreenBody(),
      ),
    );
  }
}

class DepartmentScreenBody extends StatefulWidget {
  const DepartmentScreenBody({
    super.key,
  });

  @override
  State<DepartmentScreenBody> createState() => _DepartmentScreenBodyState();
}

class _DepartmentScreenBodyState extends State<DepartmentScreenBody> {
  @override
  void initState() {
    super.initState();
    context.departmentBloc.add(GetDepartmentEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DepartmentBloc, DepartmentState>(
      listenWhen: (p, c) => p.status != c.status,
      listener: (context, state) {
        if (state.status.isSubmissionInProgress) {
          LoadingShowAble.showLoading();
        } else if (state.status.isSubmissionFailure) {
          LoadingShowAble.hideLoading();
          PopupNotificationCustom.showMessgae(
            title: "title_error".tr(),
            message: state.message ?? '',
            hiddenButtonLeft: true,
          );
        } else if (state.status.isSubmissionSuccess) {
          LoadingShowAble.hideLoading();
          if (state.message != null && state.message!.isNotEmpty) {
            ToastShowAble.show(
              toastType: ToastMessageType.SUCCESS,
              message: state.message ?? '',
            );
            context.departmentBloc.add(GetDepartmentEvent());
          }
        } else {
          LoadingShowAble.hideLoading();
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppbarDefaultCustom(
              title: 'department_management'.tr(), isCallBack: true),
          Padding(
            padding: EdgeInsets.only(
              left: getProportionateScreenWidth(20),
              right: getProportionateScreenWidth(20),
              top: getProportionateScreenHeight(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (Singleton.instance.userType!.type <= UserType.DIRECTOR.type)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PrimaryButton(
                        title: 'add_department'.tr(),
                        width: SizeConfig.screenWidth * 0.5,
                        onPressed: () async {
                          await showDialog(
                            context: context,
                            builder: (mContext) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                backgroundColor: COLOR_CONST.backgroundColor,
                                child: BlocProvider.value(
                                  value: context.departmentBloc,
                                  child: DialogEditDepartment(
                                    onTap: (value) {
                                      context.departmentBloc.add(
                                          CreateDepartmentEvent(name: value));
                                    },
                                    isAdd: true,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                      const VerticalSpacing(of: 30),
                    ],
                  ),
                Text(
                  'departments_list'.tr(),
                  style: FONT_CONST.semoBold(fontSize: 20),
                ),
                const VerticalSpacing(),
                BlocBuilder<DepartmentBloc, DepartmentState>(
                  buildWhen: (previous, current) =>
                      previous.status != current.status ||
                      previous.departmentsList != current.departmentsList,
                  builder: (context, state) {
                    return state.status.isSubmissionInProgress
                        ? const ShimmerBranchList()
                        : (state.departmentsList != null &&
                                state.departmentsList!.isNotEmpty)
                            ? const DepartmentsListWidget()
                            : Center(
                                child: Text(
                                  'no_data'.tr(),
                                  style: FONT_CONST.regular(),
                                ),
                              );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
