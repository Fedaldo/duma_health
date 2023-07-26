import 'dart:convert';

import 'package:duma_health/models/user.dart';
import 'package:duma_health/services/provider.dart';
import 'package:duma_health/utils/constants.dart';
import 'package:duma_health/utils/enumeration.dart';
import 'package:duma_health/utils/functions.dart';
import 'package:duma_health/utils/preferences.dart';
import 'package:duma_health/widgets/bg_custom_paint.dart';
import 'package:duma_health/widgets/dialogs_pop.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  dynamic userData;

  @override
  void initState() {
    userData = PreferenceUtils.getPreference(Constants.userData, null);
    SchedulerBinding.instance.addPostFrameCallback(
      (_) => Provider.of<HomeProvider>(context, listen: false)
          .setUserDetails(userData),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CustomPaint(
          size: Size(width, (width * 0.5).toDouble()),
          painter: BgCustomPainter(),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: SafeArea(
              child: Consumer<HomeProvider>(
                builder: (context, provider, _) {
                  return Column(
                    children: [
                      const SizedBox(
                        height: 50,
                      ),
                      Column(
                        children: [
                          CircleAvatar(
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .secondary
                                .withOpacity(0.9),
                            radius: 40,
                            child: const Icon(
                              Ionicons.person,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          userDetails(provider),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Visibility(
                        visible: provider.uDetails != null,
                        child: _conSettingTile(
                          title: "Account",
                          width: width,
                          child: Column(
                            children: [
                              _settingTile(
                                onTap: () {
                                  context.go('/${RouterPath.profile}');
                                },
                                title: "Edit Profile",
                                icon: Ionicons.person_outline,
                              ),
                              _settingTile(
                                onTap: () {
                                  context.go('/${RouterPath.notifications}');
                                },
                                title: "Notifications",
                                icon: Ionicons.notifications_outline,
                              ),
                            ],
                          ),
                        ),
                      ),
                      _conSettingTile(
                        width: width,
                        title: "Other",
                        child: Column(
                          children: [
                            _settingTile(
                                icon: Ionicons.lock_closed_outline,
                                title: "Privacy & Policy",
                                onTap: () {}),
                            _settingTile(
                                icon: Ionicons.mail_outline,
                                title: "Contact Us",
                                onTap: () {}),
                            _settingTile(
                                icon: Ionicons.help,
                                title: "Help",
                                onTap: () {}),
                            Visibility(
                              visible: provider.uDetails != null,
                              child: ListTile(
                                leading: const Icon(
                                  Ionicons.exit_outline,
                                  color: Colors.red,
                                ),
                                title: const Text(
                                  "Sign Out",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onTap: () {
                                  DialogPop.action(context,
                                      title: "Sign Out",
                                      message: "Do you want to sign out?",
                                      onConfirm: () async {
                                    await AppFunctions.logOut(context);
                                  }, confirmText: "Confirm");
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget userDetails(HomeProvider provider) {
    if (provider.uDetails != null) {
      User u = User.fromMap(jsonDecode(provider.uDetails));
      return Column(
        children: [
          Text(
            "${u.firstName} ${u.lastName}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "${u.email}",
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      );
    }
    return OutlinedButton(
      onPressed: () {
        context.go('/${RouterPath.authentication}',extra: '/');
      },
      child: const Text(
        "Sign In",
        style: TextStyle(
          letterSpacing: 2,
        ),
      ),
    );
  }

  Widget _conSettingTile(
      {required String title, required Widget child, required double width}) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              letterSpacing: 1,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          child,
        ],
      ),
    );
  }

  Widget _settingTile(
      {required Function onTap,
      required String title,
      required IconData icon}) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).colorScheme.secondary,
      ),
      title: Text(title),
      trailing: Icon(
        Icons.keyboard_arrow_right_sharp,
        color: Theme.of(context).colorScheme.secondary,
      ),
      onTap: () => onTap(),
    );
  }
}
