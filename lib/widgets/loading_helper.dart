import 'package:duma_health/models/grid.dart';
import 'package:flutter/material.dart';

class LoadingHelper extends StatelessWidget {
  final double width, height, radius;

  const LoadingHelper(
      {Key? key, required this.width, required this.height, this.radius = 5})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.03),
        borderRadius: BorderRadius.all(
          Radius.circular(radius),
        ),
      ),
    );
  }
}

class GridHelper extends StatelessWidget {
  const GridHelper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class ListItemHelper extends StatelessWidget {
  final Grid isGrid;
  final double divHeight;

  const ListItemHelper({Key? key, required this.isGrid, this.divHeight = 0.08})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: skeletons(size, isGrid: isGrid, divHeight: divHeight),
        ),
      ),
    );
  }

  List<Widget> skeletons(Size size,
      {required Grid isGrid, required double divHeight}) {
    List<Widget> sks = [];
    for (var i = 0; i < 3; i++) {
      sks.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          child: isGrid.it
              ? Row(
                  children: rowsCard(isGrid,size),
                )
              : productItemHelper(size, divHeight),
        ),
      );
    }
    return sks;
  }

  Widget productItemHelper(Size size, double divHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LoadingHelper(width: size.width, height: size.height * divHeight),
      ],
    );
  }

  List<Widget> rowsCard(Grid grid,Size size) {
    List<Widget> wds = [];
    for (int i = 0; i < grid.row; i++) {
      wds.add(
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: LoadingHelper(
                width: size.width,
                height: grid.height,
                radius: 10,
              ),
            ),
          )
      );
    }
    return wds;
  }
}
