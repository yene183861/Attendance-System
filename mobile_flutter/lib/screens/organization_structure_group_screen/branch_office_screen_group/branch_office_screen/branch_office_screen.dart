import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:firefly/configs/resources/barrel_const.dart';
import 'package:firefly/custom_widget/appbar_default_custom.dart';
import 'package:firefly/custom_widget/default_padding.dart';
import 'package:firefly/custom_widget/popup_notification_custom.dart';
import 'package:firefly/custom_widget/primary_button.dart';
import 'package:firefly/custom_widget/toast_show_able/barrel_toast.dart';
import 'package:firefly/data/arguments/edit_branch_argument.dart';
import 'package:firefly/data/enum_type/user_type.dart';
import 'package:firefly/screens/app_router.dart';
import 'package:firefly/screens/organization_structure_group_screen/branch_office_screen_group/branch_office_screen/components/branch_list_widget.dart';
import 'package:firefly/screens/organization_structure_group_screen/branch_office_screen_group/branch_office_screen/components/shimmer_branch_list.dart';
import 'package:firefly/utils/singleton.dart';
import 'package:firefly/utils/size_config.dart';

import 'bloc/branch_office_bloc.dart';

class BranchOfficeScreen extends StatelessWidget {
  const BranchOfficeScreen({
    super.key,
    required this.organizationId,
  });
  final int organizationId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: COLOR_CONST.backgroundColor,
      resizeToAvoidBottomInset: false,
      body: BlocProvider(
        create: (context) => BranchOfficeBloc(orgId: organizationId),
        child: const BranchOfficeScreenBody(),
      ),
    );
  }
}

class BranchOfficeScreenBody extends StatefulWidget {
  const BranchOfficeScreenBody({
    super.key,
  });

  @override
  State<BranchOfficeScreenBody> createState() => _BranchOfficeScreenBodyState();
}

class _BranchOfficeScreenBodyState extends State<BranchOfficeScreenBody> {
  late TextEditingController nameCtrl;
  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController();
    context.branchOfficeBloc.add(GetBranchOfficeEvent());
  }

  @override
  void dispose() {
    super.dispose();
    nameCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppbarDefaultCustom(title: 'branch_management'.tr(), isCallBack: true),
        Padding(
          padding: EdgeInsets.only(
            left: getProportionateScreenWidth(20),
            right: getProportionateScreenWidth(20),
            top: getProportionateScreenHeight(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (Singleton.instance.userType!.type <= UserType.CEO.type)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PrimaryButton(
                      title: 'add_branch'.tr(),
                      width: SizeConfig.screenWidth * 0.5,
                      onPressed: () async {
                        final value = await Navigator.of(context).pushNamed(
                          AppRouter.EDIT_BRANCH_OFFICE_SCREEN,
                          arguments: EditBranchArgument(
                              idOrganization: context
                                  .branchOfficeBloc.state.organizationId),
                        );
                        if (value == true) {
                          context.branchOfficeBloc.add(GetBranchOfficeEvent());
                        }
                      },
                    ),
                    const VerticalSpacing(of: 30),
                  ],
                ),
              Text(
                'branches_list'.tr(),
                style: FONT_CONST.semoBold(fontSize: 20),
              ),
              const VerticalSpacing(of: 10),
              const Divider(
                height: 1,
              ),
              BlocConsumer<BranchOfficeBloc, BranchOfficeState>(
                listenWhen: (p, c) => p.status != c.status,
                listener: (context, state) {
                  if (state.status.isSubmissionFailure) {
                    PopupNotificationCustom.showMessgae(
                      title: "title_error".tr(),
                      message: state.message ?? '',
                      hiddenButtonLeft: true,
                    );
                  } else if (state.status.isSubmissionSuccess &&
                      state.message != null &&
                      state.message!.isNotEmpty) {
                    ToastShowAble.show(
                      toastType: ToastMessageType.SUCCESS,
                      message: state.message ?? '',
                    );
                  }
                },
                buildWhen: (previous, current) =>
                    previous.status != current.status ||
                    previous.branchesList != current.branchesList,
                builder: (context, state) {
                  return state.status.isSubmissionInProgress
                      ? const ShimmerBranchList()
                      : (state.branchesList != null &&
                              state.branchesList!.isNotEmpty)
                          ? Column(
                              children: [
                                BranchsListWidget(),
                                Divider(
                                  height: 1,
                                ),
                              ],
                            )
                          : Center(
                              child: Container(
                                margin: defaultPadding(
                                  vertical: 30,
                                ),
                                child: Text(
                                  'no_data'.tr(),
                                  style: FONT_CONST.regular(),
                                ),
                              ),
                            );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
