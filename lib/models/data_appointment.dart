import 'package:duma_health/models/beneficiary.dart';
import 'package:duma_health/models/doctor.dart';
import 'package:duma_health/models/hospital.dart';
import 'package:duma_health/models/hospital_service.dart';
import 'package:duma_health/models/hour.dart';
import 'package:duma_health/models/user.dart';

class DataAppointment{
  DoctorHour hour;
  User user;
  String date,note;
  Hospital hospital;
  HospitalService service;
  Doctor doctor;
  bool isMe;
  Beneficiary? beneficiary;

  DataAppointment(
      {required this.hour,
        required this.user,
        required this.date,
        required this.note,
        required this.beneficiary,
        required this.hospital,
        required this.service,
        required this.doctor,
        required this.isMe});
}