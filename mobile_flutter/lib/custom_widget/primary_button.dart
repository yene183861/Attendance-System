import 'package:flutter/material.dart';
import 'package:firefly/configs/resources/color_const.dart';
import 'package:firefly/configs/resources/font_const.dart';

import '../utils/size_config.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    Key? key,
    this.title,
    this.width,
    this.height,
    this.onPressed,
    this.borderRadius,
    this.fontSize,
    this.backgroundColor,
    this.boxDecoration,
    this.textStyle,
  }) : super(key: key);

  final String? title;
  final double? width;
  final double? height;
  final VoidCallback? onPressed;
  final BorderRadius? borderRadius;
  final double? fontSize;
  final Color? backgroundColor;
  final BoxDecoration? boxDecoration;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? SizeConfig.screenWidth,
      height: height ?? SizeConfig.buttonHeightDefault,
      decoration: boxDecoration ??
          BoxDecoration(
            color: backgroundColor ?? COLOR_CONST.cloudBurst,
            borderRadius: const BorderRadius.all(
              Radius.circular(12),
            ),
          ),
      child: MaterialButton(
        onPressed: onPressed,
        elevation: 0,
        padding: EdgeInsets.zero,
        highlightColor: Colors.transparent,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? appDefaultRadius,
        ),
        child: Text(title ?? '',
            style: textStyle ??
                FONT_CONST.semoBold(
                  color: COLOR_CONST.backgroundColor,
                  fontSize: fontSize ?? 16,
                ),
            textAlign: TextAlign.center),
      ),
    );
  }
}

class PrimaryBorderButton extends StatelessWidget {
  const PrimaryBorderButton({
    Key? key,
    required this.title,
    this.width,
    this.height,
    this.onPressed,
    this.borderRadius,
    this.colorRadius,
    this.fontSize,
    this.backgroundColor,
    this.boxDecoration,
    this.textStyle,
    this.colorsGradientText,
  }) : super(key: key);

  final String? title;
  final double? width;
  final double? height;
  final VoidCallback? onPressed;
  final BorderRadius? borderRadius;
  final double? fontSize;
  final Color? backgroundColor;
  final Color? colorRadius;
  final BoxDecoration? boxDecoration;
  final TextStyle? textStyle;
  final List<Color>? colorsGradientText;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: boxDecoration ??
          const BoxDecoration(
            color: COLOR_CONST.cloudBurst,
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
          ),
      child: Container(
        width: width ?? SizeConfig.screenWidth,
        margin: const EdgeInsets.all(1),
        height: height ?? SizeConfig.buttonHeightDefault,
        decoration: boxDecoration ??
            BoxDecoration(
              color: backgroundColor ?? COLOR_CONST.backgroundColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(8),
              ),
            ),
        child: MaterialButton(
          onPressed: onPressed,
          elevation: 0,
          padding: EdgeInsets.zero,
          highlightColor: Colors.transparent,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(
            borderRadius:
                borderRadius ?? const BorderRadius.all(Radius.circular(20)),
          ),
          child: Text(
            title ?? '',
            style: textStyle ??
                FONT_CONST.semoBold(
                  color: COLOR_CONST.cloudBurst,
                  fontSize: fontSize ?? 16,
                ),
          ),
        ),
      ),
    );
  }
}
