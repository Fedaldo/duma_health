import 'package:duma_health/services/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:provider/provider.dart';

Widget iconCart(Color color) {
  return Consumer<CartProvider>(builder: (context, provider, _) {
    return Stack(
      children: [
        const Icon(
          AntDesign.shoppingcart,
          color: Colors.white,
        ),
        Visibility(
          visible: provider.getItemsLength() != 0,
          child: Container(
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            padding: const EdgeInsets.all(3),
            child: Text(
              "${provider.getItemsLength()}",
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  });
}
