import 'package:duma_health/models/data_appointment.dart';
import 'package:duma_health/services/api.dart';
import 'package:duma_health/services/provider.dart';
import 'package:duma_health/utils/utils.dart';
import 'package:duma_health/widgets/appointment_details.dart';
import 'package:duma_health/widgets/dialogs_pop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SummaryPage extends StatefulWidget {
  final DataAppointment dataAppointment;

  const SummaryPage({Key? key, required this.dataAppointment})
      : super(key: key);

  @override
  State<SummaryPage> createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  bool _isSending = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.all(10),
      child: _isSending
          ? Stack(
              alignment: Alignment.center,
              children: [
                SpinKitCircle(
                  color: Theme.of(context).primaryColor,
                  size: 100,
                ),
                Icon(
                  FontAwesome.calendar_o,
                  color: Theme.of(context).primaryColor,
                ),
              ],
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.keyboard_arrow_left_rounded,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    label: Text(
                      "Back".toUpperCase(),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: appointmentDetails(
                                context,
                                map: {
                                  "title": "Doctor",
                                  "value":
                                      "${widget.dataAppointment.doctor.firstName} ${widget.dataAppointment.doctor.lastName}",
                                },
                                icon: FontAwesome.user_md,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: appointmentDetails(
                                context,
                                map: {
                                  "title": "Hospital",
                                  "value":
                                      "${widget.dataAppointment.hospital.name}",
                                },
                                icon: FontAwesome.hospital_o,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: appointmentDetails(
                                context,
                                map: {
                                  "title": "Service",
                                  "value":
                                      "${widget.dataAppointment.service.name}",
                                },
                                icon: FontAwesome.handshake_o,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: appointmentDetails(
                                context,
                                map: {
                                  "title": "Price",
                                  "value":
                                      "Fbu ${Utils.formatPrice("${widget.dataAppointment.service.price}")}",
                                },
                                icon: FontAwesome.money,
                              ),
                            ),
                          ],
                        ),
                        appointmentDetails(
                          context,
                          map: {
                            "title": "Date and Hour",
                            "value":
                                "${widget.dataAppointment.date} ${widget.dataAppointment.hour.time}",
                          },
                          icon: FontAwesome.calendar_check_o,
                        ),
                        appointmentDetails(
                          context,
                          map: {
                            "title": "Patient",
                            "value": patientDetails(),
                          },
                          icon: FontAwesome.user,
                        ),
                        appointmentDetails(
                          context,
                          map: {
                            "title": "Other Information",
                            "value": widget.dataAppointment.note.isEmpty
                                ? "-"
                                : widget.dataAppointment.note,
                          },
                          icon: FontAwesome.pencil,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _requestAppointment();
                      },
                      label: Text("Confirm".toUpperCase()),
                      icon: const Icon(Icons.check),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  void _requestAppointment() {
    setState(() {
      _isSending = true;
    });
    var data = {
      "user_id": "${widget.dataAppointment.user.id}",
      "hospital_id": "${widget.dataAppointment.hospital.id}",
      "service_id": "${widget.dataAppointment.service.id}",
      "doctor_id": "${widget.dataAppointment.doctor.id}",
      "date": widget.dataAppointment.date,
      "time": widget.dataAppointment.hour.time,
      "notes": widget.dataAppointment.note,
      "amount_paid": widget.dataAppointment.service.price,
      "beneficiary": getOther(),
    };
    Api.requestAppointment(data).then((value) {
      setState(() {
        _isSending = false;
      });
      if (value != null) {
        DialogPop.successAppointmentDialog(context, appointment: value,
            onConfirm: () {
          Provider.of<AppointmentProvider>(context, listen: false)
              .getAppointments(userId: "${widget.dataAppointment.user.id}");
          context.go('/');
        }, user: widget.dataAppointment.user);
      } else {
        DialogPop.errorAppointment(context);
      }
    });
  }

  String patientDetails() {
    if (widget.dataAppointment.isMe) {
      return "${widget.dataAppointment.user.firstName} ${widget.dataAppointment.user.lastName}";
    }
    return "${widget.dataAppointment.beneficiary?.firstName} ${widget.dataAppointment.beneficiary?.lastName}";
  }

  Map<String, String>? getOther() {
    if (!widget.dataAppointment.isMe) {
      return {
        "first_name": "${widget.dataAppointment.beneficiary?.firstName}",
        "last_name": "${widget.dataAppointment.beneficiary?.lastName}",
        "age": "${widget.dataAppointment.beneficiary?.age}",
      };
    }
    return null;
  }
}
