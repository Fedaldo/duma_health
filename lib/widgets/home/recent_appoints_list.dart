import 'package:duma_health/models/appointment.dart';
import 'package:duma_health/screens/pages/appointment_details.dart';
import 'package:duma_health/utils/enumeration.dart';
import 'package:duma_health/utils/utils.dart';
import 'package:duma_health/widgets/empty_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:go_router/go_router.dart';

Widget recentAppointsList(BuildContext context,List<Appointment> appoints) {
  if (appoints.isEmpty) {
    return EmptyPage(
      icon: Ionicons.calendar_sharp,
      title: "Book an appointment",
      subTitle: "In one of the best local hospitals",
      itemSize: 30,
      alignmentGeometry: Alignment.topCenter,
      onTap: () {
        context.go('/${RouterPath.allHospitals}');
      },
    );
  }
  return ListView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
    itemCount:
    appoints.length > 3 ? appoints.sublist(0, 3).length : appoints.length,
    itemBuilder: (BuildContext context, int itemIndex) => AppointmentCard(
      appointment: appoints[itemIndex],
    ),
  );
}
class AppointmentCard extends StatefulWidget {
  final Appointment appointment;

  const AppointmentCard({Key? key, required this.appointment})
      : super(key: key);

  @override
  State<AppointmentCard> createState() => _AppointmentCardState();
}

class _AppointmentCardState extends State<AppointmentCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _displayAppointDetails();
      },
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.withOpacity(0.3),
            ),
            borderRadius: BorderRadius.circular(10),
            color: Colors.white),
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(2),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  widget.appointment.statusId == 1
                      ? Ionicons.hourglass_outline
                      : Ionicons.checkmark,
                  size: 13,
                  color:  widget.appointment.statusId == 1
                      ? Colors.black54 :Theme.of(context).primaryColor,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  Utils.getStatus(int.parse("${widget.appointment.statusId}")),
                  style: TextStyle(
                    letterSpacing: 1,
                    fontSize: 13,
                    color:  widget.appointment.statusId == 1
                        ? Colors.black54 :Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 3,
            ),
            Row(
              children: [
                const Icon(
                  FontAwesome.hospital_o,
                  size: 15,
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  "${widget.appointment.hospital}",
                  style: const TextStyle(
                    letterSpacing: 1,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                const Icon(
                  FontAwesome.user_md,
                  size: 15,
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  "${widget.appointment.doctor}",
                  style: const TextStyle(
                    letterSpacing: 1,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Icon(
                  Ionicons.calendar_outline,
                  size: 15,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(
                  width: 2,
                ),
                Text(
                  Utils.dateFormat(widget.appointment.date!),
                  style: TextStyle(
                    letterSpacing: 1,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Icon(
                  Ionicons.time_outline,
                  size: 15,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(
                  width: 2,
                ),
                Text(
                  "${widget.appointment.time}",
                  style: TextStyle(
                    letterSpacing: 1,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  void _displayAppointDetails() {
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
          return AppointmentDetails(
            appointment: widget.appointment,
          );
        });
  }
}