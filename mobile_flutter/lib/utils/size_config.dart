import 'package:flutter/material.dart';

// SizeConfig help us to make our UI responsive
/// Make sure you need to call [SizeConfig.init(context)]
/// on your starting screen
class SizeConfig {
  static MediaQueryData? _mediaQueryData;
  static double screenWidth = 0;
  static double screenHeight = 0;
  static Size? appBarSize;
  static double paddingTop = 0; // Height safe area top
  static double paddingBottom = 0; // Height safe area top

  static double? bottomNavigationBarHeight;
  static double buttonHeightDefault = 50;
  static double textFieldHeightDefault = 80;

  static double screenWidthMax = 400;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData!.size.width;
    screenHeight = _mediaQueryData!.size.height;
    paddingTop = _mediaQueryData!.padding.top;
    paddingBottom = _mediaQueryData!.padding.bottom;
    appBarSize = const Size.fromHeight(kToolbarHeight);
    bottomNavigationBarHeight = kBottomNavigationBarHeight;
  }
}

final appDefaultPadding = getProportionateScreenWidth(16);
const appDefaultRadius = BorderRadius.all(Radius.circular(10));
final appDefaultIconHeight = SizeConfig.appBarSize!.height - 16;

// Get the proportionate height as per screen size
double getProportionateScreenHeight(double inputHeight) {
  final screenHeight = SizeConfig.screenHeight;
  // Our designer use iPhone 11, that's why we use 896.0
  return (inputHeight / 896.0) * screenHeight;
}

// Get the proportionate height as per screen size
double getProportionateScreenWidth(double inputWidth) {
  final screenWidth = SizeConfig.screenWidth;
  // 414 is the layout width that designer use or you can say iPhone 11  width
  return (inputWidth / 414.0) * screenWidth;
}

// For add free space vertically
class VerticalSpacing extends StatelessWidget {
  const VerticalSpacing({
    Key? key,
    this.of = 20,
  }) : super(key: key);

  final double of;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: getProportionateScreenWidth(of),
      width: double.infinity,
    );
  }
}

// For add free space horizontally
class HorizontalSpacing extends StatelessWidget {
  const HorizontalSpacing({
    Key? key,
    this.of = 20,
  }) : super(key: key);

  final double of;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: getProportionateScreenWidth(of),
    );
  }
}
