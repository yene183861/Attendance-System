// import 'package:firefly/data/model/organization_model.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:firefly/configs/resources/barrel_const.dart';
import 'package:firefly/utils/size_config.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomDropdownButton extends StatelessWidget {
  const CustomDropdownButton({
    this.title,
    required this.datas,
    required this.selectedDefault,
    required this.onSelectionChanged,
    this.boxDecoration,
    this.backgroundColor,
    this.errorText,
    this.isRequired,
    this.colorBorder = COLOR_CONST.cloudBurst,
    this.colorBorderFocused = COLOR_CONST.cloudBurst,
    this.maxHeight,
    this.isExpanded = true,
    this.iconDropDown,
    this.marginTop = 15,
    this.maxWidthButton = double.infinity,
  });

  final String? title;
  final List<DropdownMenuItem<dynamic>> datas;
  final dynamic selectedDefault;
  // ignore: avoid_annotating_with_dynamic
  final Function(dynamic) onSelectionChanged;
  final BoxDecoration? boxDecoration;
  final Color? backgroundColor;
  final String? errorText;
  final bool? isRequired;
  final Color colorBorder;
  final Color colorBorderFocused;
  final double? maxHeight;
  final double? maxWidthButton;
  final bool isExpanded;
  final Widget? iconDropDown;
  final double marginTop;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: marginTop),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Row(
              children: [
                Text(
                  title!,
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
            constraints:
                BoxConstraints(maxHeight: 50, maxWidth: maxWidthButton ?? 200),
            child: DropdownButtonFormField2<dynamic>(
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.zero,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: errorText?.isNotEmpty ?? false
                          ? COLOR_CONST.carnation
                          : colorBorder),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: errorText?.isNotEmpty ?? false
                          ? COLOR_CONST.carnation
                          : colorBorderFocused),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              isExpanded: isExpanded,
              items: datas,
              onChanged: onSelectionChanged,
              value: selectedDefault,
              buttonStyleData: ButtonStyleData(
                height: getProportionateScreenWidth(55),
                // padding: EdgeInsets.only(left: 20, right: 10),
              ),
              iconStyleData: IconStyleData(
                icon: iconDropDown ??
                    const Icon(
                      Icons.arrow_drop_down,
                      color: COLOR_CONST.cloudBurst,
                    ),
                iconSize: getProportionateScreenWidth(32),
              ),
              dropdownStyleData: DropdownStyleData(
                maxHeight: maxHeight ?? getProportionateScreenWidth(150),
                scrollPadding: EdgeInsets.symmetric(
                    vertical: getProportionateScreenWidth(10)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              menuItemStyleData: MenuItemStyleData(
                selectedMenuItemBuilder: (context, child) {
                  return Container(
                    // color: COLOR_CONST.cloudBurst.withOpacity(0.1),
                    height: getProportionateScreenWidth(55),
                    padding:
                        EdgeInsets.only(right: getProportionateScreenWidth(15)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: child),
                        SvgPicture.asset(
                          ICON_CONST.icCheckAccept.path,
                          color: COLOR_CONST.cloudBurst,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
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

Widget itemWidget(String titleItem) {
  return Text(
    titleItem,
    style: FONT_CONST.regular(
      color: COLOR_CONST.cloudBurst,
      fontSize: 15,
    ),
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
  );
}
