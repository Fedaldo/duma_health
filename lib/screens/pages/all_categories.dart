import 'package:duma_health/models/grid.dart';
import 'package:duma_health/services/provider.dart';
import 'package:duma_health/utils/enumeration.dart';
import 'package:duma_health/widgets/home/category_list.dart';
import 'package:duma_health/widgets/loading_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AllCategoriesPage extends StatelessWidget {
  const AllCategoriesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("All Categories"),),
      body: SingleChildScrollView(
        child: Consumer<CategoryProvider>(builder: (context, provider, _) {
          if (provider.apiRequestStatus == APIRequestStatus.loading) {
            return ListItemHelper(
              divHeight: 0.15,
              isGrid: Grid(),
            );
          } else {
            return CategoryList(categories: provider.categories);
          }
        }),
      ),
    );
  }
}
