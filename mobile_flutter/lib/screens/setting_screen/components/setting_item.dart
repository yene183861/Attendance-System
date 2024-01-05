import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../configs/resources/barrel_const.dart';
import '../../../utils/size_config.dart';

class SettingItem extends StatelessWidget {
  const SettingItem(
      {Key? key,
      this.heightIcon,
      this.widthIcon,
      this.isArrowNext = true,
      this.isSwitch = false,
      this.iconPath = '',
      this.title = '',
      this.onTap})
      : super(key: key);
  final double? heightIcon;
  final double? widthIcon;
  final bool isArrowNext;
  final bool isSwitch;
  final String iconPath;
  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 43,
              height: 43,
              decoration: BoxDecoration(
                color: COLOR_CONST.cloudBurst.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  iconPath,
                  height: heightIcon,
                  width: widthIcon,
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: appDefaultPadding),
                child: Text(
                  title,
                  textAlign: TextAlign.start,
                  style: FONT_CONST.medium(
                    fontSize: 14,
                    color: COLOR_CONST.cloudBurst,
                  ),
                ),
              ),
            ),
            if (isArrowNext)
              isSwitch
                  ? Container()
                  // BlocBuilder<SettingBloc, SettingState>(
                  //     buildWhen: (previous, current) =>
                  //         previous.subscribedNotification !=
                  //         current.subscribedNotification,
                  //     builder: (context, state) {
                  //       return FlutterSwitch(
                  //         width: 50,
                  //         height: 30,
                  //         toggleSize: 27,
                  //         padding: 1,
                  //         value: state.subscribedNotification ?? true,
                  //         activeColor: COLOR_CONST.cloudBurst,
                  //         onToggle: (value) {
                  //           context.read<SettingBloc>().add(
                  //                 ChangeNotificationStatusEvent(
                  //                     statusNotification: value,
                  //                     isSwitch: true),
                  //               );
                  //         },
                  //       );
                  //     },
                  //   )
                  : Container(
                      margin: EdgeInsets.only(left: appDefaultPadding, top: 5),
                      child: SvgPicture.asset(
                        ICON_CONST.icArrowNext.path,
                        height: 15,
                        width: 8,
                      ),
                    )
            else
              Container(),
          ],
        ),
      ),
    );
  }
}
