import 'package:equatable/equatable.dart';
import 'package:g_json/g_json.dart';
import 'package:firefly/data/model/user_model.dart';

class FaceModel extends Equatable {
  final int id;
  final UserModel user;
  final String image;
  final String createdAt;
  final String updatedAt;

  const FaceModel({
    required this.id,
    required this.user,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FaceModel.fromJson(JSON json) {
    return FaceModel(
      id: json['id'].integerValue,
      user: UserModel.fromJson(json['user']),
      image: json['image'].stringValue,
      createdAt: json['created_at'].stringValue,
      updatedAt: json['updated_at'].stringValue,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        id,
        user,
        image,
        createdAt,
        updatedAt,
      ];
}
