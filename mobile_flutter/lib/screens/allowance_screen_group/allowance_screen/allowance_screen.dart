import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import 'package:firefly/configs/resources/barrel_const.dart';
import 'package:firefly/custom_widget/appbar_default_custom.dart';
import 'package:firefly/custom_widget/default_padding.dart';
import 'package:firefly/custom_widget/dropdown_select_organization.dart';
import 'package:firefly/custom_widget/popup_notification_custom.dart';
import 'package:firefly/custom_widget/primary_button.dart';
import 'package:firefly/data/arguments/edit_allowance_arguments.dart';
import 'package:firefly/data/enum_type/user_type.dart';
import 'package:firefly/screens/allowance_screen_group/allowance_screen/bloc/allowance_bloc.dart';
import 'package:firefly/screens/allowance_screen_group/allowance_screen/components/item_allowance.dart';
import 'package:firefly/screens/allowance_screen_group/allowance_screen/components/shimmer_allowance_list.dart';
import 'package:firefly/screens/app_router.dart';
import 'package:firefly/utils/singleton.dart';
import 'package:firefly/utils/size_config.dart';

class AllowanceScreen extends StatelessWidget {
  const AllowanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: COLOR_CONST.backgroundColor,
      body: BlocProvider(
          create: (context) => AllowanceBloc(),
          child: const _AllowanceScreenForm()),
      appBar:
          AppbarDefaultCustom(title: 'allowance_work'.tr(), isCallBack: true),
    );
  }
}

class _AllowanceScreenForm extends StatefulWidget {
  const _AllowanceScreenForm({Key? key}) : super(key: key);

  @override
  State<_AllowanceScreenForm> createState() => _AllowanceScreenFormState();
}

class _AllowanceScreenFormState extends State<_AllowanceScreenForm> {
  @override
  void initState() {
    super.initState();

    context.allowanceBloc.add(InitAllowanceEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AllowanceBloc, AllowanceState>(
      listenWhen: (p, c) => p.status != c.status,
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          PopupNotificationCustom.showMessgae(
            title: "title_error".tr(),
            message: state.message ?? "",
            hiddenButtonLeft: true,
          );
        }
      },
      child: Stack(
        alignment: Alignment.bottomCenter,
        fit: StackFit.expand,
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: defaultPadding(horizontal: 25, vertical: 10),
              child: Column(
                children: [
                  // if (Singleton.instance.userProfile?.userType ==
                  //     UserType.ADMIN)
                  BlocBuilder<AllowanceBloc, AllowanceState>(
                    buildWhen: (p, c) =>
                        p.organizationsList != c.organizationsList ||
                        p.selectedOrganization != c.selectedOrganization,
                    builder: (context, state) {
                      // if (state.organizationsList != null &&
                      //     state.organizationsList!.isNotEmpty) {
                      return DropdownSelectOrganization(
                        organizations: state.organizationsList ?? [],
                        selectedOrganization: state.selectedOrganization,
                        onSelectionChanged: (p0) {
                          context.allowanceBloc.add(
                            ChangeOrganizationEvent(organizationModel: p0),
                          );
                        },
                      );
                      // } else {
                      //   return const SizedBox.shrink();
                      // }
                    },
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      bottom:
                          Singleton.instance.userType!.type <= UserType.CEO.type
                              ? getProportionateScreenHeight(100)
                              : getProportionateScreenHeight(20),
                    ),
                    child: BlocBuilder<AllowanceBloc, AllowanceState>(
                      buildWhen: (p, c) {
                        return p.allowancesList != c.allowancesList ||
                            p.status != c.status;
                      },
                      builder: (context, state) {
                        return state.status.isSubmissionInProgress
                            ? const ShimmerAllowancesList()
                            : (state.allowancesList != null &&
                                    state.allowancesList!.isNotEmpty)
                                ? ListView.separated(
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) =>
                                        ItemAllowance(
                                      allowance: state.allowancesList![index],
                                    ),
                                    separatorBuilder: (context, index) =>
                                        const Divider(height: 1),
                                    itemCount: state.allowancesList!.length,
                                  )
                                : Padding(
                                    padding: const EdgeInsets.only(top: 100),
                                    child: Text(
                                      'no_allowance'.tr(),
                                      style: FONT_CONST.regular(),
                                    ),
                                  );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (Singleton.instance.userType!.type <= UserType.CEO.type)
            Positioned(
                bottom: 0,
                right: 0,
                left: 0,
                child: Container(
                  padding: defaultPadding(horizontal: 25),
                  decoration: BoxDecoration(
                      color: COLOR_CONST.backgroundColor,
                      boxShadow: [
                        BoxShadow(
                          color: COLOR_CONST.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(-2, -2),
                        ),
                      ]),
                  child: PrimaryButton(
                    title: 'create_allowance'.tr(),
                    onPressed: () async {
                      final org =
                          context.allowanceBloc.state.selectedOrganization;
                      if (org != null) {
                        final value = await Navigator.of(context).pushNamed(
                          AppRouter.EDIT_ALLOWANCE_SCREEN,
                          arguments: EditAllowanceArgument(
                            idOrganization: org.id!,
                          ),
                        );
                        if (value == true) {
                          context.allowanceBloc.add(GetAllowanceEvent());
                        }
                      } else {
                        PopupNotificationCustom.showMessgae(
                          title: "title_error".tr(),
                          message: "",
                          hiddenButtonLeft: true,
                        );
                      }
                    },
                  ),
                )),
        ],
      ),
    );
  }
}
