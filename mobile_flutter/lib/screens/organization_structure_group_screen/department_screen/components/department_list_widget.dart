import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firefly/configs/resources/barrel_const.dart';
import 'package:firefly/custom_widget/default_padding.dart';
import 'package:firefly/custom_widget/popup_notification_custom.dart';
import 'package:firefly/data/enum_type/user_type.dart';
import 'package:firefly/data/model/department_model.dart';
import 'package:firefly/screens/app_router.dart';
import 'package:firefly/screens/organization_structure_group_screen/department_screen/bloc/department_bloc.dart';
import 'package:firefly/utils/singleton.dart';
import 'package:firefly/utils/size_config.dart';

import 'dialog_edit_department.dart';

class DepartmentsListWidget extends StatelessWidget {
  const DepartmentsListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final list = context.departmentBloc.state.departmentsList;
    return ListView.separated(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: list!.length,
      itemBuilder: (context, index) => DepartmentItem(department: list[index]),
      separatorBuilder: (context, index) => Divider(
        color: COLOR_CONST.cloudBurst.withOpacity(0.5),
        height: 1,
      ),
    );
  }
}

class DepartmentItem extends StatelessWidget {
  const DepartmentItem({
    super.key,
    required this.department,
  });
  final DepartmentModel department;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(
          AppRouter.TEAM_SCREEN,
          arguments: department.id,
        );
      },
      child: Ink(
        padding: defaultPadding(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(color: Colors.grey.shade100),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    department.name ?? '',
                    style: FONT_CONST.extraBold(
                      color: COLOR_CONST.cloudBurst,
                      fontSize: 16,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(text: 'Quản lý: '),
                        TextSpan(
                          text: department.manager!.fullname.isEmpty
                              ? 'Chưa có'
                              : department.manager!.fullname,
                        ),
                      ],
                    ),
                    style: FONT_CONST.regular(fontSize: 14),
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '${"Số lượng nhân sự".tr()}: ',
                          style: FONT_CONST.medium(
                            color: COLOR_CONST.cloudBurst,
                            fontSize: 14,
                          ),
                        ),
                        TextSpan(
                          text: department.numberEmployees.toString(),
                          style: FONT_CONST.medium(
                            color: COLOR_CONST.cloudBurst,
                            fontSize: 14,
                          ),
                        ),
                      ],
                      style: FONT_CONST.regular(
                        color: COLOR_CONST.cloudBurst,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (Singleton.instance.userType!.type <= UserType.DIRECTOR.type)
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () async {
                      await showDialog(
                        context: context,
                        builder: (mContext) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            backgroundColor: COLOR_CONST.backgroundColor,
                            child: BlocProvider.value(
                              value: context.departmentBloc,
                              child: DialogEditDepartment(
                                text: department.name,
                                onTap: (value) {
                                  context.departmentBloc.add(
                                      UpdateDepartmentEvent(
                                          name: value, id: department.id!));
                                },
                                isAdd: false,
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Ink(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 5),
                      decoration: BoxDecoration(
                          color: COLOR_CONST.cloudBurst,
                          borderRadius: BorderRadius.circular(6)),
                      child: Text(
                        'update'.tr(),
                        style: FONT_CONST.regular(
                            color: COLOR_CONST.backgroundColor, fontSize: 12),
                      ),
                    ),
                  ),
                  SizedBox(height: getProportionateScreenHeight(8)),
                  InkWell(
                    onTap: () {
                      PopupNotificationCustom.showMessgae(
                        title: 'msg_confirm_delete'.tr(),
                        message: "msg_confirm_note_delete_department".tr(),
                        pressButtonRight: () {
                          context.departmentBloc
                              .add(DeleteDepartmentEvent(id: department.id!));
                        },
                      );
                    },
                    child: Ink(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 22, vertical: 5),
                      decoration: BoxDecoration(
                          color: COLOR_CONST.portlandOrange1,
                          borderRadius: BorderRadius.circular(6)),
                      child: Text(
                        'delete'.tr(),
                        style: FONT_CONST.regular(
                            color: COLOR_CONST.backgroundColor, fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
