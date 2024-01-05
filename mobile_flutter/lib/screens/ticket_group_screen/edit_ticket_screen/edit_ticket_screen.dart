import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:formz/formz.dart';
import 'package:firefly/custom_widget/appbar_default_custom.dart';
import 'package:firefly/custom_widget/custom_text_form_field.dart';
import 'package:firefly/custom_widget/default_padding.dart';
import 'package:firefly/custom_widget/loading_show_able.dart';
import 'package:firefly/custom_widget/popup_notification_custom.dart';
import 'package:firefly/custom_widget/primary_button.dart';
import 'package:firefly/custom_widget/toast_show_able/barrel_toast.dart';
import 'package:firefly/data/model/ticket_model.dart';
import 'package:firefly/screens/ticket_group_screen/edit_ticket_screen/bloc/edit_ticket_bloc.dart';
import 'package:firefly/screens/ticket_group_screen/edit_ticket_screen/components/select_datetime_widget.dart';
import 'package:firefly/screens/ticket_group_screen/edit_ticket_screen/components/ticket_reason_select.dart';
import 'package:firefly/screens/ticket_group_screen/edit_ticket_screen/components/ticket_type_select.dart';
import 'package:firefly/utils/size_config.dart';

import '../../../configs/resources/barrel_const.dart';

class EditTicketScreen extends StatelessWidget {
  const EditTicketScreen({super.key, this.ticket});
  final TicketModel? ticket;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarDefaultCustom(
        title: 'title_create_ticket1'.tr(),
        isCallBack: true,
      ),
      body: BlocProvider(
          create: (context) => EditTicketBloc(ticket: ticket)..add(InitEvent()),
          child: const EditTicketScreenBody()),
    );
  }
}

class EditTicketScreenBody extends StatefulWidget {
  const EditTicketScreenBody({
    super.key,
  });

  @override
  State<EditTicketScreenBody> createState() => _EditTicketScreenBodyState();
}

class _EditTicketScreenBodyState extends State<EditTicketScreenBody> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController desController,
      reviewerOpController,
      userController;

  // late TextfieldTagsController tagController;
  @override
  void initState() {
    super.initState();
    desController = TextEditingController(
        text: context.editTicketBloc.state.ticket?.description);
    reviewerOpController = TextEditingController();
    userController = TextEditingController();
    // tagController = TextfieldTagsController();
  }

  @override
  void dispose() {
    super.dispose();
    desController.dispose();
    reviewerOpController.dispose();
    userController.dispose();
    // tagController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditTicketBloc, EditTicketState>(
      listenWhen: (p, c) => p.status != c.status,
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
      child: KeyboardDismissOnTap(
        dismissOnCapturedTaps: true,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: defaultPadding(horizontal: 20, vertical: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TicketTypeSelect(),
                  const TicketReasonSelect(),
                  const SelectDateTimeWidget(),
                  DescriptionTicket(
                    controller: desController,
                  ),
                  // ReviewerOpinionTicket(
                  //   controller: reviewerOpController,
                  // ),
                  // StatusTicketWidget(),
                  const VerticalSpacing(),
                  PrimaryButton(
                      title: context.editTicketBloc.state.ticket != null
                          ? 'save'.tr()
                          : 'title_create'.tr(),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (context.editTicketBloc.state.ticket != null) {
                            context.editTicketBloc.add(
                                UpdateTicketEvent(desController.text.trim()));
                          } else {
                            context.editTicketBloc.add(CreateTicketEvent(
                                description: desController.text.trim()));
                          }
                        }
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DescriptionTicket extends StatelessWidget {
  const DescriptionTicket({
    super.key,
    required this.controller,
  });
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'title_description'.tr(),
              style: FONT_CONST.regular(
                  fontSize: 16, color: COLOR_CONST.cloudBurst),
            ),
            Text(
              ' (*)',
              style: FONT_CONST.regular(
                  fontSize: 16, color: COLOR_CONST.portlandOrange),
            ),
          ],
        ),
        const VerticalSpacing(of: 10),
        CustomTextFormField(
          hintText: 'title_description'.tr(),
          maxLength: 255,
          controller: controller,
          maxLines: null,
          validator: (p0) {
            final value = p0?.trim();
            if (value == null || value.isEmpty) {
              return 'Mô tả không được để trống';
            }
            return null;
          },
        ),
      ],
    );
  }
}

class ReviewerOpinionTicket extends StatelessWidget {
  const ReviewerOpinionTicket({
    super.key,
    required this.controller,
  });
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'title_reviewer_opinion'.tr(),
              style: FONT_CONST.regular(
                  fontSize: 16, color: COLOR_CONST.cloudBurst),
            ),
            Text(
              ' (*)',
              style: FONT_CONST.regular(
                  fontSize: 16, color: COLOR_CONST.portlandOrange),
            ),
          ],
        ),
        const VerticalSpacing(of: 10),
        CustomTextFormField(
          hintText: '...'.tr(),
          hintStyle:
              FONT_CONST.regular(fontStyle: FontStyle.italic, fontSize: 12),
          maxLength: 255,
          controller: controller,
          maxLines: null,
        ),
      ],
    );
  }
}
