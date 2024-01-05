import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:firefly/utils/pattern.dart';
import 'package:firefly/utils/utils.dart';
import 'package:g_json/g_json.dart';

class FaceAttendanceModel extends Equatable {
  final int id;
  final int userId;
  final String image;
  final String createdAt;

  const FaceAttendanceModel({
    required this.id,
    required this.userId,
    required this.image,
    required this.createdAt,
  });

  factory FaceAttendanceModel.fromJson(JSON json) {
    return FaceAttendanceModel(
      id: json['id'].integerValue,
      userId: json['user'].integerValue,
      image: json['image'].stringValue,
      createdAt: Utils.formatDateTimeToString(
          time: DateFormat(DateTimePattern.dateFormatPromotion3)
              .parse(json['created_at'].stringValue),
          dateFormat: DateFormat(DateTimePattern.dateFormatDefault1)),
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['user'] = userId;
    data['image'] = image;
    data['created_at'] = createdAt;
    return data;
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        id,
        userId,
        image,
        createdAt,
      ];
}
