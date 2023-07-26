import 'dart:convert';

import 'package:duma_health/models/cart_product.dart';
import 'package:duma_health/models/insurance.dart';
import 'package:duma_health/models/shipping_details.dart';
import 'package:duma_health/models/user.dart';
import 'package:duma_health/screens/checkout/checkout.dart';
import 'package:duma_health/services/api.dart';
import 'package:duma_health/services/cart_provider.dart';
import 'package:duma_health/services/provider.dart';
import 'package:duma_health/utils/constants.dart';
import 'package:duma_health/utils/data_manager.dart';
import 'package:duma_health/utils/functions.dart';
import 'package:duma_health/utils/preferences.dart';
import 'package:duma_health/utils/utils.dart';
import 'package:duma_health/widgets/form_helper.dart';
import 'package:duma_health/widgets/insurances_wrap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class OrderSummaryPage extends StatefulWidget {
  const OrderSummaryPage({Key? key}) : super(key: key);

  @override
  State<OrderSummaryPage> createState() => _OrderSummaryPageState();
}

class _OrderSummaryPageState extends State<OrderSummaryPage> {
  final int _shipping = 2000;
  int _total = 0;
  var userData = PreferenceUtils.getPreference(Constants.userData, null);
  User? user;
  bool _isLoading = false;

  @override
  void initState() {
    if (userData != null) {
      user = User.fromMap(jsonDecode(userData));
    }
    super.initState();
  }

  @override
  void deactivate() {
    Provider.of<CartProvider>(context, listen: false).percentage = "0";
    Provider.of<CartProvider>(context, listen: false).discount = 0;
    super.deactivate();
  }

  void _setTotal() {
    int sum = Provider.of<CartProvider>(context).totalAmount;
    double discount = Provider.of<CartProvider>(context).discount;
    setState(() {
      _total = (sum + _shipping) - discount.toInt();
    });
  }

