import 'package:cloud_chest/models/factories/right_factory.dart';
import 'package:cloud_chest/widgets/album_settings/users/user_rights_dialog/tick_box.dart';
import 'package:flutter/material.dart';

class RightSelectionRow extends StatelessWidget {
  final String text;
  final String rightValue;
  final Function passRightToParent;
  final bool isActive;

  RightSelectionRow(
      this.text, this.rightValue, this.passRightToParent, this.isActive);

  // Called by kids whenever the box is ticked
  void _toggleRight() {
    passRightToParent(rightValue);
  }

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
              RightFactory.createIcon(rightValue),
              SizedBox(width: 10),
              Text(
                text,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          // If the right is to view album then it is not tickable
          // This is the minimum right that an user can have therefore empty function is passed
          rightValue == 'content:read'
              ? TickBox(isActive, () {}, false)
              : TickBox(isActive, _toggleRight, true)
        ],
      ),
    );
  }
}
