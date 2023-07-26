import 'dart:convert';

import 'package:duma_health/afripay/afripay_client.dart';
import 'package:duma_health/afripay/afripay_client_builder.dart';
import 'package:duma_health/afripay/afripay_constants.dart';
import 'package:duma_health/models/user.dart';
import 'package:duma_health/screens/main.dart';
import 'package:duma_health/screens/pages/search.dart';
import 'package:duma_health/services/provider.dart';
import 'package:duma_health/utils/constants.dart';
import 'package:duma_health/utils/preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AppFunctions {
  static int calculateItemTotal({required String price, required int q}) {
    int p = int.parse(price);
    int res = p * q;
    return res;
  }

  static String getPercentage(int price, int newPrice) {
    double r = (100 * newPrice) / price;
    double pr = 100 - r;
    int res = pr.toInt();
    return res.toString();
  }

  static void payWithAfripay(
    BuildContext context, {
    required String orderId,
    required String orderReference,
    required String amount,
  }) {
    AfripayClient? afripayClient = AfripayClientBuilder.newBuilder()
        .setAppId(AfripayConstants.appId)
        .setAppSecret(AfripayConstants.appSecret)
        .setToken(orderReference)
        .setAppReturnUrl(AfripayConstants.appReturnUrl)
        .build();
    afripayClient!.launch(context,
        purchaseData: buildPurchaseData(amount), orderId: orderId);
  }

  static String buildPurchaseData(String amount) {
    StringBuffer builder = StringBuffer();
    builder.write("amount=$amount");
    builder.write("&currency=BIF");
    return builder.toString();
  }

  static Future logOut(BuildContext context) async {
    Provider.of<AppointmentProvider>(context, listen: false)
        .getAppointments(userId: null);
    Provider.of<OrderProvider>(context, listen: false)
        .getOrders(userId: null);
    PreferenceUtils.setPreference(Constants.userData, null);
    Provider.of<HomeProvider>(context, listen: false).setUserDetails(null);
    MainScreen.setCurrentTab(context, 0);
    context.go('/');
  }

  static Future authenticate(
    BuildContext context, {
    required User value,
    required String nextPath,
  }) async {
    PreferenceUtils.setPreference(
      Constants.userData,
      jsonEncode(
        value.toMap(),
      ),
    );
    Provider.of<HomeProvider>(context, listen: false)
        .setUserDetails(jsonEncode(value.toMap()));
    SchedulerBinding.instance.addPostFrameCallback(
          (_) => Provider.of<AppointmentProvider>(context, listen: false)
          .getAppointments(userId: "${value.id}"),
    );
    SchedulerBinding.instance.addPostFrameCallback(
          (_) => Provider.of<OrderProvider>(context, listen: false)
          .getOrders(userId: "${value.id}"),
    );
    context.go(nextPath);
  }

  static void displaySearch(
    BuildContext context,
  ) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white.withOpacity(0.9),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(10),
          ),
        ),
        builder: (context) {
          return const SearchPage();
        });
  }

}
