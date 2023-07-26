import 'package:duma_health/models/hospital_service.dart';

class Hospital {
  dynamic id;
  String? name, address, phone, email, location;
  List<HospitalService> services = [];

  Hospital.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    phone = json['phone'];
    email = json['email'];
    location = json['location'];
    services = (json['services'] as List)
        .map(
          (e) => HospitalService.fromJson(e),
        )
        .toList();
  }
}
