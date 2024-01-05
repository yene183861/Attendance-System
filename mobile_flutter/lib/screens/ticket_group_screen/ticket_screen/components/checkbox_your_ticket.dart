import 'package:easy_localization/easy_localization.dart';
import 'package:firefly/screens/ticket_group_screen/ticket_screen/bloc/ticket_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firefly/configs/resources/barrel_const.dart';

class CheckboxYourTicket extends StatelessWidget {
  const CheckboxYourTicket({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TicketBloc, TicketState>(
      buildWhen: (previous, current) =>
          previous.isYourTicket != current.isYourTicket,
      builder: (context, state) => GestureDetector(
        onTap: () {},
        child: Container(
          // color: Colors.amber,
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Checkbox(
                visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                value: state.isYourTicket,
                onChanged: (bool? value) {
                  context.ticketBloc
                      .add(FilterYourTicket(isYourTicket: value ?? false));
                },
                activeColor: COLOR_CONST.cloudBurst.withOpacity(0.7),
                checkColor: COLOR_CONST.white,
              ),
              Text(
                'Đơn từ của bạn'.tr(),
                style: FONT_CONST.regular(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
