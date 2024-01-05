import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firefly/data/enum_type/user_type.dart';
import 'package:firefly/utils/singleton.dart';
import 'package:flutter/material.dart';
import 'package:firefly/configs/resources/barrel_const.dart';
import 'package:firefly/custom_widget/default_padding.dart';
import 'package:firefly/custom_widget/popup_notification_custom.dart';
import 'package:firefly/data/arguments/edit_bonus_param.dart';
import 'package:firefly/data/model/reward_discipline_model.dart';
import 'package:firefly/data/model/user_work_model.dart';
import 'package:firefly/screens/app_router.dart';
import 'package:firefly/screens/bonus_discipline_screen_group/bonus_discripline_screen/bloc/bonus_discipline_bloc.dart';
import 'package:firefly/utils/size_config.dart';

class RewardItem extends StatelessWidget {
  const RewardItem({
    super.key,
    required this.model,
  });
  final RewardOrDisciplineModel model;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
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
            rewardOrDisModel: model,
            isReward: true,
          ),
        );
        if (res == true || res is UserWorkModel) {
          context.bonusDisciplineBloc.add(GetBonusDisciplineEvent());
        }
      },
      child: Container(
        width: double.infinity,
        padding: defaultPadding(horizontal: 0, vertical: 15),
        margin: EdgeInsets.only(top: getProportionateScreenHeight(20)),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(12)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: defaultPadding(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                    color: model.isReward ? Colors.green[400] : Colors.red[400],
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    )),
                child: Text(
                  model.isReward ? 'Thưởng' : 'Phạt',
                  style: FONT_CONST.medium(fontSize: 14, color: Colors.white),
                ),
              ),
              if (Singleton.instance.userType!.type < model.user.userType.type)
                Padding(
                  padding:
                      EdgeInsets.only(right: getProportionateScreenWidth(20)),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () async {
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
                              rewardOrDisModel: model,
                              isReward: true,
                            ),
                          );
                          if (res == true || res is UserWorkModel) {
                            context.bonusDisciplineBloc
                                .add(GetBonusDisciplineEvent());
                          }
                        },
                        child: Ink(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Image.asset(
                            ICON_CONST.icEdit.path,
                            width: 22,
                            height: 22,
                            color: COLOR_CONST.cloudBurst,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const HorizontalSpacing(),
                      InkWell(
                        onTap: () {
                          PopupNotificationCustom.showMessgae(
                            title: 'msg_confirm_delete'.tr(),
                            message: 'msg_confirm_delete_reward'.tr(),
                            hiddenButtonRight: false,
                            pressButtonRight: () {
                              context.bonusDisciplineBloc
                                  .add(DeleteBonusEvent(id: model.id!));
                            },
                          );
                        },
                        child: Ink(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Image.asset(
                            ICON_CONST.icDelete.path,
                            width: 22,
                            height: 22,
                            color: COLOR_CONST.cloudBurst,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          Container(
            padding: defaultPadding(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(
                      height: getProportionateScreenHeight(50),
                      width: getProportionateScreenHeight(50),
                      child: CachedNetworkImage(
                        imageUrl: model.user.avatarThumb ?? '',
                        placeholder: (context, url) => CircleAvatar(
                          backgroundImage: AssetImage(
                            IMAGE_CONST.imgDefaultAvatar.path,
                          ),
                        ),
                        errorWidget: (context, url, error) => CircleAvatar(
                          backgroundImage: AssetImage(
                            IMAGE_CONST.imgDefaultAvatar.path,
                          ),
                        ),
                        imageBuilder: (context, imageProvider) => CircleAvatar(
                          backgroundImage: imageProvider,
                        ),
                      ),
                    ),
                    const HorizontalSpacing(of: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(model.user.fullname, style: FONT_CONST.medium()),
                          Text(model.user.email, style: FONT_CONST.regular()),
                        ],
                      ),
                    ),
                  ],
                ),
                const VerticalSpacing(of: 8),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: 'Tiêu đề: '),
                      TextSpan(text: model.title),
                    ],
                  ),
                  style: FONT_CONST.medium(),
                ),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: 'Mô tả: '),
                      TextSpan(text: model.content),
                    ],
                  ),
                  style: FONT_CONST.regular(),
                ),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: 'Số tiền: '),
                      TextSpan(
                          text: model.amount.toString(),
                          style: FONT_CONST.medium()),
                      TextSpan(text: ' VND'),
                    ],
                  ),
                  style: FONT_CONST.regular(),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
