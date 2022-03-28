import 'package:flutter/material.dart';

class TickBox extends StatefulWidget {
  final bool tickable;
  final bool initialValue;
  final Function toggleSelection;

  TickBox(this.initialValue, this.toggleSelection, this.tickable);

  @override
  State<TickBox> createState() => _TickBoxState();
}

class _TickBoxState extends State<TickBox> {
  late bool _isTicked;

  @override
  void initState() {
    _isTicked = widget.initialValue;
  }

  // Ticks the box and calls parent function that will toggle user right
  void _tick() {
    if (widget.tickable) {
      setState(() {
        _isTicked = !_isTicked;
      });
      widget.toggleSelection();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _tick(),
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(width: 1)),
        child: _isTicked
            ? Icon(
                Icons.check_rounded,
                color: Colors.green,
                size: 30,
              )
            : Container(),
      ),
    );
  }
}
