import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';

class AfripayPopDialog {
  static error(
    BuildContext context, {
    required String message,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 5.0,
          titleTextStyle: const TextStyle(
            color: Colors.orange,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
          title: Text(
            "Error".toUpperCase(),
            textAlign: TextAlign.center,
          ),
          content: Container(
            padding: const EdgeInsets.all(2),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Ionicons.close_circle,
                  color: Colors.orange,
                  size: 100,
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 50,
              margin: const EdgeInsets.all(10),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                label: Text("Close".toUpperCase()),
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static info(
    BuildContext context, {
    required String title,
    required String message,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 5.0,
          titleTextStyle: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
          title: Text(
            title.toUpperCase(),
            textAlign: TextAlign.center,
          ),
          content: Container(
            padding: const EdgeInsets.all(2),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Ionicons.information_circle,
                  color: Theme.of(context).primaryColor,
                  size: 100,
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 50,
              margin: const EdgeInsets.all(10),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                label: Text("Close".toUpperCase()),
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static success(
    BuildContext context, {
    required String reference,
    required Function onDone,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 5.0,
          titleTextStyle: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
          title: Text(
            "Success!".toUpperCase(),
            textAlign: TextAlign.center,
          ),
          content: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Ionicons.checkmark_circle,
                  color: Colors.green,
                  size: 100,
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.receipt,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      reference,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  "Your payment has been processed successfully.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 50,
              margin: const EdgeInsets.all(10),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                  onDone();
                },
                label: Text("Done".toUpperCase()),
                icon: const Icon(
                  Icons.check,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
