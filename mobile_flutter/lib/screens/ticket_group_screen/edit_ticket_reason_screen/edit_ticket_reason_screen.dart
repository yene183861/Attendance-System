import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:formz/formz.dart';
import 'package:firefly/custom_widget/appbar_default_custom.dart';
import 'package:firefly/custom_widget/default_padding.dart';
import 'package:firefly/custom_widget/loading_show_able.dart';
import 'package:firefly/custom_widget/popup_notification_custom.dart';
import 'package:firefly/custom_widget/primary_button.dart';
import 'package:firefly/custom_widget/toast_show_able/barrel_toast.dart';
import 'package:firefly/data/arguments/edit_ticket_reason_arguments.dart';
import 'package:firefly/data/enum_type/user_type.dart';
import 'package:firefly/data/model/ticket_reason_model.dart';
import 'package:firefly/screens/ticket_group_screen/edit_ticket_reason_screen/bloc/edit_ticket_reason_bloc.dart';
import 'package:firefly/screens/ticket_group_screen/edit_ticket_reason_screen/components/by_time_select.dart';
import 'package:firefly/screens/ticket_group_screen/edit_ticket_reason_screen/components/checkbox_cacul_work.dart';
import 'package:firefly/screens/ticket_group_screen/edit_ticket_reason_screen/components/description_textfield.dart';
import 'package:firefly/screens/ticket_group_screen/edit_ticket_reason_screen/components/maximum_textfield.dart';
import 'package:firefly/screens/ticket_group_screen/edit_ticket_reason_screen/components/name_textfield.dart';
import 'package:firefly/screens/ticket_group_screen/edit_ticket_reason_screen/components/organization_select.dart';
import 'package:firefly/screens/ticket_group_screen/edit_ticket_reason_screen/components/ticket_type_select.dart';
import 'package:firefly/utils/singleton.dart';
import 'package:firefly/utils/size_config.dart';

class EditTicketReasonScreen extends StatelessWidget {
  const EditTicketReasonScreen(
      {super.key, required this.editTicketReasonArgument});
  final EditTicketReasonArgument editTicketReasonArgument;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarDefaultCustom(
        title: 'create_ticket_reason'.tr(),
        isCallBack: true,
      ),
      body: BlocProvider(
          create: (context) =>
              EditTicketReasonBloc(arg: editTicketReasonArgument),
          child: const EditTicketReasonScreenBody()),
    );
  }
}

class EditTicketReasonScreenBody extends StatefulWidget {
  const EditTicketReasonScreenBody({
    super.key,
  });

  @override
  State<EditTicketReasonScreenBody> createState() =>
      _EditTicketReasonScreenBodyState();
}

class _EditTicketReasonScreenBodyState
    extends State<EditTicketReasonScreenBody> {
  late TextEditingController nameController, descController, maximumController;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    context.editTicketReasonBloc.add(InitEvent());
    final ob = context.editTicketReasonBloc.state.ticketReasonModel;
    nameController = TextEditingController(text: ob?.name ?? '');
    descController = TextEditingController(text: ob?.description ?? '');
    maximumController =
        TextEditingController(text: (ob?.maximum ?? '1').toString());
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    descController.dispose();
    maximumController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditTicketReasonBloc, EditTicketReasonState>(
      listenWhen: (previous, current) => previous.status != current.status,
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
          child: Padding(
            padding: defaultPadding(horizontal: 20, vertical: 0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (Singleton.instance.userType == UserType.ADMIN)
                    const OrganizationSelect(),
                  const TicketTypeSelect(),
                  const CheckboxCaculWork(),
                  ReasonTextField(
                    controller: nameController,
                    formKey: _formKey,
                  ),
                  const VerticalSpacing(of: 4),
                  const ByTimeWidget(),
                  MaximumTextfield(
                    controller: maximumController,
                    formKey: _formKey,
                  ),
                  const VerticalSpacing(of: 4),
                  DescriptionTextField(controller: descController),
                  const VerticalSpacing(of: 6),
                  PrimaryButton(
                    title:
                        context.editTicketReasonBloc.state.ticketReasonModel !=
                                null
                            ? 'update'.tr()
                            : 'title_create'.tr(),
                    onPressed: () {
                      final state = context.editTicketReasonBloc.state;
                      if (_formKey.currentState!.validate()) {
                        final model = TicketReasonModel(
                          organizationId: state.selectedOrganization!.id!,
                          ticketType: state.ticketType,
                          name: nameController.text.trim(),
                          maximum: int.parse(maximumController.text.trim()),
                          byTime: state.byTime,
                          isWorkCalculation: state.isCaculWork,
                          description: descController.text.trim(),
                        );
                        if (context
                                .editTicketReasonBloc.state.ticketReasonModel ==
                            null) {
                          context.editTicketReasonBloc.add(
                              CreateTicketReasonEvent(
                                  ticketReasonModel: model));
                        } else {
                          context.editTicketReasonBloc.add(
                            UpdateTicketReasonEvent(
                                ticketReasonModel: model,
                                id: state.ticketReasonModel!.id!),
                          );
                        }
                      }
                    },
                  ),
                  const VerticalSpacing(of: 15),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
