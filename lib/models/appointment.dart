import 'package:intl/intl.dart';

class Appointment {
  dynamic id, statusId,amount;
  String? note, time, createdDate, service, status, doctor, hospital;
  Beneficiary? beneficiary;
  DateTime? date;

  Appointment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    note = json['notes'];
    date = DateFormat("yyyy-MM-dd").parse(json['date']);
    time = json['time'];
    amount = json['amount_paid'];
    createdDate = json['created_at'];
    if (json['beneficiary'].toString().isNotEmpty) {
      beneficiary = Beneficiary.fromJson(json['beneficiary']);
    }
    service = json['service_name'];
    statusId = json['status_id'];
    status = json['status_name'];
    doctor = json['doctor_name'];
    hospital = json['hospital_name'];
  }
  @override
  String toString() {
    return '{ $date, $doctor }';
  }
}

class Beneficiary {
  dynamic age;
  String? firstName, lastName;

  Beneficiary.fromJson(Map<String, dynamic> json) {
    age = json['age'];
    firstName = json['first_name'];
    lastName = json['last_name'];
  }
}
