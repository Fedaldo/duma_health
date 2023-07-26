import 'package:duma_health/screens/checkout/order_summary.dart';
import 'package:duma_health/screens/checkout/shipping.dart';
import 'package:duma_health/widgets/checkout_points.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({Key? key}) : super(key: key);

  @override
  State<CheckoutPage> createState() => CheckoutPageState();
}

class CheckoutPageState extends State<CheckoutPage> {
  static int currentPage = 0;
  static PageController controller = PageController();

  @override
  void initState() {
    currentPage = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout"),
      ),
      body: Column(
        children: [
          CheckPoints(
            checkedTill: currentPage,
            checkpoints: _checkPoints(),
            checkPointFilledColor: Theme.of(context).primaryColor,
          ),
          Expanded(
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: controller,
              onPageChanged: (cP) {
                setState(() {
                  currentPage = cP;
                });
              },
              children: const [
                ShippingPage(),
                OrderSummaryPage(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<CheckPoint> _checkPoints() {
    List<CheckPoint> cks = [
      CheckPoint(title: "Shipping Details", iconData: Entypo.box),
      CheckPoint(title: "Order Summary", iconData: Icons.medication_liquid),
    ];
    return cks;
  }
}
