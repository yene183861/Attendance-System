import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:firefly/configs/resources/barrel_const.dart';
import 'package:firefly/custom_widget/custom_text_form_field.dart';
import 'package:firefly/custom_widget/default_padding.dart';
import 'package:firefly/custom_widget/primary_button.dart';
import 'package:firefly/custom_widget/title_field.dart';
import 'package:firefly/utils/size_config.dart';

class DialogEditBranch extends StatelessWidget {
  const DialogEditBranch({
    super.key,
    required GlobalKey<FormState> formKey,
    required this.nameCtrl,
    required this.onTap,
    this.isAdd = false,
  }) : _formKey = formKey;

  final GlobalKey<FormState> _formKey;
  final TextEditingController nameCtrl;
  final Function onTap;
  final bool isAdd;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: defaultPadding(horizontal: 20, vertical: 40),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleField(
              title: 'name'.tr(),
              isRequired: true,
            ),
            const VerticalSpacing(of: 6),
            CustomTextFormField(
              hintText: 'branch_name'.tr(),
              maxLength: 255,
              maxLines: null,
              controller: nameCtrl,
              validator: (p0) {
                final value = p0?.trim();
                if (value == null || value.isEmpty) {
                  return 'msg_required_field'.tr();
                }
                return null;
              },
            ),
            const VerticalSpacing(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PrimaryBorderButton(
                  width: SizeConfig.screenWidth * 0.3,
                  height: SizeConfig.buttonHeightDefault - 5,
                  title: 'title_cancel'.tr(),
                  boxDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: COLOR_CONST.backgroundColor,
                    border: Border.all(
                        color: COLOR_CONST.cloudBurst, strokeAlign: 0.5),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                PrimaryButton(
                  width: SizeConfig.screenWidth * 0.3,
                  height: SizeConfig.buttonHeightDefault,
                  title: isAdd ? 'create_new'.tr() : 'save'.tr(),
                  backgroundColor: COLOR_CONST.cloudBurst.withOpacity(0.7),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      onTap();
                      Navigator.of(context).pop(true);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
