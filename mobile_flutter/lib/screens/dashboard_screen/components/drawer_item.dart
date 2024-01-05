import 'package:flutter/material.dart';
import 'package:firefly/configs/resources/barrel_const.dart';
import 'package:firefly/custom_widget/default_padding.dart';
import 'package:firefly/utils/size_config.dart';

class DrawerItem extends StatelessWidget {
  const DrawerItem({
    super.key,
    required GlobalKey<ScaffoldState> scaffoldKey,
    required this.title,
    this.isSelected = false,
    this.onTap,
    required this.icon,
  }) : _scaffoldKey = scaffoldKey;
  final String title;
  final bool isSelected;
  final Function? onTap;
  final Widget icon;

  final GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _scaffoldKey.currentState!.closeDrawer();
        if (onTap != null) onTap!();
      },
      child: Ink(
        padding: defaultPadding(horizontal: 25, vertical: 20),
        color: isSelected ? COLOR_CONST.alto : null,
        child: Row(
          children: [
            icon,
            const HorizontalSpacing(of: 10),
            Text(
              title,
              style: FONT_CONST.regular(),
            ),
          ],
        ),
      ),
    );
  }
}
