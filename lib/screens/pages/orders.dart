import 'package:duma_health/models/grid.dart';
import 'package:duma_health/services/provider.dart';
import 'package:duma_health/utils/enumeration.dart';
import 'package:duma_health/widgets/drop_sort.dart';
import 'package:duma_health/widgets/empty_page.dart';
import 'package:duma_health/widgets/loading_helper.dart';
import 'package:duma_health/widgets/order_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(builder: (context, provider, _) {
      if (provider.apiRequestStatus == APIRequestStatus.loading) {
        return SafeArea(
          child: ListItemHelper(
            divHeight: 0.2,
            isGrid: Grid(),
          ),
        );
      } else {
        return _orderList(provider);
      }
    });
  }

  Widget _orderList(OrderProvider provider) {
    if (provider.orders.isEmpty) {
      return EmptyPage(
        icon: Ionicons.receipt_outline,
        title: "Purchase medical drugs online",
        subTitle: "In one of the best local pharmacies",
        onTap: () {
          context.go('/${RouterPath.categories}');
        },
      );
    }
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            title: const Text(
              "Orders",
              style: TextStyle(
                letterSpacing: 2,
              ),
            ),
            actions: [
              Visibility(
                visible: provider.orders.isNotEmpty,
                child: PopSortOrder(
                  onChanged: (sortBy) => onSortValue(sortBy),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                itemCount: provider.orders.length,
                itemBuilder: (BuildContext context, int itemIndex) =>
                    orderCard(
                      context,
                      order: provider.orders[itemIndex],
                    ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  void onSortValue(value) {
    if (value?.id == 2) {
      Provider.of<OrderProvider>(context, listen: false).sortByOutDate();
    } else if (value?.id == 3) {
      Provider.of<OrderProvider>(context, listen: false).sortByStatus();
    }else if (value?.id == 4) {
      Provider.of<OrderProvider>(context, listen: false).sortByAmount();
    } else {
      Provider.of<OrderProvider>(context, listen: false).sortByInDate();
    }
  }
}
