import 'package:equatable/equatable.dart';
import 'package:g_json/g_json.dart';
import 'package:firefly/data/model/user_model.dart';

class BranchOfficeModel extends Equatable {
  final int? id;
  final int? organizationId;
  final String? name;
  final String? phoneNumber;
  final String? address;
  final String? shortDescription;
  final String? taxNumber;
  final UserModel? director;
  final int numberEmployees;

  const BranchOfficeModel({
    this.id,
    this.organizationId,
    this.phoneNumber,
    this.name,
    this.address,
    this.taxNumber,
    this.shortDescription,
    this.director,
    this.numberEmployees = 0,
  });

  factory BranchOfficeModel.fromJson(JSON json) {
    return BranchOfficeModel(
      id: json['id'].integerValue,
      name: json['name'].stringValue,
      organizationId: json['organization'].integerValue,
      shortDescription: json['short_description'].stringValue,
      phoneNumber: json['phone_number'].stringValue,
      address: json['address'].stringValue,
      taxNumber: json['tax_number'].stringValue,
      director: UserModel.fromJson(json['director']),
      numberEmployees: json['number_employees'].integerValue,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['organization'] = organizationId;
    data['phone_number'] = phoneNumber;
    data['short_description'] = shortDescription;
    data['tax_number'] = taxNumber;
    data['address'] = address;
    data['number_employees'] = numberEmployees;
    return data;
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        id,
        name,
        organizationId,
        phoneNumber,
        address,
        shortDescription,
        taxNumber,
        numberEmployees,
      ];
}
