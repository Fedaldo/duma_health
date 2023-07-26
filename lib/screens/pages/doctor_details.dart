import 'dart:convert';

import 'package:duma_health/models/beneficiary.dart';
import 'package:duma_health/models/data_appointment.dart';
import 'package:duma_health/models/doctor.dart';
import 'package:duma_health/models/hospital.dart';
import 'package:duma_health/models/hospital_service.dart';
import 'package:duma_health/models/hour.dart';
import 'package:duma_health/models/user.dart';
import 'package:duma_health/screens/pages/summary.dart';
import 'package:duma_health/utils/constants.dart';
import 'package:duma_health/utils/data_manager.dart';
import 'package:duma_health/utils/preferences.dart';
import 'package:duma_health/utils/utils.dart';
import 'package:duma_health/widgets/hour_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:intl/intl.dart';

class DoctorDetailsPage extends StatefulWidget {
  final Doctor doctor;

  const DoctorDetailsPage({Key? key, required this.doctor}) : super(key: key);

  @override
  State<DoctorDetailsPage> createState() => _DoctorDetailsPageState();
}

class _DoctorDetailsPageState extends State<DoctorDetailsPage> {
  List<DoctorHour> hours = [];
  DateTime setDate = DateTime.now().add(const Duration(days: 1));
  TextEditingController lNameController = TextEditingController();
  TextEditingController fNameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  Hospital? hospital = DataManager.getInstance().hospital;
  HospitalService? service = DataManager.getInstance().service;
  var userData = PreferenceUtils.getPreference(Constants.userData, null);
  User? user;
  bool isMe = true;

  @override
  void initState() {
    if (userData != null) {
      user = User.fromMap(jsonDecode(userData));
    }
    hours = [
      DoctorHour(time: "08:00", isSelected: true),
      DoctorHour(time: "08:30"),
      DoctorHour(time: "09:00"),
      DoctorHour(time: "09:30"),
      DoctorHour(time: "10:00"),
      DoctorHour(time: "15:00"),
      DoctorHour(time: "15:30"),
      DoctorHour(time: "16:00"),
      DoctorHour(time: "16:30"),
      DoctorHour(time: "17:00"),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        leading: Align(
          alignment: Alignment.topLeft,
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
            ),
          ),
        ),
        centerTitle: false,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                FontAwesome.user_md,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${widget.doctor.firstName!} ${widget.doctor.lastName!}",
                    maxLines: 2,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Row(
                    children: [
                      const Icon(
                        FontAwesome.hospital_o,
                        size: 14,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: Text(
                          "${hospital?.name}",
                          maxLines: 1,
                          style: const TextStyle(
                            fontSize: 13,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.all(5),
                margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    detailsTitle(title: "Appointment"),
                    GestureDetector(
                      onTap: () => openDatePicker(),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Ionicons.calendar,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              DateFormat("dd/MM/yyyy").format(setDate),
                              style: TextStyle(
                                fontSize: 18.0,
                                letterSpacing: 3,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    hoursWidgets(),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.symmetric(
                  horizontal: 5,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    detailsTitle(title: "Patient Details"),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile(
                            selected: isMe,
                            selectedTileColor: Theme.of(context).primaryColor,
                            title: const Text("Myself"),
                            value: true,
                            onChanged: (v) {
                              setState(() {
                                isMe = v!;
                              });
                            },
                            groupValue: isMe,
                          ),
                        ),
                        Expanded(
                          child: RadioListTile(
                              selected: !isMe,
                              selectedTileColor: Theme.of(context).primaryColor,
                              groupValue: isMe,
                              title: const Text("Other"),
                              value: false,
                              onChanged: (v) {
                                setState(() {
                                  isMe = v!;
                                });
                              }),
                        ),
                      ],
                    ),
                    Visibility(
                      visible: !isMe,
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: fNameController,
                              decoration: InputDecoration(
                                labelText: "First Name",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              validator: (value) {
                                if (value.toString().isEmpty) {
                                  return "Champ vide";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: TextFormField(
                                    controller: lNameController,
                                    decoration: InputDecoration(
                                      labelText: "Last Name",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value.toString().isEmpty) {
                                        return "Champ vide";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  width: 3,
                                ),
                                Expanded(
                                  child: TextFormField(
                                    controller: ageController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: "Age",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value.toString().isEmpty) {
                                        return "Champ vide";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      maxLines: 3,
                      controller: noteController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        labelText: "Other Information (Optionnel)",
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Amount To Pay",
                          style: TextStyle(
                            letterSpacing: 1,
                          ),
                        ),
                        Text(
                          "Fbu ${Utils.formatPrice("${service?.price}")}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10,),
                    SizedBox(
                      width: size.width,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          if (!isMe) {
                            if (formKey.currentState!.validate()) {
                              _displaySummary(context);
                            }
                          } else {
                            _displaySummary(context);
                          }
                        },
                        icon: const Icon(Icons.keyboard_arrow_right),
                        label: Text(
                          'Book Now'.toUpperCase(),
                          style: const TextStyle(letterSpacing: 3),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget detailsTitle({
    required String title,
  }) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  Future<void> openDatePicker() async {
    await showDatePicker(
            context: context,
            initialDate: setDate,
            firstDate: DateTime.now().add(
              const Duration(days: 1),
            ),
            lastDate: DateTime.now().add(const Duration(days: 30)))
        .then((value) {
      DateTime newDate = DateTime(
          value != null ? value.year : setDate.year,
          value != null ? value.month : setDate.month,
          value != null ? value.day : setDate.day,
          setDate.hour,
          setDate.minute);
      setState(() => setDate = newDate);
    });
  }

  Widget hoursWidgets() {
    List<Widget> widgets = [];
    for (var i = 0; i < hours.length; i++) {
      widgets.add(
        InkWell(
          onTap: () {
            setState(() {
              for (var element in hours) {
                element.isSelected = false;
              }
              hours[i].isSelected = true;
            });
          },
          child: HourItemCard(hours[i]),
        ),
      );
    }
    return Wrap(children: widgets);
  }

  void _displaySummary(
    BuildContext context,
  ) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white.withOpacity(0.9),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        builder: (context) {
          DoctorHour hour = hours.firstWhere((element) => element.isSelected);
          return SummaryPage(
            dataAppointment: DataAppointment(
              hour: hour,
              user: user!,
              date: DateFormat("yyyy-MM-dd").format(setDate),
              note: noteController.text,
              beneficiary: Beneficiary(
                firstName: fNameController.text,
                lastName: lNameController.text,
                age: ageController.text,
              ),
              hospital: hospital!,
              service: service!,
              doctor: widget.doctor,
              isMe: isMe,
            ),
          );
        });
  }
}
