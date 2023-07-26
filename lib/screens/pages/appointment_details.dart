import 'dart:convert';

import 'package:duma_health/models/appointment.dart';
import 'package:duma_health/models/user.dart';
import 'package:duma_health/utils/constants.dart';
import 'package:duma_health/utils/functions.dart';
import 'package:duma_health/utils/preferences.dart';
import 'package:duma_health/utils/utils.dart';
import 'package:duma_health/widgets/appointment_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';

class AppointmentDetails extends StatefulWidget {
  final Appointment appointment;

  const AppointmentDetails({Key? key, required this.appointment})
      : super(key: key);

  @override
  State<AppointmentDetails> createState() => _AppointmentDetailsState();
}

class _AppointmentDetailsState extends State<AppointmentDetails> {
  User? user;
  var userData = PreferenceUtils.getPreference(Constants.userData, null);

  @override
  void initState() {
    if (userData != null) {
      user = User.fromMap(jsonDecode(userData));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String patient = widget.appointment.beneficiary == null
        ? "${user?.firstName} ${user?.lastName}"
        : "${widget.appointment.beneficiary?.firstName} ${widget.appointment.beneficiary?.lastName}";
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                /*Visibility(
                  visible: "${widget.appointment.statusId}" != "1",
                  child: ElevatedButton.icon(
                    onPressed: () {
                      AppFunctions.payWithAfripay(
                        context,
                        orderId: '1',
                        afripayData: AppFunctions.buildAfripayData("10000"),
                      );
                    },
                    label: Text("Pay Now".toUpperCase()),
                    icon: const Icon(Icons.credit_card),
                  ),
                ),*/
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  child: const Icon(
                    Ionicons.person_outline,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 10,),
                Text(
                  patient,
                  style: TextStyle(
                    letterSpacing: 3,
                    fontSize: 15,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Doctor Details",
              style: TextStyle(color: Colors.black54),
            ),
            const Divider(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: appointmentDetails(
                    context,
                    icon: FontAwesome.user_md,
                    fontSize: 14,
                    map: {
                      'title': "Doctor",
                      'value': "${widget.appointment.doctor}",
                    },
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: appointmentDetails(
                    context,
                    icon: FontAwesome.hospital_o,
                    fontSize: 14,
                    map: {
                      'title': "Hospital",
                      'value': "${widget.appointment.hospital}",
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Appointment Details",
              style: TextStyle(color: Colors.black54),
            ),
            const Divider(),
            Row(
              children: [
                Expanded(
                  child: appointmentDetails(
                    context,
                    icon: Ionicons.calendar_outline,
                    fontSize: 14,
                    map: {
                      'title': "Date",
                      'value': Utils.dateFormat(widget.appointment.date!),
                    },
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: appointmentDetails(
                    context,
                    icon: Ionicons.time_outline,
                    fontSize: 14,
                    map: {
                      'title': "Hour",
                      'value': "${widget.appointment.time}",
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: appointmentDetails(
                    context,
                    icon: FontAwesome.handshake_o,
                    fontSize: 14,
                    map: {
                      'title': "Service",
                      'value': "${widget.appointment.service}",
                    },
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: appointmentDetails(
                    context,
                    icon: FontAwesome.money,
                    fontSize: 14,
                    map: {
                      'title': "Price",
                      'value':
                          "Fbu ${Utils.formatPrice("${widget.appointment.amount}")}",
                    },
                  ),
                ),
              ],
            ),
            appointmentDetails(
              context,
              icon: widget.appointment.statusId == 1
                  ? Ionicons.hourglass_outline
                  : Ionicons.checkmark,
              fontSize: 13,
              map: {
                'title': "Status",
                'value': Utils.getStatus(
                    int.parse("${widget.appointment.statusId}")),
              },
            ),
            Visibility(
              visible: widget.appointment.statusId == 1 ? true : false,
              child: appointmentDetails(
                context,
                icon: Ionicons.mail_open_outline,
                fontSize: 13,
                map: {
                  'title': "Message",
                  'value': Constants.message,
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
