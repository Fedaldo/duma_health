import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AddStepper extends StatefulWidget {
  final int lowerLimit, upperLimit, stepValue;
  int value;
  final double iconSize;
  final ValueChanged<dynamic> onChanged;

  AddStepper(
      {Key? key,
        required this.lowerLimit,
        required this.upperLimit,
        required this.stepValue,
        required this.iconSize,
        required this.value,
        required this.onChanged})
      : super(key: key);

  @override
  AddStepperState createState() => AddStepperState();
}

class AddStepperState extends State<AddStepper> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {
            setState(() {
              widget.value = widget.value == widget.lowerLimit
                  ? widget.lowerLimit
                  : widget.value -= widget.stepValue;
              widget.onChanged(widget.value);
            });
          },
          icon: _buttonDecoration(
              child: const Icon(
                Icons.remove,
                color: Colors.white,
              )),
        ),
        SizedBox(
          width: widget.iconSize,
          child: Text(
            '${widget.value}',
            style: TextStyle(
              fontSize: widget.iconSize * 0.8,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              widget.value = widget.value == widget.upperLimit
                  ? widget.upperLimit
                  : widget.value += widget.stepValue;
              widget.onChanged(widget.value);
            });
          },
          icon:
          _buttonDecoration(child: const Icon(Icons.add, color: Colors.white)),
        ),
      ],
    );
  }

  _buttonDecoration({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: child,
    );
  }
}
