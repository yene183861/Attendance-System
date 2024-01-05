import 'package:firefly/configs/resources/barrel_const.dart';
import 'package:firefly/custom_widget/custom_circle_avatar_from_network.dart';
import 'package:firefly/data/enum_type/user_type.dart';
import 'package:firefly/data/model/user_work_model.dart';
import 'package:firefly/utils/size_config.dart';
import 'package:flutter/material.dart';

class UserInfomationWork extends StatelessWidget {
  const UserInfomationWork({
    super.key,
    required this.userWorkModel,
  });

  final UserWorkModel userWorkModel;

  @override
  Widget build(BuildContext context) {
    final fullname = userWorkModel.user?.fullname;
    final email = userWorkModel.user?.email;
    final userType = userWorkModel.user?.userType;
    final organization = userWorkModel.organization?.name;
    final branchOffice = userWorkModel.branchOffice?.name;
    final department = userWorkModel.department?.name;
    final team = userWorkModel.team?.name;
    final position = userWorkModel.position;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          margin: EdgeInsets.only(right: getProportionateScreenWidth(10)),
          child: CustomCircleAvatarFromNetwork(
              urlImage: userWorkModel.user?.avatarThumb ?? '', size: 40),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: fullname),
                      const TextSpan(text: '  ( '),
                      TextSpan(text: email),
                      const TextSpan(text: ' )'),
                    ],
                  ),
                  style: FONT_CONST.regular(
                      color: COLOR_CONST.cloudBurst, fontSize: 16),
                ),
                SizedBox(height: getProportionateScreenHeight(5)),
                if (userWorkModel.user?.staffId != null &&
                    userWorkModel.user!.staffId!.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(text: 'Mã nhân viên: '),
                            TextSpan(text: userWorkModel.user?.staffId),
                          ],
                        ),
                        style: FONT_CONST.regular(
                            color: COLOR_CONST.cloudBurst, fontSize: 14),
                      ),
                      SizedBox(height: getProportionateScreenHeight(5)),
                    ],
                  ),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: 'Vị trí: '),
                      TextSpan(
                          text: (userType == UserType.STAFF
                                  ? position
                                  : userType!.value) ??
                              ''),
                    ],
                  ),
                  style: FONT_CONST.regular(
                      color: COLOR_CONST.cloudBurst, fontSize: 14),
                ),
                SizedBox(height: getProportionateScreenHeight(5)),
                userType!.type <= UserType.CEO.type
                    ? Text(
                        '$organization',
                        style: FONT_CONST.regular(
                            color: COLOR_CONST.cloudBurst, fontSize: 14),
                      )
                    : Text(
                        userType.type <= UserType.DIRECTOR.type
                            ? '$branchOffice, $organization'
                            : userType.type <= UserType.MANAGER.type
                                ? '$department, $branchOffice, $organization'
                                : '$team, $department, $branchOffice, $organization',
                        style: FONT_CONST.regular(
                            color: COLOR_CONST.cloudBurst, fontSize: 14),
                      )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
