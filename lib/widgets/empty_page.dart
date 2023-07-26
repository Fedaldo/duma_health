import 'package:flutter/material.dart';

class EmptyPage extends StatelessWidget {
  final String title, subTitle;
  final IconData icon;
  final double itemSize;
  final AlignmentGeometry alignmentGeometry;
  final Function onTap;

  const EmptyPage({
    Key? key,
    required this.icon,
    required this.title,
    required this.subTitle,
    this.itemSize = 60,
    this.alignmentGeometry = Alignment.center,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      alignment: alignmentGeometry,
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey.withOpacity(0.4),
            radius: itemSize,
            child: Icon(
              icon,
              size: itemSize,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            title,
            style: const TextStyle(
              letterSpacing: 1,
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            subTitle,
            style: const TextStyle(
              letterSpacing: 1,
              color: Colors.grey,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 10,),
          OutlinedButton(
            onPressed: () => onTap(),
            child: const Text('Start Now'),
          ),
        ],
      ),
    );
  }
}
