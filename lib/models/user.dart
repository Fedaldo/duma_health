class User{
  dynamic id,status,token;
  String? firstName,lastName,address,email,phone,error;

  User({this.error});

  User.fromJson(Map<String, dynamic> json) {
    id = json['user']['id'];
    status = json['user']['user_status_id'];
    firstName = json['user']['firstname'];
    lastName = json['user']['lastname'];
    address = json['user']['address'];
    email = json['user']['email'];
    phone = json['user']['phone'];
    token = json['token'];
  }
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    map.addAll({
      'id': id,
      'status': status,
      'first_name': firstName,
      'last_name': lastName,
      'address': address,
      'email': email,
      'phone': phone,
      'token': token,
    });
    return map;
  }

  User.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    status = data['status'];
    firstName = data['first_name'];
    lastName = data['last_name'];
    address = data['address'];
    email = data['email'];
    phone = data['phone'];
    token = data['token'];
  }
}