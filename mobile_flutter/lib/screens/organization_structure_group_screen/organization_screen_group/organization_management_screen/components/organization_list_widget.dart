import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:firefly/configs/resources/barrel_const.dart';
import 'package:firefly/custom_widget/popup_notification_custom.dart';
import 'package:firefly/screens/app_router.dart';
import 'package:firefly/screens/organization_structure_group_screen/organization_screen_group/organization_management_screen/bloc/organization_bloc.dart';
import 'package:firefly/utils/singleton.dart';
import 'package:firefly/utils/size_config.dart';

import '../../../../../data/model/organization_model.dart';

class OrganizationsListWidget extends StatelessWidget {
  const OrganizationsListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final organizationList = context.organizationBloc.state.organizationsList;
    return ListView.separated(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: organizationList!.length,
      itemBuilder: (context, index) =>
          OrganizationItem(organization: organizationList[index]),
      separatorBuilder: (context, index) => Divider(
        color: COLOR_CONST.cloudBurst.withOpacity(0.5),
        height: 1,
      ),
    );
  }
}

class OrganizationItem extends StatelessWidget {
  const OrganizationItem({
    super.key,
    required this.organization,
  });
  final OrganizationModel organization;

  @override
  Widget build(BuildContext context) {
    final name = organization.logo?.split('/').last.split('?');
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(
          AppRouter.BRANCH_OFFICE_SCREEN,
          arguments: organization.id,
        );
      },
      child: Ink(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Container(
              height: 80,
              width: 80,
              margin: const EdgeInsets.only(right: 20),
              child: ClipRRect(
                clipBehavior: Clip.hardEdge,
                borderRadius: BorderRadius.circular(6),
                child: CachedNetworkImage(
                  cacheKey: name?.first,
                  fit: BoxFit.cover,
                  imageUrl: organization.logo ?? '',
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  placeholder: (context, url) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(IMAGE_CONST.imgOffice.path),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(IMAGE_CONST.imgOffice.path),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    organization.name ?? '',
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
                          text: organization.address,
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
                          text: '${"ceo1".tr()}: ',
                          style: FONT_CONST.medium(
                            color: COLOR_CONST.cloudBurst,
                            fontSize: 14,
                          ),
                        ),
                        TextSpan(
                          text: organization.owner?.fullname ?? '',
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
                          text: organization.numberEmployees.toString(),
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
                  Row(
                    children: [
                      InkWell(
                        onTap: () async {
                          final value = await Navigator.of(context).pushNamed(
                              AppRouter.EDIT_ORGANIZATION_SCREEN,
                              arguments: organization);

                          if (value is OrganizationModel) {
                            context.organizationBloc
                                .add(GetOrganizationEvent());
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
                      if (organization.owner?.id !=
                          Singleton.instance.userProfile?.id)
                        InkWell(
                          onTap: () {
                            PopupNotificationCustom.showMessgae(
                              title: 'msg_confirm_delete'.tr(),
                              message:
                                  "msg_confirm_note_delete_organization".tr(),
                              pressButtonRight: () {
                                context.organizationBloc.add(
                                    DeleteOrganizationEvent(
                                        id: organization.id!));
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
