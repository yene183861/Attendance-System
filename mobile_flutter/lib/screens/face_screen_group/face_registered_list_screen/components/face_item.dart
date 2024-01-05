import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:firefly/configs/resources/barrel_const.dart';
import 'package:firefly/custom_widget/default_padding.dart';
import 'package:firefly/data/model/face_model.dart';
import 'package:firefly/data/model/user_work_model.dart';
import 'package:firefly/utils/size_config.dart';

class FaceItem extends StatelessWidget {
  const FaceItem({
    super.key,
    required this.model,
  });

  final FaceModel model;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Ink(
        padding: defaultPadding(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade200),
            borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            SizedBox(
              height: getProportionateScreenHeight(70),
              width: getProportionateScreenHeight(70),
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: model.user.fullname),
                        (model.user.username != null &&
                                model.user.username!.isNotEmpty)
                            ? TextSpan(text: '( ${model.user.username} )')
                            : TextSpan(text: ''),
                      ],
                      style: FONT_CONST.extraBold(
                        color: COLOR_CONST.cloudBurst,
                        fontSize: 16,
                      ),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "${'Email liên hệ'.tr()}: ",
                          style: FONT_CONST.medium(
                            color: COLOR_CONST.gray,
                            fontSize: 14,
                          ),
                        ),
                        TextSpan(
                          text: model.user.email,
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
                          text: "${'Thời gian đăng ký'.tr()}: ",
                          style: FONT_CONST.medium(
                            color: COLOR_CONST.gray,
                            fontSize: 14,
                          ),
                        ),
                        TextSpan(
                          text: model.createdAt,
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
                  // Text.rich(
                  //   TextSpan(
                  //     children: [
                  //       TextSpan(
                  //         text: "${'Vị trí'.tr()}: ",
                  //         style: FONT_CONST.medium(
                  //           color: COLOR_CONST.cloudBurst,
                  //           fontSize: 14,
                  //         ),
                  //       ),
                  //       TextSpan(
                  //         text: position,
                  //         style: FONT_CONST.medium(
                  //           color: COLOR_CONST.cloudBurst,
                  //           fontSize: 14,
                  //         ),
                  //       ),
                  //     ],
                  //     style: FONT_CONST.regular(
                  //       color: COLOR_CONST.cloudBurst,
                  //       fontSize: 14,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
            SizedBox(
              height: getProportionateScreenHeight(100),
              width: getProportionateScreenHeight(100),
              child: CachedNetworkImage(
                imageUrl: model.image,
                placeholder: (context, url) => Container(
                  height: getProportionateScreenHeight(100),
                  width: getProportionateScreenHeight(100),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        IMAGE_CONST.imgDefaultAvatar.path,
                      ),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  height: getProportionateScreenHeight(100),
                  width: getProportionateScreenHeight(100),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        IMAGE_CONST.imgDefaultAvatar.path,
                      ),
                    ),
                  ),
                ),
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
