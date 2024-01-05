import 'package:easy_localization/easy_localization.dart';
import 'package:firefly/data/enum_type/user_type.dart';
import 'package:firefly/utils/singleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firefly/configs/resources/barrel_const.dart';
import 'package:firefly/custom_widget/popup_notification_custom.dart';

import 'package:firefly/data/model/team_model.dart';
import 'package:firefly/screens/organization_structure_group_screen/team_screen/bloc/team_bloc.dart';
import 'package:firefly/screens/organization_structure_group_screen/team_screen/components/dialog_edit_team.dart';
import 'package:firefly/utils/size_config.dart';

class TeamsListWidget extends StatelessWidget {
  const TeamsListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final list = context.teamBloc.state.teamsList;
    return ListView.separated(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: list!.length,
      itemBuilder: (context, index) => TeamItem(team: list[index]),
      separatorBuilder: (context, index) => const VerticalSpacing(of: 5),
    );
  }
}

class TeamItem extends StatelessWidget {
  const TeamItem({
    super.key,
    required this.team,
  });
  final TeamModel team;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  team.name ?? '',
                  style: FONT_CONST.extraBold(
                    color: COLOR_CONST.cloudBurst,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(text: 'Quản lý: '),
                      TextSpan(
                        text: team.leader!.fullname.isEmpty
                            ? 'Chưa có'
                            : team.leader!.fullname,
                      ),
                    ],
                  ),
                  style: FONT_CONST.regular(fontSize: 14),
                ),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '${"Số lượng nhân sự".tr()}: ',
                        style: FONT_CONST.medium(
                          color: COLOR_CONST.cloudBurst,
                          fontSize: 14,
                        ),
                      ),
                      TextSpan(
                        text: team.numberEmployees.toString(),
                        style: FONT_CONST.medium(
                          color: COLOR_CONST.cloudBurst,
                          fontSize: 14,
                        ),
                      ),
                    ],
                    style: FONT_CONST.regular(
                      color: COLOR_CONST.cloudBurst,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                if (Singleton.instance.userType!.type <= UserType.MANAGER.type)
                  Row(
                    children: [
                      InkWell(
                        onTap: () async {
                          final value = await showDialog(
                            context: context,
                            builder: (mContext) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                backgroundColor: COLOR_CONST.backgroundColor,
                                child: BlocProvider.value(
                                  value: context.teamBloc,
                                  child: DialogEditTeam(
                                    text: team.name,
                                    onTap: (value) {
                                      context.teamBloc.add(UpdateTeamEvent(
                                          name: value, id: team.id!));
                                    },
                                    isAdd: false,
                                  ),
                                ),
                              );
                            },
                          );
                          if (value == true) {
                            context.teamBloc.add(GetTeamEvent());
                          }
                        },
                        child: Ink(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 5),
                          decoration: BoxDecoration(
                              color: COLOR_CONST.cloudBurst,
                              borderRadius: BorderRadius.circular(6)),
                          child: Text(
                            'update'.tr(),
                            style: FONT_CONST.regular(
                                color: COLOR_CONST.backgroundColor,
                                fontSize: 12),
                          ),
                        ),
                      ),
                      const HorizontalSpacing(of: 8),
                      InkWell(
                        onTap: () {
                          PopupNotificationCustom.showMessgae(
                            title: 'msg_confirm_delete'.tr(),
                            message: "msg_confirm_note_delete_team".tr(),
                            pressButtonRight: () {
                              context.teamBloc
                                  .add(DeleteTeamEvent(id: team.id!));
                            },
                          );
                        },
                        child: Ink(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 22, vertical: 5),
                          decoration: BoxDecoration(
                              color: COLOR_CONST.portlandOrange1,
                              borderRadius: BorderRadius.circular(6)),
                          child: Text(
                            'delete'.tr(),
                            style: FONT_CONST.regular(
                                color: COLOR_CONST.backgroundColor,
                                fontSize: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
