import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:firefly/configs/resources/barrel_const.dart';
import 'package:firefly/custom_widget/popup_notification_custom.dart';
import 'package:firefly/custom_widget/toast_show_able/barrel_toast.dart';
import 'package:firefly/data/model/organization_model.dart';
import 'package:firefly/screens/app_router.dart';
import 'package:firefly/screens/organization_structure_group_screen/organization_screen_group/organization_management_screen/bloc/organization_bloc.dart';
import 'package:firefly/utils/size_config.dart';

import '../../../../custom_widget/appbar_default_custom.dart';
import 'components/organization_list_widget.dart';
import 'components/shimmer_org_list.dart';

class OrganizationScreen extends StatelessWidget {
  const OrganizationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrganizationBloc(),
      child: const OrgScreen(),
    );
  }
}

class OrgScreen extends StatelessWidget {
  const OrgScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: COLOR_CONST.backgroundColor,
      body: const OrganizationScreenBody(),
      floatingActionButton: InkWell(
        onTap: () async {
          final result = await Navigator.of(context)
              .pushNamed(AppRouter.EDIT_ORGANIZATION_SCREEN);

          if (result is OrganizationModel) {
            context.organizationBloc.add(GetOrganizationEvent());
          }
        },
        radius: 50,
        borderRadius: BorderRadius.circular(50),
        child: Ink(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: COLOR_CONST.cloudBurst,
          ),
          child: const Icon(
            Icons.add_business_outlined,
            color: COLOR_CONST.white,
            size: 30,
          ),
        ),
      ),
    );
  }
}

class OrganizationScreenBody extends StatefulWidget {
  const OrganizationScreenBody({
    super.key,
  });

  @override
  State<OrganizationScreenBody> createState() => _OrganizationScreenBodyState();
}

class _OrganizationScreenBodyState extends State<OrganizationScreenBody> {
  @override
  void initState() {
    super.initState();
    context.organizationBloc.add(GetOrganizationEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppbarDefaultCustom(
            title: 'organization_management'.tr(), isCallBack: true),
        BlocConsumer<OrganizationBloc, OrganizationState>(
          listenWhen: (p, c) => p.status != c.status,
          listener: (context, state) {
            if (state.status.isSubmissionFailure) {
              if (state.message == 'msg_delete_organization_success'.tr()) {
                ToastShowAble.show(
                  toastType: ToastMessageType.SUCCESS,
                  message: "msg_delete_organization_success".tr(),
                );
                context.organizationBloc.add(GetOrganizationEvent());
              } else {
                PopupNotificationCustom.showMessgae(
                  title: "title_error".tr(),
                  message: state.message ?? '',
                  hiddenButtonLeft: true,
                );
              }
            }
          },
          buildWhen: (previous, current) =>
              previous.status != current.status ||
              previous.organizationsList != current.organizationsList,
          builder: (context, state) {
            return Padding(
              padding: EdgeInsets.only(
                left: getProportionateScreenWidth(20),
                right: getProportionateScreenWidth(20),
                top: getProportionateScreenHeight(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'organizations_list'.tr(),
                    style: FONT_CONST.semoBold(fontSize: 20),
                  ),
                  const VerticalSpacing(),
                  state.status.isSubmissionInProgress
                      ? const ShimmerOrgList()
                      : (state.organizationsList != null &&
                              state.organizationsList!.isNotEmpty)
                          ? const OrganizationsListWidget()
                          : Text(
                              'no_organization'.tr(),
                              style: FONT_CONST.regular(),
                            ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
