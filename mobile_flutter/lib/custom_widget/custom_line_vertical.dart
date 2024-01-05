import 'package:flutter/material.dart';

Widget lineVertical(
    {Color? color, double? height, double? width, EdgeInsetsGeometry? margin}) {
  return Container(
    margin: margin,
    height: height ?? 1,
    color: color ?? Colors.grey.shade300,
    width: width ?? double.maxFinite,
  );
}
