import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firefly/configs/resources/barrel_const.dart';
import 'package:firefly/screens/ticket_group_screen/edit_ticket_reason_screen/bloc/edit_ticket_reason_bloc.dart';

class CheckboxCaculWork extends StatelessWidget {
  const CheckboxCaculWork({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditTicketReasonBloc, EditTicketReasonState>(
      buildWhen: (previous, current) =>
          previous.isCaculWork != current.isCaculWork,
      builder: (context, state) => GestureDetector(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Checkbox(
                value: state.isCaculWork,
                onChanged: (bool? value) {
                  context.editTicketReasonBloc
                      .add(ChangeStatusCaculWork(value ?? false));
                },
                activeColor: COLOR_CONST.cloudBurst.withOpacity(0.7),
                checkColor: COLOR_CONST.white,
              ),
              Text(
                'work_cacul'.tr(),
                style: FONT_CONST.regular(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
