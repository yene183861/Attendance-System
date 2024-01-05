import 'package:easy_localization/easy_localization.dart';
import 'package:firefly/configs/resources/color_const.dart';
import 'package:firefly/configs/resources/font_const.dart';
import 'package:firefly/custom_widget/change_status_ticket.dart';
import 'package:firefly/custom_widget/custom_circle_avatar_from_network.dart';
import 'package:firefly/custom_widget/default_padding.dart';
import 'package:firefly/data/enum_type/contract_status.dart';
import 'package:firefly/data/enum_type/ticket_status.dart';
import 'package:firefly/data/enum_type/user_type.dart';
import 'package:firefly/data/model/contract_model.dart';
import 'package:firefly/screens/contract_screen_group/contract_screen/bloc/contract_bloc.dart';
import 'package:firefly/utils/pattern.dart';
import 'package:firefly/utils/singleton.dart';
import 'package:firefly/utils/size_config.dart';
import 'package:firefly/utils/utils.dart';
import 'package:flutter/material.dart';

class ContractItem extends StatelessWidget {
  const ContractItem({
    super.key,
    required this.model,
  });
  final ContractModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: defaultPadding(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: COLOR_CONST.backgroundColor,
        border: Border.all(
          color: COLOR_CONST.silverChalice.withOpacity(0.5),
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(2, 2),
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tình trạng: ',
                    style: FONT_CONST.medium(fontSize: 14),
                  ),
                  Container(
                    padding: defaultPadding(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: model.state.color.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      model.state.value,
                      style: FONT_CONST.bold(fontSize: 14),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Trạng thái: ',
                    style: FONT_CONST.medium(fontSize: 14),
                  ),
                  Container(
                    padding: defaultPadding(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: model.status.color.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      model.status.value,
                      style: FONT_CONST.bold(
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const VerticalSpacing(of: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Nhân viên: '.tr(),
                style: FONT_CONST.regular(fontSize: 14),
              ),
              const HorizontalSpacing(of: 5),
              CustomCircleAvatarFromNetwork(
                  size: 30, urlImage: model.user.avatarThumb ?? ''),
              const HorizontalSpacing(of: 5),
              Expanded(
                child: Text(
                  model.user.fullname,
                  style: FONT_CONST.bold(fontSize: 14),
                ),
              ),
            ],
          ),
          const VerticalSpacing(of: 8),
          Text.rich(
            TextSpan(children: [
              TextSpan(
                text: 'Tên hợp đồng: ',
                style: FONT_CONST.regular(fontSize: 14),
              ),
              TextSpan(
                text: model.name,
                style: FONT_CONST.regular(fontSize: 14),
              ),
            ]),
          ),
          Text.rich(
            TextSpan(children: [
              TextSpan(
                text: 'Mã hợp đồng: ',
                style: FONT_CONST.regular(fontSize: 14),
              ),
              TextSpan(
                text: model.contractCode,
                style: FONT_CONST.regular(fontSize: 14),
              ),
            ]),
          ),
          Text.rich(
            TextSpan(children: [
              TextSpan(
                text: 'Lương cơ bản: ',
                style: FONT_CONST.regular(fontSize: 14),
              ),
              TextSpan(
                text:
                    NumberFormat.decimalPattern('vi').format(model.basicSalary),
                style: FONT_CONST.medium(fontSize: 14),
              ),
            ]),
          ),
          Text.rich(
            TextSpan(children: [
              TextSpan(
                text: 'Hệ số lương: ',
                style: FONT_CONST.regular(fontSize: 14),
              ),
              TextSpan(
                text: NumberFormat.decimalPattern('vi')
                    .format(model.salaryCoefficient),
                style: FONT_CONST.regular(fontSize: 14),
              ),
            ]),
          ),
          Text.rich(
            TextSpan(children: [
              TextSpan(
                  text: 'Có hiệu lực từ ngày: ',
                  style: FONT_CONST.regular(fontSize: 14)),
              TextSpan(
                text: Utils.formatDateTimeToString(
                    time: model.startDate,
                    dateFormat: DateFormat(DateTimePattern.dayType1)),
                style: FONT_CONST.bold(fontSize: 14),
              ),
              TextSpan(text: ' đến ', style: FONT_CONST.regular(fontSize: 14)),
              TextSpan(
                  text: Utils.formatDateTimeToString(
                    time: model.endDate!,
                    dateFormat: DateFormat(DateTimePattern.dayType1),
                  ),
                  style: FONT_CONST.bold(fontSize: 14)),
            ]),
            style: FONT_CONST.regular(fontSize: 14),
          ),
          Row(
            children: [
              Text(
                'Người tạo: '.tr(),
                style: FONT_CONST.regular(fontSize: 14),
              ),
              const HorizontalSpacing(of: 5),
              CustomCircleAvatarFromNetwork(
                  size: 30, urlImage: model.creator!.avatarThumb ?? ''),
              const HorizontalSpacing(of: 5),
              Expanded(
                child: Text(
                  model.creator!.fullname,
                  style: FONT_CONST.medium(fontSize: 14),
                ),
              ),
            ],
          ),
          if (Singleton.instance.userType!.type <= UserType.CEO.type)
            Column(
              children: [
                const VerticalSpacing(of: 10),
                const Divider(height: 1),
                const VerticalSpacing(of: 10),
                ChangeStatusTicketWidget(
                  ticketStatus: model.status,
                  approvalButton: () {
                    print('dsdd');
                    context.contractBloc.add(
                      UpdateContractEvent(
                        model: model.copyWith(status: TicketStatus.APPROVED),
                        id: model.id!,
                      ),
                    );
                  },
                  refuseButton: () {
                    context.contractBloc.add(
                      UpdateContractEvent(
                        model: model.copyWith(status: TicketStatus.REFUSE),
                        id: model.id!,
                      ),
                    );
                  },
                ),
              ],
            ),
        ],
      ),
    );
  }
}
