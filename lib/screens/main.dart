import 'dart:convert';

import 'package:duma_health/models/user.dart';
import 'package:duma_health/screens/pages/appointments.dart';
import 'package:duma_health/screens/pages/home.dart';
import 'package:duma_health/screens/pages/orders.dart';
import 'package:duma_health/screens/pages/setting.dart';
import 'package:duma_health/services/provider.dart';
import 'package:duma_health/utils/constants.dart';
import 'package:duma_health/utils/enumeration.dart';
import 'package:duma_health/utils/preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  static void setCurrentTab(BuildContext context, int index) {
    _MainScreenState state =
        context.findAncestorStateOfType<_MainScreenState>()!;
    state.setCurrentTab(index);
  }

  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentTabIndex = 0;

  void setCurrentTab(int index) {
    setState(() {
      currentTabIndex = index;
    });
  }

  var userData = PreferenceUtils.getPreference(Constants.userData, null);
  User? user;
  TimeOfDay timeOfDay = TimeOfDay.now();

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback(
      (_) =>
          Provider.of<CategoryProvider>(context, listen: false).getCategories(),
    );
    SchedulerBinding.instance.addPostFrameCallback(
      (_) => Provider.of<HomeProvider>(context, listen: false).getHospitals(),
    );
    SchedulerBinding.instance.addPostFrameCallback(
      (_) => Provider.of<HomeProvider>(context, listen: false).getCountries(),
    );
    SchedulerBinding.instance.addPostFrameCallback(
      (_) => Provider.of<HomeProvider>(context, listen: false).getInsurances(),
    );
    if (userData != null) {
      user = User.fromMap(jsonDecode(userData));
    }
    SchedulerBinding.instance.addPostFrameCallback(
      (_) => Provider.of<AppointmentProvider>(context, listen: false)
          .getAppointments(userId: userData != null ? "${user!.id}" : null),
    );
    SchedulerBinding.instance.addPostFrameCallback(
      (_) => Provider.of<OrderProvider>(context, listen: false)
          .getOrders(userId: userData != null ? "${user!.id}" : null),
    );
    SchedulerBinding.instance.addPostFrameCallback(
      (_) => Provider.of<ChatProvider>(context, listen: false).getChats(
          timeOfDay.format(context).toString(),
          userId: userData != null ? "${user!.id}" : null),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentTabIndex,
        children: const [
          HomePage(),
          AppointmentsPage(),
          OrdersPage(),
          SettingPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        showUnselectedLabels: true,
        unselectedItemColor: Colors.grey[500],
        currentIndex: currentTabIndex,
        type: BottomNavigationBarType.shifting,
        onTap: (int index) {
          setState(() {
            setCurrentTab(index);
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Ionicons.grid_outline),
            activeIcon: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              radius: 25,
              child: const Icon(
                Ionicons.grid_outline,
                color: Colors.white,
              ),
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: const Icon(Ionicons.calendar_sharp),
            activeIcon: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              radius: 25,
              child: const Icon(
                Ionicons.calendar_sharp,
                color: Colors.white,
              ),
            ),
            label: "Appointments",
          ),
          BottomNavigationBarItem(
            icon: const Icon(Ionicons.receipt_outline),
            activeIcon: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              radius: 25,
              child: const Icon(
                Ionicons.receipt_outline,
                color: Colors.white,
              ),
            ),
            label: "Orders",
          ),
          BottomNavigationBarItem(
            icon: const Icon(Feather.settings),
            activeIcon: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              radius: 25,
              child: const Icon(
                Feather.settings,
                color: Colors.white,
              ),
            ),
            label: 'Settings',
          ),
        ],
      ),
      floatingActionButton:
          Consumer<HomeProvider>(builder: (context, provider, _) {
        return Visibility(
          visible: provider.uDetails != null,
          child: FloatingActionButton.extended(
            heroTag: 'cu',
            onPressed: () {
              context.go('/${RouterPath.chat}');
            },
            label: const Text("Chat with Us"),
            icon: const Icon(
              Icons.question_answer_outlined,
              color: Colors.white,
            ),
          ),
        );
      }),
    );
  }
}
