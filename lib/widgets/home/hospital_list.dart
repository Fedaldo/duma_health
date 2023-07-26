import 'package:auto_size_text/auto_size_text.dart';
import 'package:duma_health/models/hospital.dart';
import 'package:duma_health/utils/data_manager.dart';
import 'package:duma_health/utils/enumeration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:go_router/go_router.dart';

Widget hospitalList(List<Hospital> hospitals) {
  return ListView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    padding: const EdgeInsets.symmetric(horizontal: 10,),
    itemCount: hospitals.length > 5
        ? hospitals.sublist(0, 5).length
        : hospitals.length,
    itemBuilder: (BuildContext context, int itemIndex) => Padding(
      padding: const EdgeInsets.all(3.0),
      child: HospitalCard(
        hospital: hospitals[itemIndex],
      ),
    ),
  );
}

class HospitalCard extends StatelessWidget {
  final Hospital hospital;
  final bool isAll;

  const HospitalCard({Key? key, required this.hospital, this.isAll = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        DataManager.getInstance().hospital = hospital;
        context.push("/${RouterPath.hospitalServices}", extra: hospital);
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withOpacity(0.3), width: 0.8),
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.7),
                borderRadius: BorderRadius.only(
                  topRight: const Radius.circular(10),
                  topLeft: const Radius.circular(10),
                  bottomLeft: Radius.circular(isAll ? 10 : 0),
                  bottomRight: Radius.circular(isAll ? 10 : 0),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    FontAwesome.hospital_o,
                    size: 15,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(
                      "${hospital.name}",
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).primaryColor,
                          letterSpacing: 1,
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10, 0),
              child: Column(
                children: [
                  _details(
                      icon: Ionicons.mail_outline, value: "${hospital.email}"),
                  _details(
                      icon: Ionicons.call_outline, value: "${hospital.phone}"),
                  Visibility(
                    visible: !isAll,
                    child: _details(
                        icon: Ionicons.location_outline,
                        value: "${hospital.address}"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _details({required IconData icon, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 15,
            color: Colors.black54,
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: AutoSizeText(
              value,
              maxLines: 2,
              wrapWords: false,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}