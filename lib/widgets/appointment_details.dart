import 'package:flutter/material.dart';

Widget appointmentDetails(BuildContext context,{
  required Map<String, String> map,
  required IconData icon,
  double fontSize = 16,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 5.0,vertical: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: fontSize,
              color: Colors.black54,
            ),
            const SizedBox(
              width: 8,
            ),
            Text(
              "${map['title']}",
              style: TextStyle(
                letterSpacing: 1,
                fontSize: fontSize,
                color: Colors.black54,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 7,
        ),
        Text(
          "${map['value']}",
          style: TextStyle(
            letterSpacing: 1,
            color: Theme.of(context).primaryColor,
            fontSize: fontSize,
          ),
        ),
      ],
    ),
  );
}