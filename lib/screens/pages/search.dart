import 'package:duma_health/models/hospital.dart';
import 'package:duma_health/services/provider.dart';
import 'package:duma_health/widgets/home/hospital_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late List<Hospital> hospitals;
  List<Hospital> resultHospitals = [];

  @override
  void initState() {
    hospitals = Provider.of<HomeProvider>(context, listen: false).hospitals;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Container(
      height: height * 0.9,
      padding: const EdgeInsets.symmetric(horizontal: 10),
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
          TextFormField(
            autofocus: true,
            decoration: InputDecoration(
              isDense: true,
              hintText: "Recherche",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onChanged: (value) {
              setState(() {
                _findDoctor(value);
              });
            },
          ),
          const SizedBox(
            height: 10,
          ),
          Flexible(
            child: SingleChildScrollView(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: resultHospitals.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: const EdgeInsets.all(3),
                    child: HospitalCard(
                      hospital: resultHospitals[index],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _findDoctor(String searchText) {
    var foundHospital = hospitals
        .where((element) =>
            element.name!.toLowerCase().contains(searchText.toLowerCase()))
        .toList();
    if (foundHospital.isNotEmpty) {
      setState(() {
        resultHospitals = foundHospital;
      });
    }
  }
}
