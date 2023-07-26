import 'package:duma_health/models/grid.dart';
import 'package:duma_health/models/hospital.dart';
import 'package:duma_health/services/provider.dart';
import 'package:duma_health/utils/enumeration.dart';
import 'package:duma_health/utils/functions.dart';
import 'package:duma_health/widgets/home/hospital_list.dart';
import 'package:duma_health/widgets/loading_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:provider/provider.dart';

class AllHospitalsPage extends StatefulWidget {
  const AllHospitalsPage({Key? key}) : super(key: key);

  @override
  State<AllHospitalsPage> createState() => _AllHospitalsPageState();
}

class _AllHospitalsPageState extends State<AllHospitalsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hospitals"),
        actions: [
          IconButton(onPressed:(){
            AppFunctions.displaySearch(context);

          }, icon: const Icon(Ionicons.search_outline),),
          const SizedBox(width: 10,),
        ],
      ),
      body: SingleChildScrollView(
        child: Consumer<HomeProvider>(builder: (context, provider, _) {
          if (provider.apiRequestStatus == APIRequestStatus.loading) {
            return ListItemHelper(
              divHeight: 0.2,
              isGrid: Grid(),
            );
          } else {
            return _hospitalList(provider.hospitals);
          }
        }),
      ),
    );
  }

  Widget _hospitalList(List<Hospital> hospitals) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 3.0,
        crossAxisSpacing: 3.0,
        mainAxisExtent: 120,
      ),
      itemCount: hospitals.length,
      itemBuilder: (BuildContext context, int itemIndex) => HospitalCard(
        hospital: hospitals[itemIndex],
        isAll: true,
      ),
    );
  }
}
