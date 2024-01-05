import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:firefly/configs/resources/barrel_const.dart';
import 'package:firefly/data/enum_type/user_type.dart';
import 'package:firefly/data/model/user_model.dart';
import 'package:firefly/utils/size_config.dart';

class CustomDrawerHeader extends StatelessWidget {
  const CustomDrawerHeader({
    super.key,
    this.profile,
  });
  final UserModel? profile;

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      margin: EdgeInsets.zero,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: getProportionateScreenHeight(70),
              width: getProportionateScreenHeight(70),
              child: CachedNetworkImage(
                imageUrl: profile?.avatarThumb ?? '',
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
            const VerticalSpacing(of: 5),
            Text(
              profile?.fullname ?? '',
              style: FONT_CONST.bold(),
            ),
            Text(
              profile?.email ?? '',
              style: FONT_CONST.bold(),
            ),
            Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: 'title_position'.tr()),
                    TextSpan(text: 'msg_format_easy_read'.tr()),
                    TextSpan(text: profile?.userType.value ?? ''),
                  ],
                ),
                style: FONT_CONST.regular()),
          ],
        ),
      ),
    );
  }
}
