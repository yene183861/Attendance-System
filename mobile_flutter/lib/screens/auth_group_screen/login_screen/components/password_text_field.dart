import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:firefly/configs/resources/barrel_const.dart';
import 'package:firefly/custom_widget/custom_text_form_field.dart';

class PasswordTextField extends StatefulWidget {
  const PasswordTextField({super.key, required this.controller});
  final TextEditingController controller;

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool isShowPassword = false;
  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      hintText: 'password'.tr(),
      controller: widget.controller,
      obscureText: !isShowPassword,
      maxLines: 1,
      validator: (p0) {
        final passwd = p0?.trim();
        if (passwd == null || passwd.isEmpty) {
          return 'password_can_not_be_blank'.tr();
        } else {
          if (passwd.length < 8) {
            return 'error_short_password'.tr();
          }
          return null;
        }
      },
      suffixIcon: GestureDetector(
        onTap: () {
          setState(() {
            isShowPassword = !isShowPassword;
          });
        },
        child: Container(
          alignment: Alignment.center,
          // width: 0,
          child: SvgPicture.asset(
            !isShowPassword
                ? ICON_CONST.icEyeHidden.path
                : ICON_CONST.icEyeShow.path,
            width: 15,
          ),
        ),
      ),
    );
  }
}
