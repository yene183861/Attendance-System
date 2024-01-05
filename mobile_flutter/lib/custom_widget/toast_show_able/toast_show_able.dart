import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:firefly/configs/resources/barrel_const.dart';
import 'package:firefly/utils/size_config.dart';
import 'toast_message_type.dart';

mixin ToastShowAble {
  static const List<DismissDirection> _dismissDirections = [
    DismissDirection.up
  ];
  // static const bool _enableSlideOff = true;

  static void show({
    required ToastMessageType toastType,
    required String message,
  }) {
    BotToast.showAnimationWidget(
        clickClose: false,
        allowClick: true,
        onlyOne: true,
        crossPage: true,
        duration: const Duration(seconds: 2),
        backButtonBehavior: BackButtonBehavior.close,
        wrapAnimation: (controller, cancel, child) {
          return _ShowToastAnimation(controller: controller, child: child);
        },
        groupKey: '_notificationKey',
        toastBuilder: (cancelFunc) {
          return DismissToast(
            dismissDirections: _dismissDirections,
            slideOffFunc: cancelFunc,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15)),
                color: toastType.color,
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 2),
                    blurRadius: 1,
                    color: Colors.black.withOpacity(0.1),
                  )
                ],
              ),
              constraints: BoxConstraints(
                  minHeight: 1.2 * SizeConfig.appBarSize!.height +
                      SizeConfig.paddingTop),
              padding: EdgeInsets.only(
                top: SizeConfig.paddingTop + getProportionateScreenHeight(8),
                left: getProportionateScreenWidth(20),
                right: getProportionateScreenWidth(20),
                bottom: getProportionateScreenHeight(8),
              ),
              width: SizeConfig.screenWidth,
              child: Row(
                children: [
                  // toastType?.icon ?? Container(),
                  SvgPicture.asset(toastType.icon,
                      width: 24, color: toastType.textColor),
                  const HorizontalSpacing(
                    of: 12,
                  ),
                  Expanded(
                    child: Text(
                      message,
                      style: FONT_CONST.semoBold(color: toastType.textColor),
                    ),
                  ),
                ],
              ),
            ),
          );

          // return ;
        },
        animationDuration: const Duration(milliseconds: 300));
  }
}

// Animation show toast
class _ShowToastAnimation extends StatefulWidget {
  final Widget child;
  final AnimationController controller;

  const _ShowToastAnimation(
      {Key? key, required this.child, required this.controller})
      : super(key: key);

  @override
  _ShowToastAnimationState createState() => _ShowToastAnimationState();
}

class _ShowToastAnimationState extends State<_ShowToastAnimation>
    with SingleTickerProviderStateMixin {
  static final Tween<Offset> tweenOffset = Tween<Offset>(
    begin: const Offset(0, -100),
    end: const Offset(0, 0),
  );
  Animation<double>? animation;
  Animation<Offset>? animationOffset;

  @override
  void initState() {
    animation =
        CurvedAnimation(parent: widget.controller, curve: Curves.decelerate);
    animationOffset = tweenOffset.animate(animation!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (_, child) {
        return Transform.translate(
          offset: animationOffset!.value,
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

//通知Toast的Widget
class DismissToast extends StatefulWidget {
  final Widget child;

  final Function slideOffFunc;

  final List<DismissDirection>? dismissDirections;

  const DismissToast(
      {Key? key,
      required this.child,
      required this.slideOffFunc,
      this.dismissDirections})
      : super(key: key);

  @override
  _DismissToastState createState() => _DismissToastState();
}

class _DismissToastState extends State<DismissToast> {
  Future<bool> confirmDismiss(DismissDirection direction) async {
    widget.slideOffFunc();
    return true;
  }

  Key key = UniqueKey();

  @override
  Widget build(BuildContext context) {
    var child = widget.child;
    if (widget.dismissDirections != null &&
        widget.dismissDirections!.isNotEmpty) {
      for (final direction in widget.dismissDirections!) {
        child = Dismissible(
          direction: direction,
          key: key,
          confirmDismiss: confirmDismiss,
          child: child,
        );
      }
    }
    return child;
  }
}
