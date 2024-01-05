import 'package:flutter/material.dart';

import '../utils/size_config.dart';

EdgeInsets defaultPadding({double? horizontal, double? vertical}) {
  return EdgeInsets.symmetric(
      horizontal: getProportionateScreenWidth(horizontal ?? 25),
      vertical: getProportionateScreenHeight(vertical ?? 15));
}
