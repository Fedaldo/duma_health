import 'package:cached_network_image/cached_network_image.dart';
import 'package:duma_health/models/appointment.dart';
import 'package:duma_health/models/user.dart';
import 'package:duma_health/utils/constants.dart';
import 'package:duma_health/utils/utils.dart';
import 'package:duma_health/widgets/appointment_details.dart';
import 'package:duma_health/widgets/loading_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';

class DialogPop {
  static action(BuildContext context,
      {required String title,
      required String message,
      required Function onConfirm,
      required String confirmText}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          titlePadding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
          elevation: 5.0,
          titleTextStyle:
              TextStyle(color: Theme.of(context).colorScheme.background),
          title: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(15),
                topLeft: Radius.circular(15),
              ),
              color: Theme.of(context).primaryColor,
            ),
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(10),
            child: Text(
              title.toUpperCase(),
              textAlign: TextAlign.center,
            ),
          ),
          content: Text(
            message,
            textAlign: TextAlign.center,
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    label: const Text(
                      "Cancel",
                    ),
                    icon: const Icon(Icons.close),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onConfirm();
                    },
                    label: Text(
                      confirmText,
                    ),
                    icon: const Icon(Icons.check),
                  ),
                )
              ],
            ),
          ],
        );
      },
    );
  }

  static successAppointmentDialog(
    BuildContext context, {
    required Appointment appointment,
    required Function onConfirm,
    required User user,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          titlePadding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
          elevation: 5.0,
          title: Container(
            padding: const EdgeInsets.all(5),
            child: Column(
              children: [
                const Icon(
                  Ionicons.checkmark_done_circle_outline,
                  color: Colors.green,
                  size: 50,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Success".toUpperCase(),
                  style: const TextStyle(
                    color: Colors.green,
                    letterSpacing: 2,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Icon(
                        Ionicons.mail_open_outline,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text(
                          Constants.message,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: appointmentDetails(
                        context,
                        icon: FontAwesome.user_md,
                        fontSize: 13,
                        map: {
                          'title': "Doctor",
                          'value': "${appointment.doctor}",
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
                        fontSize: 13,
                        map: {
                          'title': "Hospital",
                          'value': "${appointment.hospital}",
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: appointmentDetails(
                        context,
                        icon: Ionicons.calendar_outline,
                        fontSize: 13,
                        map: {
                          'title': "Date",
                          'value': Utils.dateFormat(appointment.date!),
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
                        fontSize: 13,
                        map: {
                          'title': "Hour",
                          'value': "${appointment.time}",
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actionsPadding: EdgeInsets.zero,
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
                onConfirm();
              },
              child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(10),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Continue".toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Icon(
                      Icons.arrow_right,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static errorAppointment(
    BuildContext context,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
              bottom: Radius.circular(10),
            ),
          ),
          titlePadding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
          elevation: 5.0,
          title: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.red,
            ),
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(10),
            child: Column(
              children: const [
                Icon(
                  Ionicons.close_circle_outline,
                  color: Colors.white,
                  size: 90,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Error",
                  style: TextStyle(
                    color: Colors.white,
                    letterSpacing: 3,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          content: const Text(
            "Sorry! Something went wrong. Try again later.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              letterSpacing: 2,
            ),
          ),
          actions: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                label: const Text(
                  "Try Again",
                ),
                icon: const Icon(Icons.close),
              ),
            ),
          ],
        );
      },
    );
  }

  static void showChooseImage(BuildContext context,
      {required Function onPressedCamera, required Function onPressedGallery}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          titlePadding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
          elevation: 5.0,
          titleTextStyle:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          title: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(15),
                topLeft: Radius.circular(15),
              ),
              color: Theme.of(context).colorScheme.secondary,
            ),
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(10),
            child: Text(
              "Choose from".toUpperCase(),
              textAlign: TextAlign.center,
            ),
          ),
          content: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    onPressedCamera();
                    Navigator.pop(context);
                  },
                  child: Card(
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.camera_alt_sharp),
                          Text(
                            "Camera".toUpperCase(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    onPressedGallery();
                    Navigator.pop(context);
                  },
                  child: Card(
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.image_sharp,
                          ),
                          Text(
                            "Gallery".toUpperCase(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  static showPrescription(
    BuildContext context, {
    required String image,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Size size = MediaQuery.of(context).size;
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          titlePadding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
          elevation: 5.0,
          title: Row(
            children: [
              IconButton(
                icon: const Icon(AntDesign.closecircle),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text("Medical prescription"),
              ),
            ],
          ),
          content: CachedNetworkImage(
            imageUrl: "${Constants.imagePath}$image",
            errorWidget: (BuildContext context, index, n) {
              return Image.asset("assets/logo.png");
            },
            placeholder: (context, n) {
              return LoadingHelper(
                width: size.width * 0.95,
                height: size.height * 0.95,
              );
            },
            width: size.width * 0.95,
            height: size.width * 0.95,
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }

  static information(BuildContext context,
      {required String title,
        required String message,}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          titlePadding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
          elevation: 5.0,
          titleTextStyle:
          TextStyle(color: Theme.of(context).colorScheme.background),
          title: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(15),
                topLeft: Radius.circular(15),
              ),
              color: Theme.of(context).primaryColor,
            ),
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(10),
            child: Text(
              title.toUpperCase(),
              textAlign: TextAlign.center,
            ),
          ),
          content: Text(
            message,
            textAlign: TextAlign.center,
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Close".toUpperCase(),
              ),
            ),
          ],
        );
      },
    );
  }
}
