import 'package:equatable/equatable.dart';
import 'package:g_json/g_json.dart';
import 'package:firefly/data/model/user_model.dart';

class OrganizationModel extends Equatable {
  final int? id;
  final String? name;
  final String? logo;
  final String? phoneNumber;
  final String? email;
  final String? address;
  final UserModel? owner;
  final int numberEmployees;

  const OrganizationModel({
    this.id,
    this.email,
    this.logo,
    this.name,
    this.phoneNumber,
    this.address,
    this.owner,
    this.numberEmployees = 0,
  });

  factory OrganizationModel.fromJson(JSON json) {
    return OrganizationModel(
      id: json['id'].integerValue,
      name: json['name'].stringValue,
      logo: json['logo'].stringValue,
      phoneNumber: json['phone_number'].stringValue,
      email: json['email'].stringValue,
      address: json['address'].stringValue,
      owner: UserModel.fromJson(json['owner']),
      numberEmployees: json['number_employees'].integerValue,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['logo'] = logo;
    data['phone_number'] = phoneNumber;
    data['email'] = email;
    data['address'] = address;
    data['number_employees'] = numberEmployees;
    return data;
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        id,
        name,
        logo,
        phoneNumber,
        email,
        address,
        numberEmployees,
      ];
}
