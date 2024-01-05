import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:firefly/configs/resources/barrel_const.dart';
import 'package:firefly/custom_widget/custom_text_form_field.dart';
import 'package:firefly/custom_widget/default_padding.dart';
import 'package:firefly/custom_widget/primary_button.dart';
import 'package:firefly/custom_widget/title_field.dart';
import 'package:firefly/utils/size_config.dart';

class DialogReasonRefuse extends StatefulWidget {
  const DialogReasonRefuse({
    super.key,
    required this.onTap,
    this.text,
  });

  final String? text;
  final Function(String) onTap;

  @override
  State<DialogReasonRefuse> createState() => _DialogReasonRefuseState();
}

class _DialogReasonRefuseState extends State<DialogReasonRefuse> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController nameCtrl;
  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: widget.text);
  }

  @override
  void dispose() {
    super.dispose();
    nameCtrl.dispose();
  }

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
              title: 'Lý do'.tr(),
              isRequired: true,
            ),
            const VerticalSpacing(of: 6),
            CustomTextFormField(
              hintText: 'Lý do'.tr(),
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
            Container(
              width: double.infinity,
              child: PrimaryButton(
                width: SizeConfig.screenWidth * 0.3,
                height: SizeConfig.buttonHeightDefault,
                title: 'Lưu',
                backgroundColor: COLOR_CONST.cloudBurst.withOpacity(0.7),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.of(context).pop(nameCtrl.text.trim());
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
