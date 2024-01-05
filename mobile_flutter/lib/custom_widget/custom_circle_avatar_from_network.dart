import 'package:cached_network_image/cached_network_image.dart';
import 'package:firefly/configs/resources/image_const.dart';
import 'package:firefly/utils/size_config.dart';
import 'package:flutter/material.dart';

class CustomCircleAvatarFromNetwork extends StatelessWidget {
  const CustomCircleAvatarFromNetwork(
      {super.key, this.size, required this.urlImage});
  final double? size;
  final String urlImage;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: getProportionateScreenHeight(size ?? 70),
      width: getProportionateScreenHeight(size ?? 70),
      child: CachedNetworkImage(
        imageUrl: urlImage,
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
    );
  }
}
