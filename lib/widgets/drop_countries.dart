import 'package:duma_health/models/country.dart';
import 'package:flutter/material.dart';

class CountryDropDownButton extends StatelessWidget {
  final ValueChanged<Country?> onChanged;
  final List<Country> countries;
  final Country selectedCountry;

  const CountryDropDownButton(
      {super.key,
      required this.countries,
      required this.selectedCountry,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey,),
        borderRadius: BorderRadius.circular(5),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Country>(
          value: selectedCountry,
          isExpanded: true,
          items: buildDropDownMenuItems(context, countries),
          onChanged: onChanged,
        ),
      ),
    );
  }

  List<DropdownMenuItem<Country>> buildDropDownMenuItems(
      BuildContext context, List listItems) {
    List<DropdownMenuItem<Country>> items = [];
    for (Country listItem in listItems) {
      items.add(
        DropdownMenuItem(
          value: listItem,
          child: Text(
            "${listItem.name}",
            style: const TextStyle(letterSpacing: 2,),
          ),
        ),
      );
    }
    return items;
  }
}
