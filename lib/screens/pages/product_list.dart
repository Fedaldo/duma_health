import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:duma_health/models/cart_product.dart';
import 'package:duma_health/models/product.dart';
import 'package:duma_health/services/cart_provider.dart';
import 'package:duma_health/utils/constants.dart';
import 'package:duma_health/utils/enumeration.dart';
import 'package:duma_health/utils/functions.dart';
import 'package:duma_health/utils/utils.dart';
import 'package:duma_health/widgets/loading_helper.dart';
import 'package:duma_health/widgets/stepper.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ProductList extends StatelessWidget {
  final List<Product> products;

  const ProductList({Key? key, required this.products}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: _buildProductsList(products: products, size: size),
    );
  }

  Widget _buildProductsList(
      {required List<Product> products, required Size size}) {
    return GridView.builder(
      padding: const EdgeInsets.all(0),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 5.0,
        childAspectRatio: 0.7,
        mainAxisSpacing: 10.0,
      ),
      itemCount: products.length,
      itemBuilder: (BuildContext context, int itemIndex) {
        return ProductCard(
          product: products[itemIndex],
        );
      },
    );
  }
}

class ProductCard extends StatefulWidget {
  final Product product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  ProductCardState createState() => ProductCardState();
}

class ProductCardState extends State<ProductCard> {
  int qty = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 0.1),
        borderRadius: const BorderRadius.all(
          Radius.circular(5),
        ),
        color: Colors.white.withOpacity(0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                context.push('/${RouterPath.productDetails}',
                    extra: widget.product);
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(5),
                ),
                child: Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: "${Constants.imagePath}${widget.product.image}",
                      placeholder: (context, n) {
                        return LoadingHelper(
                          width: size.width,
                          height: size.height,
                        );
                      },
                      errorWidget: (BuildContext context, index, n) {
                        return Image.asset(
                          "assets/logo.png",
                          width: size.width,
                          height: size.height,
                          fit: BoxFit.cover,
                        );
                      },
                      width: size.width,
                      height: size.height,
                      fit: BoxFit.cover,
                    ),
                    !widget.product.prescription
                        ? const SizedBox()
                        : Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              color: Colors.red,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              child: const Text(
                                "Prescription",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 12, color: Colors.white),
                              ),
                            ),
                          ),
                    widget.product.regularPrice! == widget.product.price!
                        ? const SizedBox()
                        : Container(
                            color: Colors.blue,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 2),
                            child: Text(
                              "${AppFunctions.getPercentage(int.parse(widget.product.regularPrice!), int.parse(widget.product.price!))}%\nOFF",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 10, color: Colors.white),
                            ),
                          ),
                    widget.product.quantity != "0"
                        ? const SizedBox()
                        : Positioned(
                            right: 0,
                            child: Container(
                              color: Colors.red,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 2),
                              child: const Text(
                                "Out of Stock",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 13, color: Colors.white),
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "${widget.product.name}".toLowerCase(),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              letterSpacing: 1,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Expanded(
                child: AutoSizeText(
                  "Fbu ${Utils.formatPrice(widget.product.price!)}",
                  maxLines: 1,
                  minFontSize: 15,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary),
                ),
              ),
              const SizedBox(
                width: 2,
              ),
              Visibility(
                visible: widget.product.regularPrice == widget.product.price
                    ? false
                    : true,
                child: Expanded(
                  child: AutoSizeText(
                    "Fbu ${Utils.formatPrice(widget.product.regularPrice!)}",
                    maxLines: 1,
                    minFontSize: 15,
                    style: const TextStyle(
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Visibility(
                visible: qty >= 1,
                child: AddStepper(
                    lowerLimit: 0,
                    upperLimit: int.parse(widget.product.quantity!),
                    stepValue: 1,
                    iconSize: 20.0,
                    value: qty,
                    onChanged: (value) {
                      setState(() {
                        qty = value;
                        if (value < 1) {
                          Provider.of<CartProvider>(context,
                              listen: false)
                              .removeToCart(int.parse(
                              widget.product.id!));
                        } else {
                          Provider.of<CartProvider>(context,
                              listen: false)
                              .addToCart(
                            CartProduct(
                              id: int.parse(
                                  widget.product.id!),
                              name: widget.product.name!,
                              price: widget.product.price!,
                              regularPrice: widget
                                  .product.regularPrice,
                              stockQuantity: int.parse(
                                  widget.product.quantity!),
                              qty: qty,
                              total: AppFunctions
                                  .calculateItemTotal(
                                  price: widget
                                      .product.price!,
                                  q: qty),
                              phId: widget
                                  .product.idPharmacy!,
                            ),
                          );
                        }
                      });
                    }),
              ),
              Visibility(
                visible: qty == 0,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Theme.of(context).colorScheme.secondary,
                        width: 0.1),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(5),
                    ),
                  ),
                  child: IconButton(
                    color: Theme.of(context).colorScheme.secondary,
                    onPressed: () {
                      if (!widget.product.prescription &&
                          widget.product.quantity != "0") {
                        setState(() {
                          qty = 1;
                          Provider.of<CartProvider>(context, listen: false)
                              .addToCart(
                            CartProduct(
                              phId: widget.product.idPharmacy!,
                              id: int.parse(widget.product.id!),
                              name: widget.product.name!,
                              price: widget.product.price!,
                              regularPrice: widget.product.regularPrice,
                              stockQuantity:
                                  int.parse(widget.product.quantity!),
                              qty: qty,
                              total: AppFunctions.calculateItemTotal(
                                  price: widget.product.price!, q: qty),
                            ),
                          );
                        });
                      } else {
                        context.push('/${RouterPath.productDetails}',
                            extra: widget.product);
                      }
                    },
                    icon: const Icon(Icons.add),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
