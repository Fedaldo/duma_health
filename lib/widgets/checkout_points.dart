import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class CheckPoint {
  String title;
  IconData iconData;

  CheckPoint({required this.title, required this.iconData});
}

class CheckPoints extends StatefulWidget {
  final int checkedTill;
  final List<CheckPoint> checkpoints;
  final Color checkPointFilledColor;

  const CheckPoints(
      {Key? key,
      this.checkedTill = 1,
      required this.checkpoints,
      required this.checkPointFilledColor})
      : super(key: key);

  @override
  State<CheckPoints> createState() => _CheckPointsState();
}

class _CheckPointsState extends State<CheckPoints> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3.0),
      child: Row(
        children: widget.checkpoints.map((e) {
          int index = widget.checkpoints.indexOf(e);
          return Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: index <= widget.checkedTill
                            ? widget.checkPointFilledColor
                            : Colors.grey.withOpacity(0.6)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          widget.checkpoints[index].iconData,
                          color: index <= widget.checkedTill
                              ? Colors.white
                              : Colors.white.withOpacity(0.6),
                          size:  size.height * 0.025,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Flexible(
                          child: AutoSizeText(
                            widget.checkpoints[index].title,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: index <= widget.checkedTill
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.6),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                index != (widget.checkpoints.length - 1)
                    ? Container(
                        color: index < widget.checkedTill
                            ? widget.checkPointFilledColor
                            : widget.checkPointFilledColor.withOpacity(0.3),
                        height: 2,
                        width: 30,
                      )
                    : const SizedBox()
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
