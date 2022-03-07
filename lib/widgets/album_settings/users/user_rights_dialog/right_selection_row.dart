import 'package:flutter/material.dart';

import '../right_icon.dart';

class RightSelectionRow extends StatelessWidget {
  final String text;
  final RightIcon icon;

  RightSelectionRow(this.text, this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              icon,
              SizedBox(width: 10),
              Text(
                text,
                style: TextStyle(fontSize: 17),
              ),
            ],
          )
        ],
      ),
    );
  }
}
