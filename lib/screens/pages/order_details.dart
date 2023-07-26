import 'package:duma_health/models/order.dart';
import 'package:duma_health/utils/data_manager.dart';
import 'package:duma_health/utils/functions.dart';
import 'package:duma_health/utils/utils.dart';
import 'package:duma_health/widgets/dialogs_pop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';

class OrderDetailsPage extends StatefulWidget {
  const OrderDetailsPage({Key? key}) : super(key: key);

  @override
  OrderDetailsPageState createState() => OrderDetailsPageState();
}

class OrderDetailsPageState extends State<OrderDetailsPage> {
  final Order? _order = DataManager.getInstance().currentOrder;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Visibility(
        visible: "${_order?.statusId}" == "1",
        child: FloatingActionButton.extended(
          onPressed: () {
            AppFunctions.payWithAfripay(context,
                amount: "${_order?.amountTotal}",
                orderId: "${_order?.id}",
                orderReference: "${_order?.reference}");
          },
          label: const Text("Pay Now"),
          icon: const Icon(Ionicons.ios_cash_outline),
        ),
      ),
      appBar: AppBar(
        titleTextStyle: TextStyle(
          fontSize: 12,
          color: Theme.of(context).primaryColor,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "#${_order!.reference}",
                    style: Theme.of(context).textTheme.labelHeading,
                  ),
                  Text("${_order!.dateCreated}"),
                ],
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            orderStatus("${_order!.statusId}"),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 5, right: 5, bottom: 50),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.3),
                  ),
                ),
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Deliver To",
                              style: Theme.of(context).textTheme.labelHeading,
                            ),
                            Text(
                                "${_order!.shipping.firstName} ${_order!.shipping.lastName!.toUpperCase()}"),
                            Text("${_order!.shipping.district}"),
                            Text("${_order!.shipping.city} Burundi"),
                          ],
                        ),
                        deliveryStatus("2")
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Visibility(
                      visible: _order!.shipping.note != null,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Notes",
                            style: Theme.of(context).textTheme.labelHeading,
                          ),
                          Text("${_order!.shipping.note}"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Items",
                style: Theme.of(context).textTheme.labelHeading,
              ),
              const Divider(),
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: _listOrderItems(),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              _itemTotal(
                label: "SubTotal",
                subtitle: _order!.products.length > 1
                    ? "(${_order!.products.length} Items)"
                    : "(${_order!.products.length} Item)",
                value: "${_order!.itemsTotal}",
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 17),
              ),
              _itemTotal(
                label: "Delivery Fees",
                value: "${_order!.deliveryFees}",
              ),
              _order!.insurance == null
                  ? const SizedBox()
                  : _itemTotal(
                      label: "Insurance Discount",
                      isDiscount: true,
                      value: "${_order?.insurance?.amount}",
                      subtitle: "(${_order!.insurance!.percentage} %)",
                    ),
              _itemTotal(
                label: "Total",
                value: "${_order?.amountTotal}",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
              const SizedBox(
                height: 100,
              )
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
          width: 2,
        ),
        Text(
          text,
          style: TextStyle(fontSize: 12, color: color),
        ),
      ],
    );
  }

  Widget deliveryStatus(String status) {
    Color color;
    String text;
    switch (status) {
      case "2":
        color = Colors.grey;
        text = "Pending";
        break;
      case "4":
        color = Colors.blue;
        text = "Accepted";
        break;
      case "5":
        color = Colors.blue;
        text = "Preparing";
        break;
      case "6":
        color = Colors.black;
        text = "Picked";
        break;
      case "7":
        color = Colors.green;
        text = "Delivered";
        break;
      default:
        color = Colors.redAccent;
        text = "Canceled";
        break;
    }
    return Column(
      children: [
        Text(
          "Delivery Status",
          style: Theme.of(context).textTheme.labelHeading,
        ),
        Text(
          text.toUpperCase(),
          style: TextStyle(fontSize: 13, color: color),
        ),
      ],
    );
  }

  Widget _listOrderItems() {
    return ListView.builder(
        itemCount: _order!.products.length,
        physics: const ScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return _productItem(_order!.products[index]);
        });
  }

  Widget _productItem(OrderProduct product) {
    return Row(
      children: [
        product.prescription == ""
            ? const Icon(Icons.medication_liquid)
            : InkWell(
                onTap: () {
                  DialogPop.showPrescription(context,
                      image: product.prescription!);
                },
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue,
                  ),
                  padding: const EdgeInsets.all(5),
                  child: const Icon(
                    AntDesign.file1,
                    color: Colors.white,
                  ),
                ),
              ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: ListTile(
            dense: true,
            contentPadding: const EdgeInsets.all(2),
            title: Text(
              "${product.name}",
            ),
            subtitle: Padding(
              padding: const EdgeInsets.all(1),
              child: Text(
                "X ${product.quantity}",
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            trailing: Text(
              "FBU ${Utils.formatPrice("${product.price}")}",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _itemTotal(
      {required String label,
      required String value,
      TextStyle? style,
      bool isDiscount = false,
      String subtitle = ''}) {
    return ListTile(
      visualDensity: const VisualDensity(horizontal: 0, vertical: -3),
      contentPadding: EdgeInsets.zero,
      dense: true,
      title: Text(label),
      subtitle: Text(subtitle),
      trailing: Text(
        isDiscount
            ? "- FBU ${Utils.formatPrice(value)}"
            : "FBU ${Utils.formatPrice(value)}",
        style: style,
      ),
    );
  }
}

extension CustomStyles on TextTheme {
  TextStyle get labelHeading {
    return const TextStyle(color: Colors.black, fontWeight: FontWeight.bold);
  }
}
