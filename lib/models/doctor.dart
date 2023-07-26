class Doctor {
  dynamic id;
  String? firstName,lastName,speciality;

  Doctor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstname'];
    lastName = json['lastname'];
    speciality = json['speciality'];
  }
}
