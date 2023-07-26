import 'package:duma_health/models/sort_model.dart';
import 'package:flutter/material.dart';

class PopSortAppointment extends StatelessWidget {
  final ValueChanged<SortByAppoint?> onChanged;

  const PopSortAppointment({Key? key, required this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<SortByAppoint>(
        icon: const Icon(Icons.sort),
        onSelected: onChanged,
        itemBuilder: (BuildContext context) {
          return SortByAppoint.lists.map((e) {
            return PopupMenuItem<SortByAppoint>(
              value: e,
              child: Text(e.text),
            );
          }).toList();
        });
  }
}

class PopSortOrder extends StatelessWidget {
  final ValueChanged<SortByOrder?> onChanged;

  const PopSortOrder({Key? key, required this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<SortByOrder>(
        icon: const Icon(Icons.sort),
        onSelected: onChanged,
        itemBuilder: (BuildContext context) {
          return SortByOrder.lists.map((e) {
            return PopupMenuItem<SortByOrder>(
              value: e,
              child: Text(e.text),
            );
          }).toList();
        });
  }
}
