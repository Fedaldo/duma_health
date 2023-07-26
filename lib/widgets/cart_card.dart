import 'package:cached_network_image/cached_network_image.dart';
import 'package:duma_health/models/cart_product.dart';
import 'package:duma_health/services/cart_provider.dart';
import 'package:duma_health/utils/constants.dart';
import 'package:duma_health/utils/functions.dart';
import 'package:duma_health/utils/utils.dart';
import 'package:duma_health/widgets/loading_helper.dart';
import 'package:duma_health/widgets/stepper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartCard extends StatefulWidget {
  final CartProduct cartProduct;

  const CartCard({Key? key, required this.cartProduct}) : super(key: key);

  @override
  State<CartCard> createState() => _CartCardState();
}

class _CartCardState extends State<CartCard> {
  int? qt;

  @override
  void initState() {
    qt = widget.cartProduct.qty;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
          onPressed: () {
            Provider.of<CartProvider>(context, listen: false)
                .removeToCart(widget.cartProduct.id!);
          },
          icon: const Icon(
            Icons.delete,
            color: Colors.red,
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.cartProduct.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 5.0,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: "$qt X ",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                          "${Utils.formatPrice(widget.cartProduct.price)} Fbu",
                                      style: TextStyle(
                                          fontSize: 13,
                                          letterSpacing: 1,
                                          color:
                                              Theme.of(context).primaryColor),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Visibility(
                              visible: widget.cartProduct.regularPrice! ==
                                      widget.cartProduct.price
                                  ? false
                                  : true,
                              child: Expanded(
                                child: Text(
                                  "Fbu ${Utils.formatPrice(widget.cartProduct.regularPrice!)}",
                                  style: const TextStyle(
                                      fontSize: 13.0,
                                      color: Colors.grey,
                                      decoration: TextDecoration.lineThrough),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Fbu ${Utils.formatPrice("${widget.cartProduct.total}")}",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        letterSpacing: 1,
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AddStepper(
                      lowerLimit: 1,
                      upperLimit: widget.cartProduct.stockQuantity!,
                      stepValue: 1,
                      iconSize: 22.0,
                      value: qt!,
                      onChanged: (value) {
                        setState(() {
                          qt = value;
                        });
                        Provider.of<CartProvider>(context, listen: false)
                            .updateQty(widget.cartProduct, value!);
                      }),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
