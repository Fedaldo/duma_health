import 'package:duma_health/models/hour.dart';
import 'package:flutter/material.dart';

class HourItemCard extends StatelessWidget {
  final DoctorHour hour;

  const HourItemCard(this.hour, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: hour.isSelected
            ? Theme.of(context).colorScheme.secondary
            : Colors.grey.withOpacity(0.08),
        border: Border.all(
          width: hour.isSelected ?  1.5 : 0.8,
          color: hour.isSelected ? Colors.white : Colors.grey.withOpacity(0.3),
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.access_time_filled_outlined,
            size: 13,
            color: hour.isSelected ? Colors.white : Colors.black54,
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            hour.time,
            style: TextStyle(
                color: hour.isSelected ? Colors.white : Colors.black54,
                fontSize: 20,
                letterSpacing: 1,
                fontWeight:
                hour.isSelected ? FontWeight.bold : FontWeight.w100),
          ),
        ],
      ),
    );
  }
}
