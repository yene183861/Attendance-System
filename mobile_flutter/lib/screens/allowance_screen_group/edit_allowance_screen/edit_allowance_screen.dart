import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import 'package:firefly/configs/resources/barrel_const.dart';
import 'package:firefly/custom_widget/appbar_default_custom.dart';
import 'package:firefly/custom_widget/custom_dropdown_button.dart';
import 'package:firefly/custom_widget/custom_text_form_field.dart';
import 'package:firefly/custom_widget/default_padding.dart';
import 'package:firefly/custom_widget/loading_show_able.dart';
import 'package:firefly/custom_widget/popup_notification_custom.dart';
import 'package:firefly/custom_widget/primary_button.dart';
import 'package:firefly/custom_widget/title_field.dart';
import 'package:firefly/custom_widget/toast_show_able/barrel_toast.dart';
import 'package:firefly/data/arguments/edit_allowance_arguments.dart';
import 'package:firefly/data/enum_type/by_time.dart';
import 'package:firefly/data/enum_type/user_type.dart';
import 'package:firefly/data/model/allowance_model.dart';
import 'package:firefly/screens/allowance_screen_group/edit_allowance_screen/bloc/edit_allowance_bloc.dart';
import 'package:firefly/utils/pattern.dart';
import 'package:firefly/utils/singleton.dart';
import 'package:firefly/utils/size_config.dart';

class EditAllowanceScreen extends StatelessWidget {
  const EditAllowanceScreen({super.key, required this.arg});
  final EditAllowanceArgument arg;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: COLOR_CONST.backgroundColor,
      body: BlocProvider(
          create: (context) => EditAllowanceBloc(
                editAllowanceArgument: arg,
              ),
          child: const _AllowanceScreenForm()),
      appBar: AppbarDefaultCustom(
          title: Singleton.instance.userType!.type <= UserType.CEO.type
              ? (arg.allowanceModel == null
                  ? 'create_allowance'.tr()
                  : 'update_allowance'.tr())
              : 'Thông tin khoản phụ cấp',
          isCallBack: true),
    );
  }
}

class _AllowanceScreenForm extends StatefulWidget {
  const _AllowanceScreenForm({Key? key}) : super(key: key);

  @override
  State<_AllowanceScreenForm> createState() => _AllowanceScreenFormState();
}

