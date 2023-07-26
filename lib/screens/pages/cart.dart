import 'dart:convert';

import 'package:duma_health/afripay/afripay_pop_dialog.dart';
import 'package:duma_health/models/user.dart';
import 'package:duma_health/services/cart_provider.dart';
import 'package:duma_health/utils/constants.dart';
import 'package:duma_health/utils/enumeration.dart';
import 'package:duma_health/utils/preferences.dart';
import 'package:duma_health/utils/utils.dart';
import 'package:duma_health/widgets/cart_card.dart';
import 'package:duma_health/widgets/empty_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
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
      appBar: AppBar(
        title: const Text("Cart"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Consumer<CartProvider>(builder: (context, provider, _) {
                return _cartList(provider);
              }),
              /*   const SizedBox(
                height: 10,
              ),
              Text(
                "New Products",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  color: Theme.of(context).primaryColor,
                  letterSpacing: 2,
                ),
              ),
              const Divider(),
              Consumer<OrderProvider>(builder: (context, provider, _) {
                if (provider.apiRequestStatus == APIRequestStatus.loading) {
                  return ListItemHelper(
                    divHeight: 0.2,
                    isGrid: Grid(it: true, height: 120, row: 3),
                  );
                } else {
                  return ProductList(
                    products: provider.newProducts,
                  );
                }
              }),*/
            ],
          ),
        ),
      ),
      bottomNavigationBar:
          Consumer<CartProvider>(builder: (context, provider, _) {
        return _bottomCard(provider);
      }),
    );
  }

  Widget _cartList(CartProvider provider) {
    if (provider.allCartProducts.isEmpty) {
      return EmptyPage(
        icon: Ionicons.cart_sharp,
        title: "Empty Cart",
        subTitle: "Add items in the cart",
        onTap: () {
          context.go('/${RouterPath.categories}');
        },
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      primary: false,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: provider.allCartProducts.length,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return CartCard(cartProduct: provider.allCartProducts[index]);
      },
      separatorBuilder: (BuildContext context, int index) {
        return const Divider();
      },
    );
  }

  _bottomCard(CartProvider provider) {
    return Container(
      color: Theme.of(context).primaryColor,
      padding: const EdgeInsets.all(15),
      height: 90,
      child: InkWell(
        onTap: () {
         if (userData == null) {
            context.push('/${RouterPath.authentication}',
                extra: '/${RouterPath.checkout}');
          } else {
            context.push('/${RouterPath.checkout}');
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary),
                    children: [
                      TextSpan(text: "${provider.getItemsLength()} items . "),
                      TextSpan(
                        text:
                            "Fbu ${Utils.formatPrice(provider.totalAmount.toString())}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ]),
              ),
              Row(
                children: const [
                  Text(
                    "Proceed",
                    style: TextStyle(
                      letterSpacing: 1,
                    ),
                  ),
                  Icon(
                    FontAwesome.chevron_right,
                    size: 17,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
