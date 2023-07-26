import 'package:duma_health/models/hospital.dart';
import 'package:duma_health/models/hospital_service.dart';
import 'package:duma_health/widgets/service_card.dart';
import 'package:flutter/material.dart';

class HospitalServicesPage extends StatefulWidget {
  final Hospital hospital;

  const HospitalServicesPage({Key? key, required this.hospital}) : super(key: key);

  @override
  State<HospitalServicesPage> createState() => _HospitalServicesPageState();
}

class _HospitalServicesPageState extends State<HospitalServicesPage> {
  List<HospitalService> _lists = [];

  @override
  void initState() {
    _lists = widget.hospital.services;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Services"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: servicesWidget(),
        ),
      ),
    );
  }

  List<Widget> servicesWidget() {
    return _lists.map((s) {
      return ServiceCard(service: s);
    }).toList();
  }
}