class _AllowanceScreenFormState extends State<_AllowanceScreenForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameCtrl,
      descriptionCtrl,
      amountCtrl,
      maximumAmountCtrl;
  late FocusNode nameFocusNode,
      descriptionFocusNode,
      amountFocusNode,
      maximumAmountFocusNode;
  @override
  void initState() {
    super.initState();
    final allowance =
        context.editAllowanceBloc.state.editAllowanceArgument?.allowanceModel;
    nameCtrl = TextEditingController(text: allowance?.name ?? '');
    descriptionCtrl = TextEditingController(text: allowance?.description ?? '');
    amountCtrl = TextEditingController(
        text: NumberFormat.decimalPattern('vi').format(allowance?.amount));
    maximumAmountCtrl = TextEditingController(
        text:
            NumberFormat.decimalPattern('vi').format(allowance?.maximumAmount));

    nameFocusNode = FocusNode();
    descriptionFocusNode = FocusNode();
    amountFocusNode = FocusNode();
    maximumAmountFocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    nameCtrl.dispose();
    descriptionCtrl.dispose();
    amountCtrl.dispose();
    maximumAmountCtrl.dispose();

    nameFocusNode.dispose();
    descriptionFocusNode.dispose();
    amountFocusNode.dispose();
    maximumAmountFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditAllowanceBloc, EditAllowanceState>(
      listener: (context, state) {
        if (state.status.isSubmissionInProgress) {
          LoadingShowAble.showLoading();
        } else if (state.status.isSubmissionSuccess) {
          LoadingShowAble.hideLoading();
          if (state.message != null && state.message!.isNotEmpty) {
            ToastShowAble.show(
              toastType: ToastMessageType.SUCCESS,
              message: state.message ?? '',
            );

            Navigator.of(context).pop(true);
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
        child: Padding(
          padding: defaultPadding(horizontal: 20, vertical: 0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const VerticalSpacing(of: 10),
                TitleField(
                  title: 'name_allowance'.tr(),
                  isRequired: true,
                ),
                const VerticalSpacing(of: 6),
                CustomTextFormField(
                  hintText: 'example_name_allowance'.tr(),
                  enabled:
                      Singleton.instance.userType!.type <= UserType.CEO.type
                          ? true
                          : false,
                  controller: nameCtrl,
                  focusNode: nameFocusNode,
                  validator: (p0) {
                    final value = p0?.trim();
                    if (value == null || value.isEmpty) {
                      return 'name_not_blank'.tr();
                    }
                    if (value.length > 255) {
                      return 'Tối đa 255 ký tự'.tr();
                    }
                    return null;
                  },
                ),
                const VerticalSpacing(of: 15),
                TitleField(
                  title: 'title_description'.tr(),
                ),
                const VerticalSpacing(of: 6),
                CustomTextFormField(
                  focusNode: descriptionFocusNode,
                  hintText: 'add_description'.tr(),
                  controller: descriptionCtrl,
                  enabled:
                      Singleton.instance.userType!.type <= UserType.CEO.type
                          ? true
                          : false,
                  validator: (p0) {
                    final value = p0?.trim();

                    if (value != null &&
                        value.isNotEmpty &&
                        value.length > 255) {
                      return 'Tối đa 255 ký tự'.tr();
                    }
                    return null;
                  },
                ),
                const VerticalSpacing(of: 15),
                TitleField(
                  title: 'money'.tr(),
                  isRequired: true,
                ),
                const VerticalSpacing(of: 6),
                CustomTextFormField(
                  hintText: 'money_allowance'.tr(),
                  maxLength: null,
                  focusNode: amountFocusNode,
                  controller: amountCtrl,
                  keyboardType: TextInputType.number,
                  enabled:
                      Singleton.instance.userType!.type <= UserType.CEO.type
                          ? true
                          : false,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegexPattern.amountRegExp),
                  ],
                  validator: (p0) {
                    final value = p0?.trim();
                    if (value == null || value.isEmpty) {
                      return 'msg_required_field'.tr();
                    }
                    final amount = double.parse(value);
                    if (amount <= 0) {
                      return 'error_money_less_0'.tr();
                    }
                    return null;
                    // if (amount > 2147483647) {
                    //   return 'error_capacity_too_big'.tr();
                    // }
                  },
                ),
                const VerticalSpacing(of: 26),
                TitleField(
                  title: 'max_money'.tr(),
                  isRequired: true,
                ),
                const VerticalSpacing(of: 6),
                CustomTextFormField(
                  hintText: 'max_money'.tr(),
                  controller: maximumAmountCtrl,
                  focusNode: maximumAmountFocusNode,
                  keyboardType: TextInputType.number,
                  enabled:
                      Singleton.instance.userType!.type <= UserType.CEO.type
                          ? true
                          : false,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegexPattern.amountRegExp),
                  ],
                  validator: (p0) {
                    final value = p0?.trim();
                    if (value == null || value.isEmpty) {
                      return 'msg_required_field'.tr();
                    }
                    final amount = double.parse(value);
                    if (amount <= 0) {
                      return 'error_money_less_0'.tr();
                    }
                    if (amountCtrl.text.trim() != '' &&
                        amount < double.parse(amountCtrl.text.trim())) {
                      return 'error_max_amount_less_amount'.tr();
                    }
                    return null;
                  },
                ),
                const VerticalSpacing(of: 26),
                CustomDropdownButton(
                  marginTop: 0,
                  colorBorderFocused: COLOR_CONST.cloudBurst,
                  title: 'by_time'.tr(),
                  datas: (Singleton.instance.userType!.type <= UserType.CEO.type
                          ? ByTime.values
                          : [
                              context
                                          .editAllowanceBloc
                                          .state
                                          .editAllowanceArgument
                                          ?.allowanceModel !=
                                      null
                                  ? context
                                      .editAllowanceBloc
                                      .state
                                      .editAllowanceArgument!
                                      .allowanceModel!
                                      .byTime
                                  : ByTime.MONTH
                            ])
                      .map((e) => DropdownMenuItem<ByTime>(
                            value: e,
                            child: Text(
                              e.value.toUpperCase(),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: FONT_CONST.regular(),
                            ),
                          ))
                      .toList(),
                  selectedDefault: context.editAllowanceBloc.state
                              .editAllowanceArgument?.allowanceModel !=
                          null
                      ? context.editAllowanceBloc.state.editAllowanceArgument!
                          .allowanceModel!.byTime
                      : ByTime.MONTH,
                  onSelectionChanged: (p0) {
                    if (Singleton.instance.userType!.type <=
                        UserType.CEO.type) {
                      if (p0 is ByTime) {
                        context.editAllowanceBloc
                            .add(SelectByTimeEvent(byTime: p0));
                      }
                    }
                  },
                ),
                const VerticalSpacing(of: 30),
                Singleton.instance.userType!.type <= UserType.CEO.type
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (context.editAllowanceBloc.state
                                  .editAllowanceArgument!.allowanceModel !=
                              null)
                            Padding(
                              padding: EdgeInsets.only(
                                  right: SizeConfig.screenWidth * 0.05),
                              child: PrimaryBorderButton(
                                title: 'delete'.tr(),
                                width: SizeConfig.screenWidth * 0.3,
                                height: SizeConfig.buttonHeightDefault,
                                onPressed: () {
                                  PopupNotificationCustom.showMessgae(
                                    title: 'msg_confirm_delete'.tr(),
                                    message:
                                        'msg_confirm_delete_allowance'.tr(),
                                    hiddenButtonRight: false,
                                    pressButtonRight: () {
                                      context.editAllowanceBloc.add(
                                          DeleteAllowanceEvent(
                                              id: context
                                                  .editAllowanceBloc
                                                  .state
                                                  .editAllowanceArgument!
                                                  .allowanceModel!
                                                  .id!));
                                    },
                                  );
                                },
                              ),
                            ),
                          Expanded(
                            child: PrimaryButton(
                              title: context
                                          .editAllowanceBloc
                                          .state
                                          .editAllowanceArgument
                                          ?.allowanceModel ==
                                      null
                                  ? 'add'.tr().toUpperCase()
                                  : 'update'.tr().toUpperCase(),
                              boxDecoration: const BoxDecoration(
                                color: COLOR_CONST.cloudBurst,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                              ),
                              height: SizeConfig.buttonHeightDefault,
                              textStyle: FONT_CONST.semoBold(
                                color: COLOR_CONST.white,
                                fontSize: 16,
                              ),
                              onPressed: () {
                                FocusScope.of(context).unfocus();
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  final state = context.editAllowanceBloc.state;
                                  final allowance = AllowanceModel(
                                    organizationId: state
                                        .editAllowanceArgument!.idOrganization,
                                    name: nameCtrl.text.trim(),
                                    description: descriptionCtrl.text.trim(),
                                    amount:
                                        double.parse(amountCtrl.text.trim()),
                                    maximumAmount: double.parse(
                                        maximumAmountCtrl.text.trim()),
                                    byTime:
                                        context.editAllowanceBloc.state.byTime,
                                  );
                                  if (state.editAllowanceArgument
                                          ?.allowanceModel ==
                                      null) {
                                    context.editAllowanceBloc.add(
                                      CreateAllowanceEvent(
                                          allowanceModel: allowance),
                                    );
                                  } else {
                                    context.editAllowanceBloc.add(
                                      UpdateAllowanceEvent(
                                          allowanceModel: allowance),
                                    );
                                  }
                                }
                              },
                            ),
                          ),
                        ],
                      )
                    : const SizedBox.shrink()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
