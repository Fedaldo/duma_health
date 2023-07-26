import 'package:cached_network_image/cached_network_image.dart';
import 'package:duma_health/models/product_category.dart';
import 'package:duma_health/utils/constants.dart';
import 'package:duma_health/utils/data_manager.dart';
import 'package:duma_health/utils/enumeration.dart';
import 'package:duma_health/widgets/loading_helper.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CategoryList extends StatefulWidget {
  final List<ProductCategory> categories;

  const CategoryList({Key? key, required this.categories}) : super(key: key);

  @override
  State createState() => CategoryListState();
}

class CategoryListState extends State<CategoryList> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: _buildCategories(categories: widget.categories, size: size),
    );
  }
  Widget _buildCategories(
      {required List<ProductCategory> categories, required Size size}) {
    return GridView.builder(
      padding: const EdgeInsets.all(0),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 5.0,
        mainAxisSpacing: 15.0,
      ),
      itemCount: categories.length,
      itemBuilder: (BuildContext context, int itemIndex) =>
          _homeCategory(category: categories[itemIndex], size: size),
    );
  }

  Widget _homeCategory(
      {required ProductCategory category, required Size size}) {
    return GestureDetector(
      onTap: () {
        DataManager.getInstance().currentCategory = category;
        context.push('/${RouterPath.categoryProducts}',extra: category);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                    color: Theme.of(context).colorScheme.secondary, width: 0.2),
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: Container(
                  width: size.width,
                  color: Colors.white,
                  child: CachedNetworkImage(
                    imageUrl: Constants.imagePath + category.image!,
                    placeholder: (context, n) {
                      return LoadingHelper(
                        width: size.width,
                        height: 90,
                      );
                    },
                    errorWidget: (BuildContext context, index, n) {
                      return Image.asset(
                        "assets/logo.png",
                        width: size.width,
                        height: 50,
                      );
                    },
                    width: size.width,
                    height: size.height,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 5.0,
          ),
          Text(
            category.name!,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              letterSpacing: 1,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
