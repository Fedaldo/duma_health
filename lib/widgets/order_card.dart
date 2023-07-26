import 'package:duma_health/models/order.dart';
import 'package:duma_health/utils/data_manager.dart';
import 'package:duma_health/utils/enumeration.dart';
import 'package:duma_health/utils/functions.dart';
import 'package:duma_health/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:go_router/go_router.dart';

Widget orderCard(BuildContext context, {required Order order}) {
  return GestureDetector(
    onTap: () {
      DataManager.getInstance().currentOrder = order;
      context.push("/${RouterPath.orderDetails}");
    },
    child: Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            orderStatus("${order.statusId}"),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.receipt_outlined,
                      size: 16,
                      color: "${order.statusId}" != "1"
                          ? Theme.of(context).primaryColor
                          : Colors.black54,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Order Reference",
                      style: TextStyle(
                        color: "${order.statusId}" != "1"
                            ? Theme.of(context).primaryColor
                            : Colors.black54,
                      ),
                    ),
                  ],
                ),
                Text(
                  "#${order.reference}",
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      AntDesign.clockcircleo,
                      size: 13,
                      color: "${order.statusId}" != "1"
                          ? Theme.of(context).primaryColor
                          : Colors.black54,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Date",
                      style: TextStyle(
                          color: "${order.statusId}" != "1"
                              ? Theme.of(context).primaryColor
                              : Colors.black54,
                          fontSize: 13),
                    ),
                  ],
                ),
                Text(
                  "${order.dateCreated}",
                  style: const TextStyle(fontSize: 13),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      AntDesign.wallet,
                      size: 13,
                      color: "${order.statusId}" != "1"
                          ? Theme.of(context).primaryColor
                          : Colors.black54,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Amount",
                      style: TextStyle(
                          color: "${order.statusId}" != "1"
                              ? Theme.of(context).primaryColor
                              : Colors.black54,
                          fontSize: 13),
                    ),
                  ],
                ),
                Text(
                  "Fbu ${Utils.formatPrice("${order.amountTotal}")}",
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.secondary),
                )
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Widget orderStatus(String status) {
  Icon icon;
  Color color;
  String text;
  switch (status) {
    case "2":
      icon = const Icon(
        Icons.check,
        color: Colors.green,
      );
      color = Colors.green;
      text = "Paid";
      break;
    case "3":
      icon = const Icon(
        Icons.clear,
        color: Colors.redAccent,
      );
      color = Colors.redAccent;
      text = "Canceled";
      break;
    default:
      icon = const Icon(
        Icons.hourglass_top_outlined,
        color: Colors.grey,
      );
      color = Colors.grey;
      text = "Pending Payment";
      break;
  }
  return Row(
    children: [
      icon,
      const SizedBox(
        width: 10,
      ),
      Text(
        text,
        style: TextStyle(fontSize: 15, color: color),
      ),
    ],
  );
}
