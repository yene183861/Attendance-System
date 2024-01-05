import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'barrel_const.dart';

class FONT_CONST {
  // Light
  static TextStyle light({
    Color? color,
    double? fontSize,
    FontStyle? fontStyle,
    double? letterSpacing,
    double? height,
    FontWeight? fontWeight,
    TextDecoration? textDecoration,
  }) {
    return TextStyle(
      fontWeight: fontWeight ?? FontWeight.w300,
      fontFamily: 'SfProRegular',
      color: color ?? COLOR_CONST.cloudBurst,
      fontSize: fontSize ?? 16,
      fontStyle: fontStyle ?? FontStyle.normal,
      letterSpacing: letterSpacing,
      height: height,
      decoration: textDecoration ?? TextDecoration.none,
    );
  }

  //  Regular
  static TextStyle regular({
    Color? color,
    double? fontSize,
    FontStyle? fontStyle,
    double? letterSpacing,
    double? height,
    TextDecoration? textDecoration,
  }) {
    return TextStyle(
      fontFamily: 'SfProRegular',
      color: color ?? COLOR_CONST.cloudBurst,
      fontSize: fontSize ?? 16,
      fontStyle: fontStyle ?? FontStyle.normal,
      letterSpacing: letterSpacing,
      height: height ?? 1.1,
      decoration: textDecoration ?? TextDecoration.none,
    );
  }

  // Medium
  static TextStyle medium({
    Color? color,
    double? fontSize,
    FontStyle? fontStyle,
    double? letterSpacing,
    double? height,
    TextDecoration? textDecoration,
  }) {
    return TextStyle(
      fontWeight: FontWeight.w500,
      fontFamily: 'SfProMedium',
      color: color ?? COLOR_CONST.cloudBurst,
      fontSize: fontSize ?? 16,
      fontStyle: fontStyle ?? FontStyle.normal,
      letterSpacing: letterSpacing,
      height: height,
      decoration: textDecoration ?? TextDecoration.none,
    );
  }

  // Semo Bold
  static TextStyle semoBold({
    Color? color,
    double? fontSize,
    FontStyle? fontStyle,
    double? letterSpacing,
    double? height,
    TextDecoration? textDecoration,
  }) {
    return TextStyle(
      fontFamily: 'SfProBold',
      fontWeight: FontWeight.w600,
      color: color ?? COLOR_CONST.cloudBurst,
      fontSize: fontSize ?? 16,
      fontStyle: fontStyle ?? FontStyle.normal,
      letterSpacing: letterSpacing,
      height: height,
      decoration: textDecoration ?? TextDecoration.none,
    );
  }

  //  Bold
  static TextStyle bold({
    Color? color,
    double? fontSize,
    FontStyle? fontStyle,
    double? letterSpacing,
    double? height,
    TextDecoration? textDecoration,
    FontWeight? fontWeight,
    String? fontFamily,
  }) {
    return TextStyle(
      fontFamily: fontFamily ?? 'SfProBold',
      fontWeight: fontWeight ?? FontWeight.w700,
      color: color ?? COLOR_CONST.cloudBurst,
      fontSize: fontSize ?? 16,
      fontStyle: fontStyle ?? FontStyle.normal,
      letterSpacing: letterSpacing,
      height: height,
      decoration: textDecoration ?? TextDecoration.none,
    );
  }

//  Bold
  static TextStyle extraBold({
    Color? color,
    double? fontSize,
    FontStyle? fontStyle,
    double? letterSpacing,
    double? height,
    TextDecoration? textDecoration,
    FontWeight? fontWeight,
  }) {
    return TextStyle(
      fontFamily: 'SfProBold',
      fontWeight: fontWeight ?? FontWeight.w700,
      color: color ?? COLOR_CONST.cloudBurst,
      fontSize: fontSize ?? 16,
      fontStyle: fontStyle ?? FontStyle.normal,
      letterSpacing: letterSpacing,
      height: height ?? 1.1,
      decoration: textDecoration ?? TextDecoration.none,
    );
  }
}
