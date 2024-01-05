import 'package:firefly/custom_widget/loading_show_able.dart';
import 'package:firefly/custom_widget/popup_notification_custom.dart';
import 'package:firefly/custom_widget/toast_show_able/barrel_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../../../configs/resources/barrel_const.dart';
import '../../../custom_widget/custom_text_form_field.dart';
import '../../../custom_widget/header_auth_screen.dart';
import '../../../custom_widget/primary_button.dart';
import '../../../utils/size_config.dart';
import 'bloc/forgot_password_bloc.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: COLOR_CONST.backgroundColor,
        body: BlocProvider(
            create: (context) => ForgotPasswordBloc(),
            child: const ForgotPasswordBody()));
  }
}

class ForgotPasswordBody extends StatefulWidget {
  const ForgotPasswordBody({Key? key}) : super(key: key);

  @override
  ForgotPasswordBodyState createState() => ForgotPasswordBodyState();
}

class ForgotPasswordBodyState extends State<ForgotPasswordBody> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController;
  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
      listenWhen: (p, c) => p.status != c.status,
      listener: (context, state) {
        if (state.status.isSubmissionInProgress) {
          LoadingShowAble.showLoading();
        } else if (state.status.isSubmissionSuccess) {
          LoadingShowAble.hideLoading();

          if (state.message != null && state.message!.isNotEmpty) {
            PopupNotificationCustom.showMessgae(
              title: 'Thành công',
              message: state.message ?? '',
              hiddenButtonLeft: true,
              buttonTitleRight: 'Quay lại đăng nhập',
              colorTitleRight: COLOR_CONST.cloudBurst,
              pressButtonRight: () {
                Navigator.of(context).pop();
              },
            );
          }
        } else if (state.status.isSubmissionSuccess) {
          LoadingShowAble.hideLoading();

          ToastShowAble.show(
              toastType: ToastMessageType.ERROR, message: state.message ?? '');
        } else {
          LoadingShowAble.hideLoading();
        }
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const HeaderAuthScreen(),
              const VerticalSpacing(of: 10),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: appDefaultPadding + 20),
                child: Column(
                  children: [
                    Text(
                      "Nhập email liên kết với tài khoản của bạn. \nHệ thống sẽ gửi mật khẩu mới về email này",
                      textAlign: TextAlign.center,
                      style: FONT_CONST.medium(
                        color: COLOR_CONST.cloudBurst,
                      ),
                    ),
                    const VerticalSpacing(of: 20),
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextFormField(
                            hintText: 'your email',
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: (p0) {
                              final value = p0?.trim();
                              if (value == null || value.isEmpty) {
                                return 'Email bắt buộc';
                              }
                              return null;
                            },
                          ),
                          const VerticalSpacing(of: 35),
                          PrimaryButton(
                            title: 'Tiếp tục',
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                context.forgotPasswordBloc.add(
                                    SubmitResetPassEvent(
                                        email: _emailController.text.trim()));
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    const VerticalSpacing(of: 20),
                    PrimaryBorderButton(
                      title: 'Quay lại',
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // void onNextPage(BuildContext context) {
  //   Navigator.pushNamedAndRemoveUntil(
  //     context,
  //     AppRouter.DASHBOARD_SCREEN,
  //     (route) => false,
  //   );
  // }
}
