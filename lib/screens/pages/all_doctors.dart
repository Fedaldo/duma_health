import 'dart:convert';

import 'package:duma_health/models/doctor.dart';
import 'package:duma_health/models/grid.dart';
import 'package:duma_health/models/hospital.dart';
import 'package:duma_health/models/hospital_service.dart';
import 'package:duma_health/models/user.dart';
import 'package:duma_health/services/provider.dart';
import 'package:duma_health/utils/constants.dart';
import 'package:duma_health/utils/data_manager.dart';
import 'package:duma_health/utils/enumeration.dart';
import 'package:duma_health/utils/preferences.dart';
import 'package:duma_health/widgets/loading_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AllDoctorsPage extends StatefulWidget {
  const AllDoctorsPage({Key? key}) : super(key: key);

  @override
  State<AllDoctorsPage> createState() => _AllDoctorsPageState();
}

class _AllDoctorsPageState extends State<AllDoctorsPage> {
  Hospital? hospital = DataManager.getInstance().hospital;
  HospitalService? service = DataManager.getInstance().service;
  var userData = PreferenceUtils.getPreference(Constants.userData, null);
  User? user;

  @override
  void initState() {
    if (userData != null) {
      user = User.fromMap(jsonDecode(userData));
    }
    SchedulerBinding.instance.addPostFrameCallback(
      (_) => Provider.of<HomeProvider>(context, listen: false)
          .getDoctors("${service?.id}"),
    );
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          title: Row(
            children: [
              Icon(
                FontAwesome.hospital_o,
                color: Theme.of(context).colorScheme.secondary,
              ),
              const SizedBox(
                width: 5,
              ),
              Expanded(
                  child: Text(
                "${hospital?.name}",
                style: TextStyle(color: Theme.of(context).colorScheme.secondary),
              )),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Consumer<HomeProvider>(builder: (context, provider, _) {
          if (provider.apiRequestStatus == APIRequestStatus.loading) {
            return ListItemHelper(
              divHeight: 0.11,
              isGrid: Grid(),
            );
          } else {
            return _doctorList(provider.doctors);
          }
        }),
      ),
    );
  }

  Widget _doctorList(List<Doctor> docs) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: docs.length,
      itemBuilder: (BuildContext context, int itemIndex) => GestureDetector(
        onTap: () {
          if (userData == null) {
            context.push('/${RouterPath.authentication}',
                extra: '/${RouterPath.doctors}');
          } else {
            context.push('/${RouterPath.doctorDetails}',
                extra: docs[itemIndex]);
          }
        },
        child: Container(
          color: Colors.white.withOpacity(0.4),
          margin: const EdgeInsets.symmetric(vertical: 2),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              radius: 18,
              child: const Icon(
                FontAwesome.user_md,
                color: Colors.white,
              ),
            ),
            title: Text(
              "${docs[itemIndex].firstName} ${docs[itemIndex].lastName}",
              style: const TextStyle(letterSpacing: 1, fontSize: 18),
            ),
            subtitle: Text(
              "${docs[itemIndex].speciality}",
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
            trailing: const Icon(Icons.keyboard_arrow_right),
          ),
        ),
      ),
    );
  }
}
