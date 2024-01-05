import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:firefly/custom_widget/appbar_default_custom.dart';
import 'package:firefly/custom_widget/custom_dropdown_button.dart';
import 'package:firefly/custom_widget/custom_text_form_field.dart';
import 'package:firefly/custom_widget/date_time_picker.dart';

import 'package:firefly/custom_widget/default_padding.dart';
import 'package:firefly/custom_widget/loading_show_able.dart';
import 'package:firefly/custom_widget/popup_notification_custom.dart';
import 'package:firefly/custom_widget/primary_button.dart';
import 'package:firefly/custom_widget/toast_show_able/barrel_toast.dart';
import 'package:firefly/data/enum_type/gender.dart';

import 'package:firefly/data/request_param/update_profile_param.dart';
import 'package:firefly/screens/change_profile_group/update_profile_screen/components/custom_birthday.dart';
import 'package:firefly/screens/change_profile_group/update_profile_screen/components/select_avatar.dart';
import 'package:firefly/utils/pattern.dart';

import 'package:firefly/utils/singleton.dart';
import 'package:firefly/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:firefly/configs/resources/barrel_const.dart';

import 'package:firefly/utils/size_config.dart';
import 'package:formz/formz.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import 'bloc/update_profile_bloc.dart';

class UpdateProfileScreen extends StatelessWidget {
  const UpdateProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: COLOR_CONST.backgroundColor,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: BlocProvider(
          create: (context) => UpdateProfileBloc(),
          child: const _BodyScreenForm(),
        ),
      ),
      appBar:
          const AppbarDefaultCustom(title: 'Cập nhập hồ sơ', isCallBack: true),
    );
  }
}

class _BodyScreenForm extends StatefulWidget {
  const _BodyScreenForm({Key? key}) : super(key: key);

  @override
  _BodyScreenState createState() => _BodyScreenState();
}

class _BodyScreenState extends State<_BodyScreenForm> {
  late TextEditingController fullnameCtrl,
      usernameCtrl,
      phoneCtrl,
      addressCtrl,
      emailCtrl,
      birthdayCtrl;
  late DateRangePickerController calendarController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final user = Singleton.instance.userProfile;
    fullnameCtrl = TextEditingController(text: user?.fullname);
    usernameCtrl = TextEditingController(text: user?.username);
    emailCtrl = TextEditingController(text: user?.email);
    birthdayCtrl = TextEditingController(
        text: user?.birthday != null
            ? DateFormat(DateTimePattern.dayType1).format(user!.birthday!)
            : null);
    phoneCtrl = TextEditingController(text: user?.phoneNumber);
    addressCtrl = TextEditingController(text: user?.address);