  @override
  Widget build(BuildContext context) {
    _setTotal();
    if (_isLoading) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.3,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SpinKitCircle(
              size: 80,
              color: Theme.of(context).primaryColor,
            ),
            Icon(
              Icons.medication_liquid,
              color: Theme.of(context).primaryColor,
            ),
          ],
        ),
      );
    } else {
      return Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Consumer<CartProvider>(
                      builder: (_, provider, child) {
                        return _buildProducts(provider.allCartProducts);
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Consumer<HomeProvider>(
                      builder: (context, provider, _) {
                        return InsurancesGrid(
                          insurances: provider.insurances,
                        );
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Card(
            elevation: 20,
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Consumer<CartProvider>(builder: (context, provider, _) {
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Items Total",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Fbu ${Utils.formatPrice("${provider.totalAmount}")}",
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Visibility(
                          visible: provider.discount != 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Consumer<CartProvider>(
                                    builder: (context, provider, _) {
                                      return RichText(
                                        text: TextSpan(
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            children: [
                                              const TextSpan(
                                                  text: "Insurance Discount "),
                                              TextSpan(
                                                text:
                                                    "(${provider.percentage} %)",
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ]),
                                      );
                                    },
                                  ),
                                  Consumer<HomeProvider>(
                                    builder: (context, provider, _) {
                                      return Text(
                                        '(${provider.insurances.firstWhere((element) => element.isSelected).name})',
                                        style: const TextStyle(fontSize: 12),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              Text(
                                "- Fbu ${Utils.formatPrice(provider.discount.toString())}",
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
                  const SizedBox(
                    height: 3,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Delivery Fees",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Fbu ${Utils.formatPrice(_shipping.toString())}",
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Fbu ${Utils.formatPrice(_total.toString())}",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: FormHelper.backButton(
                          context,
                          onTap: () {
                            CheckoutPageState.controller.previousPage(
                                duration: const Duration(seconds: 1),
                                curve: Curves.bounceIn);
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: FormHelper.checkoutButton(
                          context,
                          buttonText: 'Confirm',
                          onTap: () {
                            if (_validatePage()) {
                              _createOrder();
                            } else {
                              const snackBar = SnackBar(
                                backgroundColor: Colors.red,
                                content: Text(
                                  "Fill the percentage field!",
                                ),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          },
                          icon: Icons.keyboard_arrow_right,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }
  }

  bool _validatePage() {
    if (Provider.of<HomeProvider>(context, listen: false)
            .insurances
            .where((element) => element.isSelected == true)
            .toList()
            .isEmpty &&
        Provider.of<CartProvider>(context, listen: false).discount == 0) {
      return true;
    } else {
      if (Provider.of<HomeProvider>(context, listen: false)
          .insurances
          .where((element) => element.isSelected == true)
          .toList()
          .isNotEmpty &&
          Provider.of<CartProvider>(context, listen: false).discount != 0) {
        return true;
      } else {
        return false;
      }
    }
  }

  Widget _buildProducts(List products) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      primary: false,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length + 1,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Products',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Subtotal',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Divider(),
            ],
          );
        }
        index -= 1;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: RichText(
                  text: TextSpan(
                      style:
                          const TextStyle(color: Colors.black87, fontSize: 12),
                      children: [
                        TextSpan(text: "${products[index].name}"),
                        TextSpan(
                          text: " X ${products[index].qty}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor),
                        ),
                      ]),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Text(
                "Fbu ${Utils.formatPrice(products[index].total.toString())}",
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  _createOrder() async {
    setState(() {
      _isLoading = true;
    });
    ShippingDetails? shippingDetails =
        DataManager.getInstance().shippingDetails;

    dynamic dataS = <String, dynamic>{};

    dynamic jsonObject = <String, dynamic>{};
    jsonObject["shipping_first_name"] = shippingDetails?.firstName;
    jsonObject["shipping_last_name"] = shippingDetails?.lastName;
    jsonObject["shipping_country"] = shippingDetails?.country;
    jsonObject["shipping_city"] = shippingDetails?.city;
    jsonObject["shipping_district"] = shippingDetails?.streetName;
    jsonObject["shipping_note"] = "${shippingDetails?.note}";

    dataS["shipping_address"] = jsonObject;

    dynamic jsonObject2 = <String, dynamic>{};
    jsonObject2["user_id"] = "${user!.id}";
    jsonObject2["payment_method_id"] = "1";
    jsonObject2["currency_id"] = "1";
    jsonObject2["items_total"] =
        "${Provider.of<CartProvider>(context, listen: false).totalAmount}";
    jsonObject2["shipping_fees"] = "$_shipping";
    jsonObject2["amount_total"] = "$_total";

    jsonObject2["different_sellers"] =
        "${Provider.of<CartProvider>(context, listen: false).isFromMultipleSellers()}";

    dataS["meta"] = jsonObject2;

    List<Insurance> selected = Provider.of<HomeProvider>(context, listen: false)
        .insurances
        .where((element) => element.isSelected == true).toList();

    if (selected.isNotEmpty) {
      dynamic jsonObject3 = <String, dynamic>{};
      jsonObject3["id"] = "${selected[0].id}";
      jsonObject3["percentage"] =
          Provider.of<CartProvider>(context, listen: false).percentage;
      jsonObject3["amount"] =
          "${Provider.of<CartProvider>(context, listen: false).discount}";
      dataS["insurance"] = jsonObject3;
    }

    List<dynamic> products = [];
    List<CartProduct> prods =
        Provider.of<CartProvider>(context, listen: false).allCartProducts;
    if (prods.isNotEmpty) {
      for (int i = 0; i < prods.length; i++) {
        dynamic jsonObject = <String, dynamic>{};
        jsonObject["pharmacy_id"] = prods[i].phId;
        jsonObject["medicament_id"] = "${prods[i].id}";
        jsonObject["quantity"] = "${prods[i].qty}";
        jsonObject["price"] = "${prods[i].total}";
        jsonObject["prescription"] = "${prods[i].prescription}";
        products.add(jsonObject);
      }
    }
    dataS["products"] = products;

    await Api.
    createOrder(json.encode(dataS)).then((value) {
      setState(() {
        _isLoading = false;
      });
      if (value != null) {
        Provider.of<OrderProvider>(context, listen: false)
            .getOrders(userId: "${user?.id}");
        AppFunctions.payWithAfripay(context,
            amount: '$_total',
            orderId: "${value.id}",
            orderReference: "${value.reference}");
      } else {
        Fluttertoast.showToast(
            msg: "Something wrong happen. Try again later.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 5,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 17.0);
      }
    });
  }
}
