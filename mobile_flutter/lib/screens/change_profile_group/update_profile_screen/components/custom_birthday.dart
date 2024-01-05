import 'package:firefly/configs/resources/barrel_const.dart';
import 'package:firefly/utils/size_config.dart';
import 'package:flutter/material.dart';

class CustomBirthdayEditText extends StatelessWidget {
  const CustomBirthdayEditText({
    super.key,
    required this.title,
    this.width,
    this.height,
    this.boxDecoration,
    this.backgroundColor,
    required this.hint,
    this.errorText,
    this.inputType,
    this.textController,
    this.textInit = '',
    required this.isRequired,
    required this.press,
  });
  final String title;
  final double? width;
  final double? height;
  final BoxDecoration? boxDecoration;
  final Color? backgroundColor;
  final String hint;
  final errorText;
  final inputType;
  final textController;
  final String textInit;
  final bool isRequired;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      constraints: BoxConstraints(maxWidth: SizeConfig.screenWidthMax),
      decoration: boxDecoration ??
          BoxDecoration(
            color: backgroundColor ?? COLOR_CONST.backgroundColor,
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                title,
                style: FONT_CONST.regular(
                    fontSize: 16, color: COLOR_CONST.cloudBurst),
              ),
              if (isRequired == true)
                Text(
                  ' (*)',
                  style: FONT_CONST.regular(
                      fontSize: 16, color: COLOR_CONST.portlandOrange),
                ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 5),
            decoration: boxDecoration ??
                const BoxDecoration(
                  color: COLOR_CONST.cloudBurst,
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
            child: Container(
                margin: const EdgeInsets.all(1),
                decoration: boxDecoration ??
                    BoxDecoration(
                      color: backgroundColor ?? COLOR_CONST.backgroundColor,
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                    ),
                child: GestureDetector(
                  onTap: press,
                  child: TextField(
                    controller: textController,
                    enableInteractiveSelection: false,
                    enabled: false,
                    autofocus: false,
                    style: FONT_CONST.regular(),
                    keyboardType: inputType ?? TextInputType.text,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      hintText: hint,
                      hintStyle: FONT_CONST.light(color: COLOR_CONST.lynch),
                      counterText: '',
                      contentPadding: const EdgeInsets.fromLTRB(15, 0, 10, 0),
                      border: errorText != null
                          ? outlineInputBorderError
                          : outlineInputBorder,
                      enabledBorder: errorText != null
                          ? outlineInputBorderError
                          : outlineInputBorder,
                      focusedBorder: errorText != null
                          ? outlineInputBorderError
                          : outlineInputBorder,
                    ),
                  ),
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5, left: 15),
            child: Row(
              children: [
                Text(
                  errorText ?? " ",
                  style: FONT_CONST.regular(
                      color: COLOR_CONST.carnation, fontSize: 12),
                  maxLines: 3,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

var outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(color: COLOR_CONST.cloudBurst));

var outlineInputBorderError = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(color: COLOR_CONST.carnation));
