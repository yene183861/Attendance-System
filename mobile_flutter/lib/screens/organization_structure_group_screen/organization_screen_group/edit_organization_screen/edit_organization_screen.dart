import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:firefly/configs/resources/barrel_const.dart';
import 'package:firefly/custom_widget/appbar_default_custom.dart';
import 'package:firefly/custom_widget/custom_text_form_field.dart';
import 'package:firefly/custom_widget/default_padding.dart';
import 'package:firefly/custom_widget/loading_show_able.dart';
import 'package:firefly/custom_widget/popup_notification_custom.dart';
import 'package:firefly/custom_widget/primary_button.dart';
import 'package:firefly/custom_widget/show_picker_image.dart';
import 'package:firefly/custom_widget/title_field.dart';
import 'package:firefly/custom_widget/toast_show_able/barrel_toast.dart';
import 'package:firefly/data/model/organization_model.dart';
import 'package:firefly/data/request_param/edit_organization_param.dart';
import 'package:firefly/utils/pattern.dart';
import 'package:firefly/utils/size_config.dart';

import 'bloc/edit_organization_bloc.dart';

import 'package:shimmer/shimmer.dart';

class EditOrganizationScreen extends StatelessWidget {
  const EditOrganizationScreen({super.key, this.organizationModel});
  final OrganizationModel? organizationModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: COLOR_CONST.backgroundColor,
      body: BlocProvider(
        create: (context) =>
            EditOrganizationBloc(organization: organizationModel),
        child: const BodyScreen(),
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
  late TextEditingController nameCtrl, emailCtrl, phoneCtrl, addressCtrl;
  @override
  void initState() {
    super.initState();
    final org = context.editOrganizationBloc.state.organization;
    nameCtrl = TextEditingController(text: org?.name ?? '');
    emailCtrl = TextEditingController(text: org?.email ?? '');
    phoneCtrl = TextEditingController(text: org?.phoneNumber ?? '');
    addressCtrl = TextEditingController(text: org?.address ?? '');
  }

  @override
  void dispose() {
    super.dispose();
    nameCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    addressCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditOrganizationBloc, EditOrganizationState>(
      listener: (context, state) {
        if (state.status.isSubmissionInProgress) {
          LoadingShowAble.showLoading();
        } else if (state.status.isSubmissionSuccess) {
          LoadingShowAble.forceHide();
          ToastShowAble.show(
            toastType: ToastMessageType.SUCCESS,
            message: state.organization == null
                ? "msg_add_organization_success".tr()
                : "msg_update_organization_success".tr(),
          );

          Navigator.of(context).pop(state.organization);
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
                title: context.editOrganizationBloc.state.organization == null
                    ? 'add_organization'.tr()
                    : 'update_organization'.tr(),
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
                      title: 'logo'.tr(),
                    ),
                    const VerticalSpacing(of: 7),
                    BlocBuilder<EditOrganizationBloc, EditOrganizationState>(
                        buildWhen: (p, c) => p.logo?.path != c.logo?.path,
                        builder: (context, state) {
                          return InkWell(
                            onTap: () async {
                              final image = await showPickerImage(context);
                              if (image == null) return;
                              // context.editOrganizationBloc
                              //     .add(UpdateLogoEvent(logo: image));
                            },
                            splashColor:
                                COLOR_CONST.cloudBurst.withOpacity(0.1),
                            child: state.logo != null
                                ? Ink(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: COLOR_CONST.cloudBurst,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                        image: DecorationImage(
                                          image: FileImage(state.logo!),
                                          fit: BoxFit.cover,
                                        )),
                                    width: double.infinity,
                                    height: 200,
                                  )
                                : state.organization != null
                                    ? Ink(
                                        child: CachedNetworkImage(
                                          width: double.infinity,
                                          height: 200,
                                          imageUrl:
                                              state.organization?.logo ?? '',
                                          placeholder: (context, url) =>
                                              Shimmer.fromColors(
                                            baseColor: COLOR_CONST.gray
                                                .withOpacity(0.3),
                                            highlightColor: COLOR_CONST.gray
                                                .withOpacity(0.1),
                                            child: Container(
                                              clipBehavior: Clip.hardEdge,
                                              height: double.infinity,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: COLOR_CONST.cloudBurst,
                                                  width: 1,
                                                ),
                                                color: COLOR_CONST.gray,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Container(
                                            clipBehavior: Clip.hardEdge,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: COLOR_CONST.cloudBurst,
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              image: DecorationImage(
                                                image: AssetImage(
                                                    IMAGE_CONST.imgOffice.path),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                            clipBehavior: Clip.hardEdge,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: COLOR_CONST.cloudBurst,
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Ink(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: COLOR_CONST.cloudBurst,
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          image: DecorationImage(
                                            image: AssetImage(
                                                IMAGE_CONST.imgOffice.path),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        width: double.infinity,
                                        height: 200,
                                      ),
                          );
                        }),
                    const VerticalSpacing(of: 21),
                    TitleField(
                      title: 'name_organization'.tr(),
                      isRequired: true,
                    ),
                    const VerticalSpacing(of: 6),
                    CustomTextFormField(
                      maxLength: 255,
                      hintText: 'name_organization'.tr(),
                      controller: nameCtrl,
                      validator: (p0) {
                        final value = p0?.trim();
                        if (value == null || value.isEmpty) {
                          return 'name_organization_not_blank'.tr();
                        }
                        return null;
                      },
                    ),
                    TitleField(
                      title: 'email'.tr(),
                    ),
                    const VerticalSpacing(of: 6),
                    CustomTextFormField(
                      maxLength: 255,
                      hintText: 'email_organization'.tr(),
                      controller: emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      validator: (p0) {
                        final value = p0?.trim();
                        if (value != null && value.isNotEmpty) {
                          final isValid =
                              RegexPattern.emailRegExp.hasMatch(value);
                          if (!isValid) {
                            return 'error_invalid_email'.tr();
                          }
                        }
                        return null;
                      },
                    ),
                    TitleField(
                      title: 'phone_number'.tr(),
                    ),
                    const VerticalSpacing(of: 6),
                    CustomTextFormField(
                      maxLength: 11,
                      hintText: 'phone_number'.tr(),
                      controller: phoneCtrl,
                      keyboardType: TextInputType.phone,
                    ),
                    TitleField(
                      title: 'address'.tr(),
                    ),
                    const VerticalSpacing(of: 6),
                    CustomTextFormField(
                      maxLength: 255,
                      hintText: 'main_address'.tr(),
                      controller: addressCtrl,
                    ),
                    const VerticalSpacing(of: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // if (context.editOrganizationBloc.state.organization !=
                        //     null)
                        //   Padding(
                        //     padding: EdgeInsets.only(
                        //         right: SizeConfig.screenWidth * 0.05),
                        //     child: PrimaryBorderButton(
                        //       title: 'msg_delete'.tr(),
                        //       width: SizeConfig.screenWidth * 0.3,
                        //       height: SizeConfig.buttonHeightDefault - 10,
                        //       onPressed: () {
                        //         PopupNotificationCustom.showMessgae(
                        //           title: 'msg_confirm_delete'.tr(),
                        //           message: 'msg_confirm_delete_organization'.tr(),
                        //           hiddenButtonRight: false,
                        //           pressButtonLeft: () {
                        //             // context.editOrganizationBloc.add(
                        //             //     DeleteOrganizationEvent(
                        //             //         id: context.editOrganizationBloc.state
                        //             //             .organization!.id!));
                        //           },
                        //         );
                        //       },
                        //     ),
                        //   ),
                        Expanded(
                          child: PrimaryButton(
                            title: context.editOrganizationBloc.state
                                        .organization ==
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
                                    context.editOrganizationBloc.state;
                                final param = EditOrganizationParam(
                                  name: nameCtrl.text.trim(),
                                  phoneNumber: phoneCtrl.text.trim(),
                                  address: addressCtrl.text.trim(),
                                  email: emailCtrl.text.trim(),
                                  logo: state.logo,
                                );
                                if (state.organization == null) {
                                  context.editOrganizationBloc.add(
                                    CreateOrganizationEvent(
                                        organization: param),
                                  );
                                } else {
                                  context.editOrganizationBloc.add(
                                    UpdateOrganizationEvent(params: param),
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
