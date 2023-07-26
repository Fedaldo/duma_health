import 'dart:convert';

import 'package:duma_health/models/user.dart';
import 'package:duma_health/utils/constants.dart';
import 'package:duma_health/utils/preferences.dart';
import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
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
      appBar: AppBar(title: const Text("Notifications"),),
    );
  }
}