    calendarController = DateRangePickerController();
  }

  @override
  void dispose() {
    fullnameCtrl.dispose();
    usernameCtrl.dispose();
    emailCtrl.dispose();
    birthdayCtrl.dispose();
    phoneCtrl.dispose();
    addressCtrl.dispose();
    calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UpdateProfileBloc, UpdateProfileState>(
      listenWhen: (p, c) => p.status != c.status,
      listener: (context, state) {
        if (state.status.isSubmissionInProgress) {
          LoadingShowAble.showLoading();
        } else if (state.status.isSubmissionSuccess) {
          LoadingShowAble.forceHide();
          if (state.message != null && state.message!.isNotEmpty) {
            if (state.message != null && state.message!.isNotEmpty) {
              ToastShowAble.show(
                toastType: ToastMessageType.SUCCESS,
                message: state.message ?? '',
              );
            }
          }
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
      child: SingleChildScrollView(
        child: Padding(
          padding: defaultPadding(horizontal: 20, vertical: 0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectAvatar(),
                const VerticalSpacing(of: 15),
                Row(
                  children: [
                    Text(
                      'Họ và tên ',
                      style: FONT_CONST.medium(),
                    ),
                    Text(
                      '*',
                      style:
                          FONT_CONST.medium(color: COLOR_CONST.portlandOrange),
                    ),
                  ],
                ),
                const VerticalSpacing(of: 5),
                CustomTextFormField(
                  hintText: 'Họ và tên',
                  controller: fullnameCtrl,
                  maxLines: null,
                  enabled: false,
                  prefixIcon: const Icon(Icons.person),
                ),
                const VerticalSpacing(of: 15),
                Row(
                  children: [
                    Text(
                      'Email ',
                      style: FONT_CONST.medium(),
                    ),
                    Text(
                      '*',
                      style:
                          FONT_CONST.medium(color: COLOR_CONST.portlandOrange),
                    ),
                  ],
                ),
                const VerticalSpacing(of: 5),
                CustomTextFormField(
                  hintText: '',
                  controller: emailCtrl,
                  enabled: false,
                  maxLines: null,
                  prefixIcon: const Icon(Icons.email),
                ),
                const VerticalSpacing(of: 15),
                Row(
                  children: [
                    Text(
                      'Username',
                      style: FONT_CONST.medium(),
                    ),
                    Text(
                      '',
                      style:
                          FONT_CONST.medium(color: COLOR_CONST.portlandOrange),
                    ),
                  ],
                ),
                const VerticalSpacing(of: 5),
                CustomTextFormField(
                  hintText: '',
                  controller: usernameCtrl,
                  maxLines: null,
                  prefixIcon: const Icon(Icons.person_2_outlined),
                ),
                const VerticalSpacing(of: 15),
                BlocBuilder<UpdateProfileBloc, UpdateProfileState>(
                  buildWhen: (p, c) => p.gender != c.gender,
                  builder: (context, state) => SizedBox(
                    width: SizeConfig.screenWidth / 2 - 10,
                    child: CustomDropdownButton(
                      marginTop: 0,
                      colorBorderFocused: COLOR_CONST.cloudBurst,
                      title: 'Giới tính'.tr(),
                      isRequired: true,
                      datas: Gender.values
                          .map((e) => DropdownMenuItem<Gender>(
                                value: e,
                                child: Text(
                                  e.value,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: FONT_CONST.regular(),
                                ),
                              ))
                          .toList(),
                      selectedDefault: state.gender,
                      onSelectionChanged: (p0) {
                        if (p0 is Gender) {
                          context.updateProfileBloc
                              .add(ChangeGender(gender: p0));
                        }
                      },
                    ),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      'Số điện thoại ',
                      style: FONT_CONST.medium(),
                    ),
                    Text(
                      '',
                      style:
                          FONT_CONST.medium(color: COLOR_CONST.portlandOrange),
                    ),
                  ],
                ),
                const VerticalSpacing(of: 5),
                CustomTextFormField(
                  hintText: '',
                  controller: phoneCtrl,
                  maxLines: 1,
                  keyboardType: const TextInputType.numberWithOptions(),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  prefixIcon: const Icon(Icons.phone),
                  validator: (p0) {
                    final value = p0?.trim();
                    if (value != null && value.isNotEmpty) {
                      if (value.length != 10) {
                        return 'Số điện thoại không hợp lệ';
                      }
                      if (!RegexPattern.phoneRegExp.hasMatch(value)) {
                        return 'Số điện thoại không hợp lệ';
                      }
                      return null;
                    }
                    return null;
                  },
                ),
                const VerticalSpacing(of: 15),
                BlocBuilder<UpdateProfileBloc, UpdateProfileState>(
                    buildWhen: (previous, current) =>
                        previous.birthday != current.birthday ||
                        previous.errorBirthday != current.errorBirthday,
                    builder: (context, state) {
                      birthdayCtrl.text = state.birthday != null
                          ? Utils.formatDateTimeToString(
                              time: state.birthday!,
                              dateFormat: DateFormat(DateTimePattern.dayType1))
                          : '';

                      return CustomBirthdayEditText(
                        textController: birthdayCtrl,
                        inputType: TextInputType.number,
                        title: 'Sinh nhật'.tr(),
                        hint: 'dd/mm/yyyy',
                        errorText: state.errorBirthday,
                        isRequired: true,
                        press: () {
                          FocusScope.of(context).unfocus();
                          showModalDateTimePicker(
                            context: context,
                            currentDate: state.birthday == null
                                ? Utils.formatDateTimeToString(
                                    time: maximunDate(),
                                    dateFormat:
                                        DateFormat(DateTimePattern.dayType1))
                                : Utils.formatDateTimeToString(
                                    time: state.birthday!,
                                    dateFormat:
                                        DateFormat(DateTimePattern.dayType1)),
                            maximumYear: DateTime.now().year - 18,
                            maximumDate: maximunDate(),
                            selectedDate: (selectDate) {
                              context.updateProfileBloc
                                  .add(ChangeBirthday(birthday: selectDate));
                            },
                          );
                        },
                      );
                    }),
                Row(
                  children: [
                    Text(
                      'Địa chỉ ',
                      style: FONT_CONST.medium(),
                    ),
                    Text(
                      '',
                      style:
                          FONT_CONST.medium(color: COLOR_CONST.portlandOrange),
                    ),
                  ],
                ),
                const VerticalSpacing(of: 5),
                CustomTextFormField(
                  hintText: '',
                  controller: addressCtrl,
                  maxLines: null,
                  prefixIcon: const Icon(Icons.home),
                ),
                const VerticalSpacing(of: 25),
                PrimaryButton(
                  title: 'Lưu',
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final state = context.updateProfileBloc.state;
                      final param = UpdateProfileParam(
                          username: usernameCtrl.text.trim(),
                          gender: context.updateProfileBloc.state.gender,
                          phoneNumber: phoneCtrl.text.trim(),
                          address: addressCtrl.text.trim(),
                          birthday: context.updateProfileBloc.state.birthday,
                          avatar: state.avatarSelected != null
                              ? File(state.avatarSelected!)
                              : null);
                      context.updateProfileBloc
                          .add(SaveProfileEvent(updateProfileParam: param));
                    }
                  },
                ),
                const VerticalSpacing(of: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

DateTime maximunDate() {
  //phải trên 18 tuổi mới đăng ký được
  var date = DateTime.now();
  return DateTime(date.year - 18, date.month, date.day);
}
