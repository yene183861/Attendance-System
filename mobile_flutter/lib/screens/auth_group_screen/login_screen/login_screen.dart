import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:formz/formz.dart';
import 'package:firefly/configs/resources/barrel_const.dart';
import 'package:firefly/custom_widget/custom_text_form_field.dart';
import 'package:firefly/custom_widget/popup_notification_custom.dart';
import 'package:firefly/custom_widget/primary_button.dart';
import 'package:firefly/data/request_param/login_param.dart';
import 'package:firefly/screens/app_router.dart';
import 'package:firefly/screens/auth_group_screen/login_screen/bloc/login_bloc.dart';
import 'package:firefly/utils/size_config.dart';
import '../../../custom_widget/header_auth_screen.dart';
import '../../../custom_widget/loading_show_able.dart';
import '../../../utils/pattern.dart';
import 'components/password_text_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: COLOR_CONST.backgroundColor,
      body: BlocProvider(
        create: (_) => LoginBloc(),
        child: const _LoginScreenForm(),
      ),
    );
  }
}

class _LoginScreenForm extends StatefulWidget {
  const _LoginScreenForm({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<_LoginScreenForm> {
  late TextEditingController emailController, passwordController;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listenWhen: (p, c) => p.status != c.status,
      listener: (context, state) {
        if (state.status.isSubmissionInProgress) {
          LoadingShowAble.showLoading();
        } else if (state.status.isSubmissionSuccess) {
          LoadingShowAble.forceHide();
          onNextPage(context);
        } else if (state.status.isSubmissionFailure) {
          LoadingShowAble.forceHide();
          PopupNotificationCustom.showMessgae(
            title: "title_error".tr(),
            message: state.message ?? "",
            hiddenButtonRight: true,
          );
        } else {
          LoadingShowAble.forceHide();
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
              Form(
                key: _formKey,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: appDefaultPadding + 20),
                  child: Column(
                    children: [
                      Text(
                        "app_name".tr(),
                        style: FONT_CONST.bold(
                          fontSize: 34,
                          fontFamily: 'LumanosimoRegular',
                          color: COLOR_CONST.cloudBurst,
                        ),
                      ),
                      const VerticalSpacing(of: 20),
                      CustomTextFormField(
                        hintText: 'email'.tr(),
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (p0) {
                          final email = p0?.trim();
                          if (email == null || email.isEmpty) {
                            context.loginBloc.add(
                                ChangeStateEmailTextFieldEvent(isValid: false));
                            return 'required_email'.tr();
                          } else {
                            final isValid =
                                RegexPattern.emailRegExp.hasMatch(email);
                            if (!isValid) {
                              context.loginBloc.add(
                                  ChangeStateEmailTextFieldEvent(
                                      isValid: false));
                              return 'error_invalid_email'.tr();
                            }
                            context.loginBloc.add(
                                ChangeStateEmailTextFieldEvent(isValid: true));
                          }
                          return null;
                        },
                        suffixIcon: BlocBuilder<LoginBloc, LoginState>(
                          buildWhen: (p, c) => p.isValidEmail != c.isValidEmail,
                          builder: (context, state) {
                            if (state.isValidEmail) {
                              return Container(
                                alignment: Alignment.center,
                                // width: 0,
                                child: SvgPicture.asset(
                                  ICON_CONST.icCheckAccept.path,
                                  width: 15,
                                ),
                              );
                            } else {
                              return const SizedBox.shrink();
                            }
                          },
                        ),
                      ),
                      const VerticalSpacing(of: 20),
                      PasswordTextField(
                        controller: passwordController,
                      ),
                      const VerticalSpacing(of: 35),
                      PrimaryButton(
                        title: 'title_login'.tr(),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final loginParams = LoginParams(
                                email: emailController.text.trim(),
                                password: passwordController.text.trim());

                            BlocProvider.of<LoginBloc>(context).add(
                                SubmitLoginEvent(loginParams: loginParams));
                          }
                        },
                        boxDecoration: const BoxDecoration(
                          color: COLOR_CONST.cloudBurst,
                          borderRadius: BorderRadius.all(
                            Radius.circular(12),
                          ),
                        ),
                      ),
                      const VerticalSpacing(of: 35),
                      InkWell(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(AppRouter.FORGOT_PASSWORD_SCREEN);
                        },
                        child: Text(
                          "title_forgot_password".tr(),
                          style: FONT_CONST.regular(
                            fontSize: 18,
                            color: COLOR_CONST.flamingo,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onNextPage(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRouter.DASHBOARD_SCREEN,
      (route) => false,
    );
  }
}
