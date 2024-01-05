import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:firefly/configs/resources/barrel_const.dart';
import 'package:firefly/custom_widget/default_padding.dart';
import 'package:firefly/custom_widget/popup_notification_custom.dart';
import 'package:firefly/data/arguments/edit_branch_argument.dart';
import 'package:firefly/data/enum_type/user_type.dart';
import 'package:firefly/data/model/branch_office_model.dart';
import 'package:firefly/screens/app_router.dart';
import 'package:firefly/screens/organization_structure_group_screen/branch_office_screen_group/branch_office_screen/bloc/branch_office_bloc.dart';
import 'package:firefly/utils/singleton.dart';
import 'package:firefly/utils/size_config.dart';

class BranchsListWidget extends StatelessWidget {
  const BranchsListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final list = context.branchOfficeBloc.state.branchesList;
    return ListView.separated(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: list!.length,
      itemBuilder: (context, index) => BranchItem(
        branch: list[index],
        index: index,
      ),
      separatorBuilder: (context, index) => Divider(
        color: COLOR_CONST.cloudBurst.withOpacity(0.5),
        height: 1,
      ),
    );
  }
}

class BranchItem extends StatelessWidget {
  const BranchItem({
    super.key,
    required this.branch,
    required this.index,
  });
  final BranchOfficeModel branch;
  final int index;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(
          AppRouter.DEPARTMENT_SCREEN,
          arguments: branch.id,
        );
      },
      child: Ink(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
            color: index % 2 != 0
                ? COLOR_CONST.lineGrey.withOpacity(0.1)
                : COLOR_CONST.backgroundColor),
        child: Row(
          children: [
            Container(
                padding: defaultPadding(
                  horizontal: 25,
                ),
                child: Text(
                  '${(index + 1)}',
                  style: FONT_CONST.bold(),
                )),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    branch.name ?? '',
                    style: FONT_CONST.extraBold(
                      color: COLOR_CONST.cloudBurst,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "${'address'.tr()}: ",
                          style: FONT_CONST.medium(
                            color: COLOR_CONST.cloudBurst,
                            fontSize: 14,
                          ),
                        ),
                        TextSpan(
                          text: branch.address,
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
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '${"director1".tr()}: ',
                          style: FONT_CONST.medium(
                            color: COLOR_CONST.cloudBurst,
                            fontSize: 14,
                          ),
                        ),
                        TextSpan(
                          text: branch.director?.fullname ?? '',
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
                          text: branch.numberEmployees.toString(),
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
                  if (Singleton.instance.userType!.type <= UserType.CEO.type)
                    Row(
                      children: [
                        InkWell(
                          onTap: () async {
                            final value = await Navigator.of(context).pushNamed(
                              AppRouter.EDIT_BRANCH_OFFICE_SCREEN,
                              arguments: EditBranchArgument(
                                idOrganization: context
                                    .branchOfficeBloc.state.organizationId,
                                branchModel: branch,
                              ),
                            );

                            if (value == true) {
                              context.branchOfficeBloc
                                  .add(GetBranchOfficeEvent());
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
                        if (branch.director?.id !=
                            Singleton.instance.userProfile?.id)
                          InkWell(
                            onTap: () {
                              PopupNotificationCustom.showMessgae(
                                title: 'msg_confirm_delete'.tr(),
                                message: "msg_confirm_note_delete_branch".tr(),
                                pressButtonRight: () {
                                  context.branchOfficeBloc.add(
                                      DeleteBranchOfficeEvent(id: branch.id!));
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
      ),
    );
  }
}
