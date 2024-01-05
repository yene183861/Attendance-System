import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firefly/configs/resources/barrel_const.dart';
import 'package:firefly/utils/size_config.dart';

class ItemData {
  final int index;
  final String title;
  final dynamic object;

  ItemData({
    required this.index,
    required this.title,
    required this.object,
  });
}

class CustomDropdownMenuFunction extends StatefulWidget {
  CustomDropdownMenuFunction({
    super.key,
    required this.title,
    required this.titleButton,
    required this.datas,
    required this.itemInit,
    this.boxDecoration,
    this.backgroundColor,
    this.errorText,
    this.isRequired,
    this.colorBorder = COLOR_CONST.cloudBurst,
    this.colorBorderFocused = COLOR_CONST.cloudBurst,
    this.maxHeight,
    this.isFullwidthDropBox = false,
    this.isExpanded = true,
    this.iconDropDown,
    this.marginTop = 15,
    required this.onClickIcon,
    required this.onSelectionItem,
    required this.onTapButtonBottom,
    this.directionDropBox,
    required this.bottomWidget,
  });

  final String title;
  final String titleButton;
  final List<ItemData> datas;
  // ignore: avoid_annotating_with_dynamic
  ItemData itemInit;
  final BoxDecoration? boxDecoration;
  final Color? backgroundColor;
  final String? errorText;
  final bool? isRequired;
  final Color colorBorder;
  final Color colorBorderFocused;
  final double? maxHeight;
  final bool isFullwidthDropBox;
  final bool isExpanded;
  final Widget? iconDropDown;
  final double marginTop;
  final Function(ItemData) onSelectionItem;
  final Function(ItemData) onClickIcon;
  final Function onTapButtonBottom;
  final DropdownDirection? directionDropBox;
  final Widget bottomWidget;

  @override
  State<CustomDropdownMenuFunction> createState() =>
      _CustomDropdownMenuFunctionState();
}

