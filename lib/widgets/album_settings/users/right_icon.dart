import 'package:flutter/material.dart';

class RightIcon extends StatelessWidget {
  final Color color;
  final String text;

  RightIcon(this.color, this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: 30,
      decoration: BoxDecoration(
          color: this.color, borderRadius: BorderRadius.circular(5)),
      child: Center(
        child: Text(
          this.text,
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
      ),
    );
  }
}
