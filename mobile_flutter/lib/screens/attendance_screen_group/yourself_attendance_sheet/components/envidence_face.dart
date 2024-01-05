import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firefly/data/model/face_attendance_model.dart';
import 'package:flutter/material.dart';
import 'package:firefly/configs/resources/barrel_const.dart';
import 'package:firefly/custom_widget/default_padding.dart';
import 'package:firefly/utils/size_config.dart';

class EnvidenceItem extends StatelessWidget {
  const EnvidenceItem({
    super.key,
    required this.model,
  });

  final FaceAttendanceModel model;

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
              height: getProportionateScreenHeight(100),
              width: getProportionateScreenHeight(100),
              child: CachedNetworkImage(
                imageUrl: model.image,
                placeholder: (context, url) => Container(
                  height: getProportionateScreenHeight(100),
                  width: getProportionateScreenHeight(100),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  height: getProportionateScreenHeight(100),
                  width: getProportionateScreenHeight(100),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "${'Thời gian chấm công'.tr()}: ",
                    style: FONT_CONST.medium(
                      color: COLOR_CONST.gray,
                      fontSize: 14,
                    ),
                  ),
                  const VerticalSpacing(of: 10),
                  Text(
                    model.createdAt,
                    style: FONT_CONST.medium(
                      color: COLOR_CONST.cloudBurst,
                      fontSize: 14,
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
          ],
        ),
      ),
    );
  }
}