class _CustomDropdownMenuFunctionState
    extends State<CustomDropdownMenuFunction> {
  ScrollController scrollController = ScrollController();
  double heightItemMenu = 50;
  bool isOpenMenu = false;
  var widthDropBox = null;

  @override
  void initState() {
    super.initState();
  }

  // ignore: avoid_positional_boolean_parameters
  Future<void> handleScrollToItem() async {
    for (var i = 0; i < widget.datas.length; i++) {
      if (widget.itemInit.index == widget.datas[i].index) {
        scrollController =
            ScrollController(initialScrollOffset: i * heightItemMenu);
        break;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: widget.marginTop),
      constraints: BoxConstraints(maxWidth: SizeConfig.screenWidthMax),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                widget.title,
                style: FONT_CONST.regular(
                    fontSize: 16, color: COLOR_CONST.cloudBurst),
              ),
              if (widget.isRequired == true)
                Text(
                  ' (*)',
                  style: FONT_CONST.regular(
                      fontSize: 16, color: COLOR_CONST.portlandOrange),
                ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 5),
            color: COLOR_CONST.white,
            constraints: BoxConstraints(
                maxHeight: 50, maxWidth: SizeConfig.screenWidthMax),
            child: DropdownButtonFormField2<dynamic>(
              customButton: itemSelectedWidget(widget.itemInit.title),
              barrierColor: COLOR_CONST.black.withOpacity(0.5),
              onMenuStateChange: (isOpen) async {
                await handleScrollToItem();
                setState(() {
                  isOpenMenu = isOpen;
                });
              },
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.zero,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: widget.errorText?.isNotEmpty ?? false
                          ? COLOR_CONST.carnation
                          : widget.colorBorder),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: widget.errorText?.isNotEmpty ?? false
                          ? COLOR_CONST.carnation
                          : widget.colorBorderFocused),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              isExpanded: widget.isExpanded,
              items: [
                DropdownMenuItem<Container>(
                  enabled: false,
                  child: Container(
                    // width: 100,
                    color: COLOR_CONST.white,
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: widget.datas.length,
                      itemBuilder: (context, index) {
                        return itemMenuWidget(
                          titleItem: widget.datas[index].title,
                          itemData: widget.datas[index],
                          index: index,
                          onClickIcon: () {
                            Navigator.of(context).pop();
                            setState(() {
                              widget.itemInit = widget.datas[index];
                            });
                            widget.onClickIcon(widget.datas[index]);
                          },
                          onSelectionItem: () {
                            Navigator.of(context).pop();
                            setState(() {
                              widget.itemInit = widget.datas[index];
                            });
                            widget.onSelectionItem(widget.datas[index]);
                          },
                        );
                      },
                    ),
                  ),
                ),
                DropdownMenuItem<Widget>(
                  alignment: Alignment.bottomCenter,
                  enabled: false,
                  child: widget.bottomWidget,
                ),
              ],
              onChanged: (value) {},
              // value: selectedDefault,
              buttonStyleData: const ButtonStyleData(
                height: 55,
                // padding: EdgeInsets.only(left: 20, right: 10),
              ),
              iconStyleData: IconStyleData(
                icon: widget.iconDropDown ??
                    const Icon(
                      Icons.arrow_drop_down,
                      color: COLOR_CONST.cloudBurst,
                    ),
                iconSize: 32,
              ),
              dropdownStyleData: DropdownStyleData(
                direction:
                    widget.directionDropBox ?? DropdownDirection.textDirection,
                width: !widget.isFullwidthDropBox
                    ? null
                    : (SizeConfig.screenWidth > SizeConfig.screenWidthMax
                        ? SizeConfig.screenWidthMax
                        : SizeConfig.screenWidth -
                            getProportionateScreenWidth(40)),
                padding: const EdgeInsets.all(0),
                offset: const Offset(0, -5),
                maxHeight: widget.maxHeight ?? 300,
                // scrollPadding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),

              // ignore: prefer_const_constructors
              menuItemStyleData: MenuItemStyleData(
                  padding: const EdgeInsets.all(0),
                  customHeights: [if (widget.datas.isNotEmpty) 140 else 0, 50]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5, left: 15),
            child: Row(
              children: [
                Text(
                  widget.errorText ?? " ",
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

  // Widget buttonBottomWidget() {
  //   return GestureDetector(
  //     onTap: () {
  //       widget.onTapButtonBottom();
  //     },
  //     child: Container(
  //       // padding: EdgeInsets.symmetric(
  //       //   vertical: 10
  //       // ),
  //       height: double.maxFinite,
  //       decoration: const BoxDecoration(
  //           color: COLOR_CONST.white,
  //           border: Border(
  //               top: BorderSide(width: 0.5, color: COLOR_CONST.cloudBurst))),
  //       child: widget.bottomWidget,
  //     ),
  //   );
  // }

  Widget itemMenuWidget({
    String? titleItem,
    required ItemData itemData,
    required Function() onSelectionItem,
    required Function() onClickIcon,
    required int index,
    bool isSelected = false,
  }) {
    return GestureDetector(
      onTap: () {
        onSelectionItem();
      },
      child: Container(
        padding: const EdgeInsets.only(left: 12),
        height: heightItemMenu,
        decoration: BoxDecoration(
            color: widget.itemInit.index == itemData.index
                ? COLOR_CONST.cloudBurst.withOpacity(0.07)
                : COLOR_CONST.white,
            border: Border(
                bottom: (index + 1) < widget.datas.length
                    ? const BorderSide(
                        width: 0.5, color: COLOR_CONST.cloudBurst)
                    : BorderSide.none)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                titleItem ?? "",
                style: FONT_CONST.regular(
                  color: COLOR_CONST.cloudBurst,
                  fontSize: 15,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isSelected)
              Container(
                padding: const EdgeInsets.all(12),
                // color: COLOR_CONST.alto,
                child: SvgPicture.asset(
                  ICON_CONST.icCheckAccept.path,
                  width: 20,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget itemSelectedWidget(String? titleItem) {
    return Container(
      height: heightItemMenu,
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              titleItem ?? "",
              style: FONT_CONST.regular(
                color: COLOR_CONST.cloudBurst,
                fontSize: 15,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // ignore: prefer_const_constructors
          SizedBox(
            height: 5,
          ),
          SvgPicture.asset(
            ICON_CONST.icArrowOpen.path,
            height: 10,
            color: COLOR_CONST.cloudBurst,
          ),
        ],
      ),
    );
  }
}
