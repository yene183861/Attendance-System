import 'package:easy_localization/easy_localization.dart';
import 'package:firefly/custom_widget/primary_button.dart';
import 'package:firefly/data/request_param/change_password_param.dart';
import 'package:firefly/screens/app_router.dart';
import 'package:firefly/screens/change_profile_group/change_password_screen/bloc/change_password_bloc.dart';
import 'package:firefly/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:formz/formz.dart';

import 'package:firefly/configs/resources/barrel_const.dart';
import 'package:firefly/custom_widget/appbar_default_custom.dart';
import 'package:firefly/custom_widget/custom_text_form_field.dart';
import 'package:firefly/custom_widget/default_padding.dart';
import 'package:firefly/custom_widget/loading_show_able.dart';
import 'package:firefly/custom_widget/popup_notification_custom.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: COLOR_CONST.backgroundColor,
      body: BlocProvider(
          create: (context) => ChangePasswordBloc(),
          child: const _ScreenForm()),
    );
  }
}

class _ScreenForm extends StatefulWidget {
  const _ScreenForm({Key? key}) : super(key: key);

  @override
  State<_ScreenForm> createState() => _ScreenFormState();
}

class _ScreenFormState extends State<_ScreenForm> {
  late TextEditingController oldPasswordCrtl,
      newPasswordCrtl,
      confirmPasswordCrtl;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    oldPasswordCrtl = TextEditingController();
    newPasswordCrtl = TextEditingController();
    confirmPasswordCrtl = TextEditingController();
  }

  @override
  void dispose() {
    oldPasswordCrtl.dispose();
    newPasswordCrtl.dispose();
    confirmPasswordCrtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChangePasswordBloc, ChangePasswordState>(
      listenWhen: (p, c) => p.status != c.status,
      listener: (context, state) {
        if (state.status.isSubmissionInProgress) {
          LoadingShowAble.showLoading();
        } else if (state.status.isSubmissionSuccess) {
          LoadingShowAble.hideLoading();
          if (state.message != null && state.message!.isNotEmpty) {
            PopupNotificationCustom.showMessgae(
              title: "Thông báo".tr(),
              message: state.message ?? "",
              hiddenButtonLeft: true,
              pressButtonRight: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    AppRouter.LOGIN_SCREEN, (route) => false);
              },
            );
          }
        } else if (state.status.isSubmissionFailure) {
          LoadingShowAble.hideLoading();
          PopupNotificationCustom.showMessgae(
            title: "title_error".tr(),
            message: state.message ?? "",
            hiddenButtonLeft: true,
          );
        } else {
          LoadingShowAble.hideLoading();
        }
      },
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppbarDefaultCustom(
              title: 'Thay đổi mật khẩu',
              isCallBack: true,
            ),
            Form(
              key: _formKey,
              child: Padding(
                padding: defaultPadding(horizontal: 20, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Mật khẩu hiện tại ',
                          style: FONT_CONST.medium(),
                        ),
                        Text(
                          '*',
                          style: FONT_CONST.medium(
                              color: COLOR_CONST.portlandOrange),
                        ),
                      ],
                    ),
                    const VerticalSpacing(of: 5),
                    PasswordTextField(
                      controller: oldPasswordCrtl,
                      hintText: 'Mật khẩu hiện tại',
                    ),
                    const VerticalSpacing(of: 15),
                    Row(
                      children: [
                        Text(
                          'Mật khẩu mới ',
                          style: FONT_CONST.medium(),
                        ),
                        Text(
                          '*',
                          style: FONT_CONST.medium(
                              color: COLOR_CONST.portlandOrange),
                        ),
                      ],
                    ),
                    const VerticalSpacing(of: 5),
                    PasswordTextField(
                      controller: newPasswordCrtl,
                      hintText: 'Mật khẩu mới',
                    ),
                    const VerticalSpacing(of: 15),
                    Row(
                      children: [
                        Text(
                          'Nhập lại mật khẩu ',
                          style: FONT_CONST.medium(),
                        ),
                        Text(
                          '*',
                          style: FONT_CONST.medium(
                              color: COLOR_CONST.portlandOrange),
                        ),
                      ],
                    ),
                    const VerticalSpacing(of: 5),
                    PasswordTextField(
                      controller: confirmPasswordCrtl,
                      hintText: 'Nhập lại mật khẩu mới',
                      validator: (p0) {
                        final passwd = p0?.trim();
                        if (passwd == null || passwd.isEmpty) {
                          return 'password_can_not_be_blank'.tr();
                        } else {
                          if (passwd.length < 8) {
                            return 'error_short_password'.tr();
                          }
                          if (passwd != newPasswordCrtl.text.trim()) {
                            return 'Mật khẩu không khớp'.tr();
                          }
                          return null;
                        }
                      },
                    ),
                    const VerticalSpacing(of: 25),
                    PrimaryButton(
                      title: 'Thay đổi',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final param = ChangePasswordParam(
                              oldPassword: oldPasswordCrtl.text.trim(),
                              newPassword: newPasswordCrtl.text.trim(),
                              confirmPassword: confirmPasswordCrtl.text.trim());
                          context.changePasswordBloc
                              .add(SubmitPasswordEvent(param: param));
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PasswordTextField extends StatefulWidget {
  const PasswordTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      this.validator});
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool obscureText = true;
  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      hintText: widget.hintText,
      controller: widget.controller,
      obscureText: obscureText,
      maxLines: 1,
      validator: widget.validator ??
          (p0) {
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
            obscureText = !obscureText;
          });
        },
        child: Container(
          alignment: Alignment.center,
          child: SvgPicture.asset(
            obscureText
                ? ICON_CONST.icEyeHidden.path
                : ICON_CONST.icEyeShow.path,
            width: 15,
            height: 15,
          ),
        ),
      ),
    );
  }
}
