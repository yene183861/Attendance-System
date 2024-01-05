import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:firefly/configs/resources/barrel_const.dart';
import 'package:firefly/custom_widget/appbar_default_custom.dart';
import 'package:firefly/custom_widget/custom_text_form_field.dart';
import 'package:firefly/custom_widget/default_padding.dart';
import 'package:firefly/custom_widget/loading_show_able.dart';
import 'package:firefly/custom_widget/popup_notification_custom.dart';
import 'package:firefly/custom_widget/primary_button.dart';
import 'package:firefly/custom_widget/title_field.dart';
import 'package:firefly/custom_widget/toast_show_able/barrel_toast.dart';
import 'package:firefly/data/arguments/edit_branch_argument.dart';
import 'package:firefly/data/model/branch_office_model.dart';
import 'package:firefly/utils/pattern.dart';

import 'package:firefly/utils/size_config.dart';

import 'bloc/edit_branch_office_bloc.dart';

class EditBranchScreen extends StatelessWidget {
  const EditBranchScreen({super.key, required this.editBranchArgument});
  final EditBranchArgument editBranchArgument;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: COLOR_CONST.backgroundColor,
      resizeToAvoidBottomInset: false,
      body: BlocProvider(
        create: (context) => EditBranchOfficeBloc(arg: editBranchArgument),
        child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: const BodyScreen()),
      ),
    );
  }
}

class BodyScreen extends StatefulWidget {
  const BodyScreen({
    super.key,
  });

  @override
  State<BodyScreen> createState() => _BodyScreenState();
}

class _BodyScreenState extends State<BodyScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameCtrl,
      descCtrl,
      phoneCtrl,
      addressCtrl,
      taxCtrl;
  @override
  void initState() {
    super.initState();
    final org =
        context.editBranchOfficeBloc.state.editBranchArgument.branchModel;
    nameCtrl = TextEditingController(text: org?.name ?? '');
    descCtrl = TextEditingController(text: org?.shortDescription ?? '');
    phoneCtrl = TextEditingController(text: org?.phoneNumber ?? '');
    addressCtrl = TextEditingController(text: org?.address ?? '');
    taxCtrl = TextEditingController(text: org?.taxNumber ?? '');
  }

  @override
  void dispose() {
    super.dispose();
    nameCtrl.dispose();
    descCtrl.dispose();
    phoneCtrl.dispose();
    addressCtrl.dispose();
    taxCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditBranchOfficeBloc, EditBranchOfficeState>(
      listener: (context, state) {
        if (state.status.isSubmissionInProgress) {
          LoadingShowAble.showLoading();
        } else if (state.status.isSubmissionSuccess) {
          LoadingShowAble.forceHide();
          ToastShowAble.show(
            toastType: ToastMessageType.SUCCESS,
            message: state.message ?? '',
          );

          Navigator.of(context).pop(true);
        } else if (state.status.isSubmissionFailure) {
          LoadingShowAble.forceHide();
          PopupNotificationCustom.showMessgae(
            title: "title_error".tr(),
            message: state.message ?? '',
            hiddenButtonRight: true,
          );
        }
      },
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppbarDefaultCustom(
                title: context.editBranchOfficeBloc.state.editBranchArgument
                            .branchModel ==
                        null
                    ? 'add_branch'.tr()
                    : 'update_branch'.tr(),
                isCallBack: true),
            Padding(
              padding: defaultPadding(horizontal: 20, vertical: 0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const VerticalSpacing(of: 10),
                    TitleField(
                      title: 'name'.tr(),
                      isRequired: true,
                    ),
                    const VerticalSpacing(of: 6),
                    CustomTextFormField(
                      maxLength: 255,
                      hintText: 'branch_name'.tr(),
                      controller: nameCtrl,
                      validator: (p0) {
                        final value = p0?.trim();
                        if (value == null || value.isEmpty) {
                          return 'msg_required_field'.tr();
                        }
                        return null;
                      },
                    ),
                    TitleField(
                      title: 'short_desc'.tr(),
                    ),
                    const VerticalSpacing(of: 6),
                    CustomTextFormField(
                      maxLength: 255,
                      hintText: '...',
                      controller: descCtrl,
                    ),
                    TitleField(
                      title: 'phone_number'.tr(),
                    ),
                    const VerticalSpacing(of: 6),
                    CustomTextFormField(
                      maxLength: 11,
                      hintText: 'phone_number'.tr(),
                      controller: phoneCtrl,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegexPattern.amountRegExp),
                      ],
                    ),
                    TitleField(
                      title: 'address'.tr(),
                    ),
                    const VerticalSpacing(of: 6),
                    CustomTextFormField(
                      maxLength: 255,
                      hintText: 'address'.tr(),
                      controller: addressCtrl,
                    ),
                    TitleField(
                      title: 'tax'.tr(),
                    ),
                    const VerticalSpacing(of: 6),
                    CustomTextFormField(
                      maxLength: 255,
                      hintText: 'tax'.tr(),
                      controller: taxCtrl,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegexPattern.amountRegExp),
                      ],
                    ),
                    const VerticalSpacing(of: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (context.editBranchOfficeBloc.state
                                .editBranchArgument.branchModel !=
                            null)
                          Padding(
                            padding: EdgeInsets.only(
                                right: SizeConfig.screenWidth * 0.05),
                            child: PrimaryBorderButton(
                              title: 'delete'.tr(),
                              width: SizeConfig.screenWidth * 0.3,
                              height: SizeConfig.buttonHeightDefault - 10,
                              onPressed: () {
                                PopupNotificationCustom.showMessgae(
                                  title: 'msg_confirm_delete'.tr(),
                                  message: 'msg_confirm_delete_branch'.tr(),
                                  hiddenButtonRight: false,
                                  pressButtonRight: () {
                                    context.editBranchOfficeBloc.add(
                                        DeleteBranchEvent(
                                            id: context
                                                .editBranchOfficeBloc
                                                .state
                                                .editBranchArgument
                                                .branchModel!
                                                .id!));
                                  },
                                );
                              },
                            ),
                          ),
                        Expanded(
                          child: PrimaryButton(
                            title: context.editBranchOfficeBloc.state
                                        .editBranchArgument.branchModel ==
                                    null
                                ? 'add'.tr().toUpperCase()
                                : 'update'.tr().toUpperCase(),
                            boxDecoration: const BoxDecoration(
                              color: COLOR_CONST.cloudBurst,
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                            height: SizeConfig.buttonHeightDefault - 10,
                            textStyle: FONT_CONST.semoBold(
                              color: COLOR_CONST.white,
                              fontSize: 16,
                            ),
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                final state =
                                    context.editBranchOfficeBloc.state;
                                final param = BranchOfficeModel(
                                  organizationId: context.editBranchOfficeBloc
                                      .state.editBranchArgument.idOrganization,
                                  name: nameCtrl.text.trim(),
                                  phoneNumber: phoneCtrl.text.trim(),
                                  address: addressCtrl.text.trim(),
                                  shortDescription: descCtrl.text.trim(),
                                  taxNumber: taxCtrl.text.trim(),
                                );
                                if (state.editBranchArgument.branchModel ==
                                    null) {
                                  context.editBranchOfficeBloc
                                      .add(CreateBranchEvent(branch: param));
                                } else {
                                  context.editBranchOfficeBloc.add(
                                    UpdateBranchEvent(branch: param),
                                  );
                                }
                              }
                            },
                          ),
                        ),
                      ],
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
