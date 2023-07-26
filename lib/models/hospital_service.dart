class HospitalService {
  dynamic id;
  String? name, price;

  HospitalService.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['pivot']['price'];
  }
}
