import 'package:duma_health/models/grid.dart';
import 'package:duma_health/models/product.dart';
import 'package:duma_health/models/product_category.dart';
import 'package:duma_health/screens/pages/product_list.dart';
import 'package:duma_health/services/api.dart';
import 'package:duma_health/utils/enumeration.dart';
import 'package:duma_health/widgets/icon_cart.dart';
import 'package:duma_health/widgets/loading_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:go_router/go_router.dart';

class CategoryProductsPage extends StatefulWidget {
  final ProductCategory category;

  const CategoryProductsPage({Key? key, required this.category})
      : super(key: key);

  @override
  CategoryProductsPageState createState() => CategoryProductsPageState();
}

class CategoryProductsPageState extends State<CategoryProductsPage> {
  List<Product> _products = [];
  bool isLoading = true;
  List<Product> resultProducts = [];

  bool _hideTextField = true;
  bool isFilling = false;

  _toggle() {
    setState(() {
      _hideTextField = !_hideTextField;
    });
  }

  @override
  void initState() {
    Api.productsCategory("${widget.category.id}").then((values) {
      setState(() {
        isLoading = false;
        _products = values;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            title: Row(
              children: [
                Visibility(
                  visible: !_hideTextField,
                  child: Expanded(
                    child: TextFormField(
                      autofocus: !_hideTextField,
                      decoration: InputDecoration(
                        hintText: "Search",
                        suffixIcon: IconButton(
                          onPressed: () {
                            _toggle();
                            setState(() {
                              isFilling = false;
                            });
                          },
                          icon: Icon(
                            Ionicons.close_circle,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          isFilling = value.isNotEmpty ? true : false;
                          _findProducts(value);
                        });
                      },
                    ),
                  ),
                ),
                Visibility(
                    visible: _hideTextField,
                    child: Text("${widget.category.name}")),
              ],
            ),
            actions: [
              Visibility(
                visible: _hideTextField,
                child: IconButton(
                  onPressed: () {
                    _toggle();
                  },
                  icon: const Icon(Ionicons.search_outline),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                displayProduct(),
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

  Widget displayProduct() {
    if (isLoading) {
      return ListItemHelper(
        divHeight: 0.2,
        isGrid: Grid(it: true, row: 3, height: 120),
      );
    } else {
      return ProductList(
        products: isFilling ? resultProducts : _products,
      );
    }
  }

  void _findProducts(String searchText) {
    var foundP = _products
        .where((element) =>
            element.name!.toLowerCase().contains(searchText.toLowerCase()))
        .toList();
    if (foundP.isNotEmpty) {
      setState(() {
        resultProducts = foundP;
      });
    }
  }
}
