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
import 'package:firefly/screens/organization_structure_group_screen/team_screen/bloc/team_bloc.dart';
import 'package:firefly/utils/size_config.dart';

import 'components/dialog_edit_team.dart';
import 'components/team_list_widget.dart';

class TeamScreen extends StatelessWidget {
  const TeamScreen({
    super.key,
    required this.departmentId,
  });
  final int departmentId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: COLOR_CONST.backgroundColor,
      resizeToAvoidBottomInset: false,
      body: BlocProvider(
        create: (context) => TeamBloc(departmentId: departmentId),
        child: const TeamScreenBody(),
      ),
    );
  }
}

class TeamScreenBody extends StatefulWidget {
  const TeamScreenBody({
    super.key,
  });

  @override
  State<TeamScreenBody> createState() => _TeamScreenBodyState();
}

class _TeamScreenBodyState extends State<TeamScreenBody> {
  @override
  void initState() {
    super.initState();
    context.teamBloc.add(GetTeamEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TeamBloc, TeamState>(
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
          if (state.message != null && state.message!.isNotEmpty) {
            LoadingShowAble.hideLoading();

            ToastShowAble.show(
              toastType: ToastMessageType.SUCCESS,
              message: state.message ?? '',
            );
            context.teamBloc.add(GetTeamEvent());
          }
        } else {
          LoadingShowAble.hideLoading();
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppbarDefaultCustom(title: 'Quản lý các nhóm'.tr(), isCallBack: true),
          Padding(
            padding: EdgeInsets.only(
              left: getProportionateScreenWidth(20),
              right: getProportionateScreenWidth(20),
              top: getProportionateScreenHeight(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (Singleton.instance.userType!.type <= UserType.MANAGER.type)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PrimaryButton(
                        title: 'Thêm team'.tr(),
                        width: SizeConfig.screenWidth * 0.5,
                        onPressed: () async {
                          final res = await showDialog(
                            context: context,
                            builder: (mContext) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                backgroundColor: COLOR_CONST.backgroundColor,
                                child: BlocProvider.value(
                                  value: context.teamBloc,
                                  child: DialogEditTeam(
                                    onTap: (value) {
                                      context.teamBloc
                                          .add(CreateTeamEvent(name: value));
                                    },
                                    isAdd: true,
                                  ),
                                ),
                              );
                            },
                          );
                          if (res) {
                            context.teamBloc.add(GetTeamEvent());
                          }
                        },
                      ),
                      const VerticalSpacing(of: 10),
                    ],
                  ),
                Text(
                  '${'Danh sách các team trong chi nhánh'.tr()}',
                  style: FONT_CONST.semoBold(fontSize: 18),
                ),
                const VerticalSpacing(),
                BlocBuilder<TeamBloc, TeamState>(
                  buildWhen: (previous, current) =>
                      previous.status != current.status ||
                      previous.teamsList != current.teamsList,
                  builder: (context, state) {
                    return state.status.isSubmissionInProgress
                        ? const ShimmerBranchList()
                        : (state.teamsList != null &&
                                state.teamsList!.isNotEmpty)
                            ? const TeamsListWidget()
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
