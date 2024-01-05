import 'package:firefly/configs/resources/barrel_const.dart';
import 'package:firefly/utils/size_config.dart';
import 'package:flutter/material.dart';

// MARK: Appbar default Back button
class AppbarDefaultCustom extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final Widget? actions;
  final bool isCallBack;
  final VoidCallback? callbackEvent;
  final Color? backgroundColor;
  final TextStyle? textStyleTitle;
  final Widget? leading;

  const AppbarDefaultCustom({
    Key? key,
    required this.title,
    this.isCallBack = false,
    this.callbackEvent,
    this.actions,
    this.backgroundColor,
    this.textStyleTitle,
    this.leading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: Text(
          title,
          textAlign: TextAlign.center,
          style: textStyleTitle ?? FONT_CONST.medium(fontSize: 22),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: backgroundColor ?? COLOR_CONST.white,
        automaticallyImplyLeading: false,
        leading: leading ??
            (isCallBack
                ? GestureDetector(
                    onTap: callbackEvent ?? () => Navigator.of(context).pop(),
                    child: Container(
                      color: Colors.transparent,
                      child: const Icon(
                        Icons.arrow_back,
                        color: COLOR_CONST.cloudBurst,
                      ),
                    ),
                  )
                : null),
        actions: [
          actions ?? Container(),

          //padding right
          SizedBox(
            width: appDefaultPadding,
          )
        ]);
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
