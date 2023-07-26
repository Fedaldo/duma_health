import 'dart:convert';
import 'package:duma_health/models/grid.dart';
import 'package:duma_health/models/user.dart';
import 'package:duma_health/services/provider.dart';
import 'package:duma_health/utils/constants.dart';
import 'package:duma_health/utils/enumeration.dart';
import 'package:duma_health/utils/functions.dart';
import 'package:duma_health/utils/preferences.dart';
import 'package:duma_health/widgets/home/category_list.dart';
import 'package:duma_health/widgets/home/hospital_list.dart';
import 'package:duma_health/widgets/home/recent_appoints_list.dart';
import 'package:duma_health/widgets/icon_cart.dart';
import 'package:duma_health/widgets/loading_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var userData = PreferenceUtils.getPreference(Constants.userData, null);
  User? user;

  @override
  void initState() {
    if (userData != null) {
      user = User.fromMap(jsonDecode(userData));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            backgroundColor: Theme.of(context).primaryColor,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
              ),
            ),
            title: ClipOval(
              child: Image.asset(
                'assets/logo.png',
                width: 40,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  context.push('/${RouterPath.cart}');
                },
                icon: iconCart(Colors.red),
              ),
              IconButton(
                onPressed: () {
                  AppFunctions.displaySearch(context);
                },
                icon: const Icon(
                  Ionicons.search,
                  color: Colors.white,
                ),
              ),
              Consumer<HomeProvider>(builder: (context, provider, _) {
                return Visibility(
                  visible: provider.uDetails != null,
                  child: IconButton(
                    onPressed: () {
                      context.go('/${RouterPath.notifications}');
                    },
                    icon: const Icon(
                      Icons.notifications,
                      color: Colors.white,
                    ),
                  ),
                );
              }),
              const SizedBox(
                width: 5,
              ),
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                homeTitle(
                    icon: Ionicons.grid_outline,
                    title: "Categories",
                    onTap: () {
                      context.go('/${RouterPath.categories}');
                    }),
                Consumer<CategoryProvider>(builder: (context, provider, _) {
                  if (provider.apiRequestStatus == APIRequestStatus.loading) {
                    return ListItemHelper(
                      divHeight: 0.5,
                      isGrid: Grid(it: true, height: 80, row: 4),
                    );
                  } else {
                    return CategoryList(
                        categories: provider.categories.isEmpty
                            ? provider.categories
                            : provider.categories.sublist(0, 12));
                  }
                }),
                homeTitle(
                    icon: FontAwesome.hospital_o,
                    title: "Hospitals",
                    onTap: () {
                      context.go('/${RouterPath.allHospitals}');
                    }),
                Consumer<HomeProvider>(builder: (context, provider, _) {
                  if (provider.apiRequestStatus == APIRequestStatus.loading) {
                    return ListItemHelper(
                      divHeight: 0.15,
                      isGrid: Grid(),
                    );
                  } else {
                    return hospitalList(provider.hospitals);
                  }
                }),
                const SizedBox(
                  height: 10,
                ),
                homeTitle(
                    icon: Ionicons.calendar,
                    title: "Recent Appointments",
                    visibleMore: false,
                    onTap: () {}),
                const SizedBox(
                  height: 10,
                ),
                Consumer<AppointmentProvider>(builder: (context, provider, _) {
                  if (provider.apiRequestStatus == APIRequestStatus.loading) {
                    return ListItemHelper(
                      divHeight: 0.15,
                      isGrid: Grid(),
                    );
                  } else {
                    return recentAppointsList(context, provider.appointments);
                  }
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget homeTitle(
      {required IconData icon,
      bool visibleMore = true,
      bool header = false,
      required String title,
      required Function onTap}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 5, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible: !header,
                  child: Row(
                    children: [
                      Icon(
                        icon,
                        size: 15,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      fontSize: header ? 17 : 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: visibleMore,
            child: TextButton(
              onPressed: () => onTap(),
              child: Text(
                "see more",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  decoration: TextDecoration.underline,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
