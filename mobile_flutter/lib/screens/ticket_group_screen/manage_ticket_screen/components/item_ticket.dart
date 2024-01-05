// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:firefly/custom_widget/change_status_ticket.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:firefly/configs/resources/barrel_const.dart';
// import 'package:firefly/custom_widget/default_padding.dart';
// import 'package:firefly/data/enum_type/ticket_status.dart';
// import 'package:firefly/data/enum_type/ticket_type.dart';
// import 'package:firefly/data/model/ticket_model.dart';
// import 'package:firefly/screens/app_router.dart';
// import 'package:firefly/screens/ticket_group_screen/ticket_screen/bloc/ticket_bloc.dart';
// import 'package:firefly/utils/pattern.dart';
// import 'package:firefly/utils/singleton.dart';
// import 'package:firefly/utils/size_config.dart';
// import 'package:firefly/utils/utils.dart';

// class ItemTicket extends StatelessWidget {
//   const ItemTicket({
//     super.key,
//     required this.ticket,
//   });
//   final TicketModel ticket;

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () async {
//         final value = await Navigator.of(context)
//             .pushNamed(AppRouter.DETAIL_TICKET_SCREEN, arguments: ticket);
//         if (value == true) {
//           context.ticketBloc.add(GetTicketEvent());
//         }
//       },
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//         decoration: BoxDecoration(
//             border: Border.all(color: Colors.grey),
//             borderRadius: BorderRadius.circular(12)),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     const Icon(Icons.outbond),
//                     const SizedBox(width: 5),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           ticket.ticketType.value,
//                           style: FONT_CONST.semoBold(),
//                         ),
//                         Text(
//                           ticket.dateTimeTickets![0].ticketReason.name,
//                           style: FONT_CONST.regular(
//                               color: Colors.grey, fontSize: 14),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                   decoration: BoxDecoration(
//                       color: Colors.amber[50],
//                       borderRadius: BorderRadius.circular(8)),
//                   child: Row(
//                     children: [
//                       Container(
//                         height: 8,
//                         width: 8,
//                         decoration: BoxDecoration(
//                             shape: BoxShape.circle, color: Colors.amber),
//                         margin: EdgeInsets.only(right: 5),
//                       ),
//                       Text(
//                         ticket.status.value,
//                         style: FONT_CONST.medium(fontSize: 14),
//                       ),
//                     ],
//                   ),
//                 )
//               ],
//             ),
//             const Divider(
//               color: Colors.grey,
//             ),
//             const VerticalSpacing(of: 5),
//             if (Singleton.instance.userProfile?.id != ticket.user?.id)
//               Container(
//                 padding:
//                     EdgeInsets.only(bottom: getProportionateScreenHeight(8)),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text('Người tạo đơn: '.tr()),
//                     Container(
//                       margin: const EdgeInsets.symmetric(horizontal: 5),
//                       height: 20,
//                       width: 20,
//                       child: CachedNetworkImage(
//                         imageUrl: ticket.user?.avatarThumb ?? '',
//                         placeholder: (context, url) => CircleAvatar(
//                           backgroundImage: AssetImage(
//                             IMAGE_CONST.imgDefaultAvatar.path,
//                           ),
//                         ),
//                         errorWidget: (context, url, error) => CircleAvatar(
//                           backgroundImage: AssetImage(
//                             IMAGE_CONST.imgDefaultAvatar.path,
//                           ),
//                         ),
//                         imageBuilder: (context, imageProvider) => CircleAvatar(
//                           backgroundImage: imageProvider,
//                         ),
//                       ),
//                     ),
//                     Expanded(child: Text(ticket.user?.fullname ?? '')),
//                   ],
//                 ),
//               ),
//             TimeTicket(ticket: ticket),
//             Padding(
//               padding: defaultPadding(horizontal: 5, vertical: 5),
//               child: Text.rich(
//                 TextSpan(
//                   children: [
//                     TextSpan(text: 'Mô tả: '),
//                     TextSpan(text: ticket.description),
//                   ],
//                 ),
//                 style: FONT_CONST.regular(),
//               ),
//             ),
//             if (Singleton.instance.userProfile?.id != ticket.user?.id)
//               Column(
//                 children: [
//                   const Divider(
//                     color: Colors.grey,
//                   ),
//                   ChangeStatusTicketWidget(ticketStatus: ticket.status),
//                 ],
//               )
//           ],
//         ),
//       ),
//     );
//   }
// }

// class TimeTicket extends StatelessWidget {
//   const TimeTicket({
//     super.key,
//     required this.ticket,
//   });

//   final TicketModel ticket;

//   @override
//   Widget build(BuildContext context) {
//     final dateTime = ticket.dateTimeTickets![0];
//     final startDate = Utils.formatDateTimeToString(
//         time: dateTime.startDateTime,
//         dateFormat: DateFormat(DateTimePattern.dayType1));
//     final endDate = Utils.formatDateTimeToString(
//         time: dateTime.endDateTime,
//         dateFormat: DateFormat(DateTimePattern.dayType1));
//     final startTime = Utils.formatDateTimeToString(
//         time: dateTime.startDateTime,
//         dateFormat: DateFormat(DateTimePattern.timeType));
//     final endTime = Utils.formatDateTimeToString(
//         time: dateTime.endDateTime,
//         dateFormat: DateFormat(DateTimePattern.timeType));
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Expanded(
//           flex: 2,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Text(
//                 'Thời lượng',
//                 style: FONT_CONST.regular(fontSize: 14),
//                 textAlign: TextAlign.center,
//               ),
//               Text(
//                 caculDuration(),
//                 style: FONT_CONST.bold(fontSize: 14),
//                 textAlign: TextAlign.center,
//               ),
//             ],
//           ),
//         ),
//         Container(
//           margin: EdgeInsets.symmetric(horizontal: 8),
//           height: 50,
//           width: 1,
//           color: Colors.grey,
//         ),
//         Expanded(
//           flex: 5,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Thời gian',
//                 style: FONT_CONST.regular(fontSize: 14),
//               ),
//               (dateTime.startDate == dateTime.endDate)
//                   ? Text(
//                       '${dateTime.startTime} - ${dateTime.endTime}\n${Utils.formatDateTimeToString(time: startDate, dateFormat: DateFormat(DateTimePattern.dateFormatWithDay2))}',
//                       style: FONT_CONST.bold(fontSize: 14),
//                     )
//                   : Text(
//                       'Từ ${dateTime.startTime} ${Utils.formatDateTimeToString(time: startDate, dateFormat: DateFormat(DateTimePattern.dayType1))} tới ${dateTime.endTime} ${Utils.formatDateTimeToString(time: endDate, dateFormat: DateFormat(DateTimePattern.dayType1))}',
//                       style: FONT_CONST.bold(fontSize: 14),
//                     )
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   String caculDuration() {
//     final dateTime = ticket.dateTimeTickets![0];
//     final startDate = DateFormat(DateTimePattern.dateFormatPromotion1).parse(
//         '${dateTime.startDate.replaceAll('-', '/')} ${dateTime.startTime}');
//     final endDate = DateFormat(DateTimePattern.dateFormatPromotion1)
//         .parse('${dateTime.endDate.replaceAll('-', '/')} ${dateTime.endTime}');
//     final dura = endDate.difference(startDate).inMinutes;
//     if (dura < 60) {
//       return '$dura phút';
//     } else if (dura < 1440) {
//       final t = dura % 60;
//       if (t > 0) return '${dura ~/ 60} giờ ${dura % 60} phút';
//       return '${dura ~/ 60} giờ';
//     } else {
//       var t = '${dura ~/ 1440} ngày';
//       final h = dura % 1440;
//       if (h == 0) {
//         return t;
//       } else {
//         if (h < 60) {
//           return t + '$h phút';
//         } else {
//           if (h % 60 == 0) return t + '${h ~/ 60} giờ';
//           return t + '${h ~/ 60} giờ ${h % 60} phút';
//         }
//       }
//     }
//   }
// }
