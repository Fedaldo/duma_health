import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:duma_health/models/cart_product.dart';
import 'package:duma_health/services/cart_provider.dart';
import 'package:duma_health/utils/constants.dart';
import 'package:duma_health/utils/enumeration.dart';
import 'package:duma_health/utils/functions.dart';
import 'package:duma_health/utils/utils.dart';
import 'package:duma_health/widgets/dialogs_pop.dart';
import 'package:duma_health/widgets/icon_cart.dart';
import 'package:duma_health/widgets/loading_helper.dart';
import 'package:duma_health/widgets/stepper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../models/product.dart';

class ProductDetailsPage extends StatefulWidget {
  final Product product;

  const ProductDetailsPage({Key? key, required this.product}) : super(key: key);

  @override
  ProductDetailsPageState createState() => ProductDetailsPageState();
}

class ProductDetailsPageState extends State<ProductDetailsPage> {
  int qty = 0;
  File? image;
  String? base64Image;

  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;
  dynamic _pickImageError;
  String? _retrieveDataError;

  Text? _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError!);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            floating: true,
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: "${Constants.imagePath}${widget.product.image}",
                      placeholder: (context, n) {
                        return LoadingHelper(
                          width: size.width,
                          height: size.height * 0.15,
                        );
                      },
                      errorWidget: (BuildContext context, index, n) {
                        return Image.asset("assets/logo.png");
                      },
                      width: size.width,
                      height: size.height * 0.3,
                      fit: BoxFit.contain,
                    ),
                    widget.product.prescription == false
                        ? const SizedBox()
                        : Positioned(
                            top: 0,
                            left: 0,
                            child: Container(
                              color: Colors.deepOrangeAccent,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 2),
                              child: const Text(
                                "Prescription required",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                            ),
                          ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      widget.product.regularPrice! == widget.product.price!
                          ? const SizedBox()
                          : Container(
                              color: Colors.blue,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: Text(
                                "${AppFunctions.getPercentage(int.parse(widget.product.regularPrice!), int.parse(widget.product.price!))}% OFF",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 11, color: Colors.white),
                              ),
                            ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        widget.product.name!,
                        style: const TextStyle(fontSize: 18.0),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Visibility(
                                  visible: widget.product.regularPrice! ==
                                          widget.product.price!
                                      ? false
                                      : true,
                                  child: Text(
                                    "BIF ${Utils.formatPrice(widget.product.regularPrice!)}",
                                    style: const TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.grey,
                                        decoration: TextDecoration.lineThrough),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "BIF ${Utils.formatPrice(widget.product.price!)}",
                                  style: const TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 2,
                          ),
                          widget.product.quantity != "0"
                              ? Expanded(
                                  flex: 2,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Visibility(
                                        visible: qty >= 1,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: AddStepper(
                                              lowerLimit: 0,
                                              upperLimit: int.parse(
                                                  widget.product.quantity!),
                                              stepValue: 1,
                                              iconSize: 22.0,
                                              value: qty,
                                              onChanged: (value) {
                                                setState(() {
                                                  qty = value;
                                                  if (value < 1) {
                                                    Provider.of<CartProvider>(
                                                            context,
                                                            listen: false)
                                                        .removeToCart(
                                                            widget.product.id);
                                                  } else {
                                                    Provider.of<CartProvider>(
                                                            context,
                                                            listen: false)
                                                        .addToCart(
                                                      CartProduct(
                                                        id: widget.product.id,
                                                        name: widget
                                                            .product.name!,
                                                        price: widget
                                                            .product.price!,
                                                        regularPrice: widget
                                                            .product
                                                            .regularPrice,
                                                        stockQuantity:
                                                            int.parse(widget
                                                                .product
                                                                .quantity!),
                                                        qty: qty,
                                                        total: AppFunctions
                                                            .calculateItemTotal(
                                                                price: widget
                                                                    .product
                                                                    .price!,
                                                                q: qty),
                                                        phId: widget.product
                                                            .idPharmacy!,
                                                        prescription:
                                                            base64Image,
                                                      ),
                                                    );
                                                  }
                                                });
                                              }),
                                        ),
                                      ),
                                      base64Image != null ||
                                              widget.product.prescription ==
                                                  false
                                          ? Visibility(
                                              visible: qty == 0,
                                              child: TextButton(
                                                onPressed: () {
                                                  if (widget.product
                                                              .prescription ==
                                                          false ||
                                                      base64Image != null) {
                                                    setState(() {
                                                      qty = 1;
                                                      Provider.of<CartProvider>(
                                                              context,
                                                              listen: false)
                                                          .addToCart(
                                                        CartProduct(
                                                          phId: widget.product
                                                              .idPharmacy!,
                                                          id: widget
                                                              .product.id!,
                                                          name: widget
                                                              .product.name!,
                                                          price: widget
                                                              .product.price!,
                                                          regularPrice: widget
                                                              .product
                                                              .regularPrice,
                                                          stockQuantity:
                                                              int.parse(widget
                                                                  .product
                                                                  .quantity!),
                                                          qty: qty,
                                                          total: AppFunctions
                                                              .calculateItemTotal(
                                                                  price: widget
                                                                      .product
                                                                      .price!,
                                                                  q: qty),
                                                          prescription:
                                                              base64Image,
                                                        ),
                                                      );
                                                    });
                                                  }
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 10,
                                                      horizontal: 20),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .secondary,
                                                  ),
                                                  child: const Text(
                                                    "Add To Cart",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            )
                                          : const SizedBox(),
                                    ],
                                  ),
                                )
                              : const SizedBox(),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      widget.product.quantity != "0"
                          ? Text(
                              "${widget.product.quantity ?? ''} In Stock",
                              style: const TextStyle(
                                  color: Colors.green, fontSize: 15),
                            )
                          : const Text(
                              "Out of Stock",
                              style: TextStyle(color: Colors.red, fontSize: 15),
                            ),
                      widget.product.prescription != false
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Medical Prescription",
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                  const Divider(),
                                  GestureDetector(
                                    onTap: () {
                                      DialogPop.showChooseImage(context,
                                          onPressedCamera: () {
                                        _chooseImage(ImageSource.camera,
                                            context: context);
                                      }, onPressedGallery: () {
                                        _chooseImage(ImageSource.gallery,
                                            context: context);
                                      });
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: Container(
                                        width: size.width * 0.8,
                                        height: size.height * 0.2,
                                        color: Colors.black45,
                                        child: _previewImage(size),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
                Visibility(
                  visible: widget.product.description!.isNotEmpty,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text("${widget.product.description}"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/${RouterPath.cart}');
        },
        child: iconCart(Theme.of(context).primaryColor),
      ),
    );
  }

  _chooseImage(ImageSource source, {BuildContext? context}) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: MediaQuery.of(context!).size.width,
        maxHeight: 150,
      );
      setState(() {
        _imageFile = pickedFile;
        base64Image = base64Encode(File(_imageFile!.path).readAsBytesSync());
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }
  }

  Widget _previewImage(Size size) {
    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_imageFile != null) {
      return kIsWeb
          ? Image.network(_imageFile!.path)
          : Image.file(
              File(_imageFile!.path),
              fit: BoxFit.fill,
              width: size.width * 0.3,
              height: size.height * 0.2,
            );
    } else if (_pickImageError != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.file_open_outlined,
            color: Colors.white,
            size: size.height * 0.1,
          ),
          const SizedBox(
            height: 10.0,
          ),
          Expanded(child: Text("Error: $_pickImageError")),
        ],
      );
    } else {
      return Icon(
        Icons.file_open_outlined,
        color: Colors.white,
        size: size.height * 0.1,
      );
    }
  }
}
