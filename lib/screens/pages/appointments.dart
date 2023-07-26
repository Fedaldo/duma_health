import 'package:duma_health/models/grid.dart';
import 'package:duma_health/services/provider.dart';
import 'package:duma_health/utils/enumeration.dart';
import 'package:duma_health/widgets/drop_sort.dart';
import 'package:duma_health/widgets/empty_page.dart';
import 'package:duma_health/widgets/home/recent_appoints_list.dart';
import 'package:duma_health/widgets/loading_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AppointmentsPage extends StatefulWidget {
  const AppointmentsPage({Key? key}) : super(key: key);

  @override
  State<AppointmentsPage> createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppointmentProvider>(builder: (context, provider, _) {
      if (provider.apiRequestStatus == APIRequestStatus.loading) {
        return ListItemHelper(
          divHeight: 0.15,
          isGrid: Grid(),
        );
      } else {
        return _appointsList(provider);
      }
    });
  }

  Widget _appointsList(AppointmentProvider provider) {
    if (provider.appointments.isEmpty) {
      return EmptyPage(
        icon: Ionicons.calendar_sharp,
        title: "Book an appointment",
        subTitle: "In one of the best local hospitals",
        onTap: () {
          context.go('/${RouterPath.allHospitals}');
        },
      );
    }
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            title: const Text(
              "Appointments",
              style: TextStyle(
                letterSpacing: 2,
              ),
            ),
            actions: [
              Visibility(
                visible: provider.appointments.isNotEmpty,
                child: PopSortAppointment(
                  onChanged: (sortBy) => onSortValue(sortBy),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                itemCount: provider.appointments.length,
                itemBuilder: (BuildContext context, int itemIndex) =>
                    AppointmentCard(
                  appointment: provider.appointments[itemIndex],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  void onSortValue(value) {
    if (value?.id == 2) {
      Provider.of<AppointmentProvider>(context, listen: false).sortByDisDate();
    } else if (value?.id == 3) {
      Provider.of<AppointmentProvider>(context, listen: false).sortByDoctor();
    } else {
      Provider.of<AppointmentProvider>(context, listen: false).sortByInDate();
    }
  }
}
